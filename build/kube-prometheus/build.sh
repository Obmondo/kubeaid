#!/usr/bin/env bash
#

# This script requires path to cluster folder in clone of customers
# kubernetes-config repo in arg $1 (which must be named clustername and contain
# a clustername-var.jsonnet file) to generate the prometheus manifests for that
# cluster. The manifests will be put in the cluster folder in a kube-prometheus
# subdir.
# And it must be run from the root of the argocd-apps repo. Example:
# ./build/kube-prometheus/build.sh ../kubernetes-config-enableit/k8s/kam.obmondo.com

set -euo pipefail

declare -i apply=0 \
        debug=0

declare dry_run='' \
        cluster_dir=''

basedir="$(dirname "$(readlink -f "${0}")")"

function _exit() {
  if ! (( debug )); then
    if [ -v tmpdir ] && [ -d "${tmpdir}" ]; then
      rm -rf "${tmpdir}"
    fi
  fi
}

trap _exit EXIT

function usage() {
  cat <<EOF
${0} [-a|--apply] [-c|--create-namespaces] [-d|--debug] <CLUSTER>

Compile kube-prometheus manifests from jsonnet template.

Arguments:
  -a|--apply
    Apply the resulting manifests.
  -c|--create-namespaces
    Automatically create any namespaces that doesn't exist when applying.
  -d|--debug
    Leave temporary output folder when exiting.
  --dry-run=<client|server>
    Dry run.
EOF
}

while (( $# > 0 )); do
  case "${1}" in
    -a|--apply)
      apply=1
      ;;
    -d|--debug)
      debug=1
      ;;
    --dry-run=*)
      [[ "${1}" =~ --dry-run=(.+) ]]
      dry_run="${BASH_REMATCH[1]}"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if ! [ -d "${1}" ]; then
        echo "Invalid argument ${1}"
        exit 2
      fi
      cluster_dir="${1}"
      ;;
  esac
  shift
done

if ! [[ "${cluster_dir}" ]]; then
  echo "missing argument cluster_dir"
  exit 2
fi

cluster=$(basename "$cluster_dir")
cluster_jsonnet="${cluster_dir}/${cluster}-vars.jsonnet"

if [ ! -e "${cluster_jsonnet}" ]; then
  echo "no such variable file ${cluster_jsonnet}"
  exit 2
fi

# sanity checks
if ! tmp=$(jsonnet --version); then
  echo "missing the program 'jsonnet'"
  exit 2
fi
if ! [[ "${tmp}" =~ v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  echo "unable to parse jsonnet version ('${tmp}')"
  exit 2
fi

declare -i _version=$(( (BASH_REMATCH[1]*10**6) + (BASH_REMATCH[2]*10**3) + BASH_REMATCH[3] ))
if (( _version < 18000 )); then
  echo "jsonnet version too old; aborting"
  exit 2
fi

# Make sure to use project tooling
outdir="${cluster_dir}/kube-prometheus"

kube_prometheus_release=$(jsonnet "${cluster_jsonnet}" | jq -r .kube_prometheus_version)
if [[ -z "${kube_prometheus_release}" ]]; then
  echo "Unable to parse kube-prometheus version, please verify '${cluster_jsonnet}'"
  exit 3
fi

jsonnet_lib_path="${basedir}/libraries/${kube_prometheus_release}/vendor"

function jb_install() {
  package_name=$1
  package_url=$2

  if ! [[ -d "${jsonnet_lib_path}/${package_name}" ]]; then
    jb install "$package_url"
  fi
}

if ! [ -e "${jsonnet_lib_path}" ]; then
  echo "INFO: '${jsonnet_lib_path}' doesn't exist; executing jsonnet-bundler"
  jb init

  jb_install kube-prometheus "github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@${kube_prometheus_release}"
  jb_install prometheus-mixin github.com/bitnami-labs/sealed-secrets/contrib/prometheus-mixin@main
  jb_install ceph-mixins "github.com/ceph/ceph-mixins@master"
  jb_install cert-manager-mixin "gitlab.com/uneeq-oss/cert-manager-mixin@master"

  mkdir -p "${basedir}/libraries/${kube_prometheus_release}"
  mv vendor "${basedir}/libraries/${kube_prometheus_release}/"
  mv jsonnetfile.json jsonnetfile.lock.json "${basedir}/libraries/${kube_prometheus_release}/"
fi

echo "INFO: compiling jsonnet files into '${outdir}' from sources at ${jsonnet_lib_path}"

# use a temporary dir when compiling to make it an atomic operation
tmpdir=$(mktemp -d)
mkdir "${tmpdir}/setup"

# shellcheck disable=SC2016
jsonnet -J \
        "${jsonnet_lib_path}" \
        --ext-code-file vars="${cluster_jsonnet}" \
        -m "${tmpdir}" \
        "${basedir}/common-template.jsonnet" |
  while read -r f; do
    gojsontoyaml < "${f}" > "${f}.yaml"
    rm "${f}"
  done

rm -rf "${outdir}"
mv "${tmpdir}" "${outdir}"

if (( apply )); then
  kubectl_args=()
  if [[ "$dry_run" ]]; then
    kubectl_args+=("--dry-run=${dry_run}")
  fi
  kubectl apply "${kubectl_args[@]}" -f "${outdir}"
fi
