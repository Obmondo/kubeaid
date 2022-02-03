#!/usr/bin/env bash

set -euo pipefail

cd build/kube-prometheus

for cluster in htzfsn1-kam htzhel1-kbm; do
  ./build.sh "${cluster}"
done

git diff -- .
