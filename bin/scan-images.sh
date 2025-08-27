#!/bin/bash
# ------------------------------------------------------------------------------
# Script to render all Helm charts in ./argocd-helm-charts and search for
# container image references matching a given keyword (e.g., 'bitnami', 'nginx').
#
# Usage:
#   ./scan-images-v1.sh [-v] <image_keyword>
#
# Example:
#   ./scan-images-v1.sh -v bitnami
#
# This is useful for auditing or tracking where specific base images are used.
# ------------------------------------------------------------------------------
set -e

usage() {
  echo "Usage: $0 [-v]"
  echo "  -v               Verbose output"
  exit 1
}

VERBOSE=0
while getopts "vh" opt; do
  case $opt in
    v) VERBOSE=1 ;;
    h) usage ;;
    *) usage ;;
  esac
done
shift $((OPTIND - 1))

CHARTS_DIR="../argocd-helm-charts"
if [[ ! -d "$CHARTS_DIR" ]]; then
  echo "❌ Error: Charts directory not found at $CHARTS_DIR"
  exit 1
fi

[[ $VERBOSE -eq 1 ]] && echo "🔍 Scanning Helm charts in: $CHARTS_DIR"
[[ $VERBOSE -eq 1 ]] && echo "🔎 Looking for all container images"

for chart in "$CHARTS_DIR"/*; do
  if [[ ! -d "$chart" ]]; then
    continue
  fi

  chart_name=$(basename "$chart")
  [[ $VERBOSE -eq 1 ]] && echo "📦 Rendering chart: $chart_name"
  
  rendered=$(mktemp)
  if ! helm template "$chart_name" "$chart" > "$rendered"; then
    echo "❌ Helm template failed for $chart_name"
    rm -f "$rendered"
    continue
  fi
  
  matches=$(awk '
    /^# Source:/ { src=$0 }
    /image:/ {
      # This simple check filters out comment lines that might contain the word "image:".
      if ($0 !~ /^\s*#/) {
        print src "\n" $0 "\n"
      }
    }
  ' "$rendered")

  if [[ -n "$matches" ]]; then
    echo "✅ Found images in $chart_name:"
    echo "$matches"
  else
    [[ $VERBOSE -eq 1 ]] && echo "✖️ No images found in $chart_name"
  fi

  rm -f "$rendered"
done