# 🛠️ Kubeaid Helm Chart Update Guide

This guide explains how to use the `helm-repo-update.sh` script to update Helm charts in the **Kubeaid** repository.

## 📁 Script Location

The script is located at:

```bash
./bin/helm-repo-update.sh
```

Use appropriate flags and tags based on your update requirements.

## 🚀 Common Usage

To update all Helm charts and raise a pull request with commit logs:

```bash
./bin/helm-repo-update.sh --update-all --pull-request --add-commits
```

## 🆘 Help

To see available options, run:

```bash
./bin/helm-repo-update.sh --help
```

| Option | Description | Default / Notes |
|-|-|-|
| --update-helm-chart | Update a specific Helm chart | Requires path to chart |
| --update-all | Update all Helm charts | Default: false |
| --pull-request | Raise a pull request  | Default: false (Only in CI)|
| --actions| Run inside a GitHub or Gitea Action  | Default: false (Only in CI)|
| --skip-charts  | Skip updating certain charts| Default: none  |
| --chart-version| Set chart version  | Default: latest|
| --add-commits  | Add commits since last tag in changelog| Default: false |
| -h, --help  | Show help message  | |

### 🧪 Examples

# Update a specific chart

```bash
./bin/helm-repo-update.sh --update-helm-chart traefik
```
# Update all charts and skip some

```bash
./bin/helm-repo-update.sh --update-all --skip-charts 'aws-efs-csi-driver,capi-cluster,grafana-operator,strimzi-kafka-operator'
```

## 🏷️ Gitea Tag

Once PR is merged create and push new tag to repo.

## 🏷️ Github Tag

Request Klavs or Ashish to do the following:

  - Push this new tag to Github.
  - Publish new release to Github.
