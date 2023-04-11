# Snapshot CRDs

For convenience this chart packages the `VolumeSnapshot` CRDs from https://github.com/kubernetes-csi/external-snapshotter.

Note that due to the way Helm deals with CRDs, you may want to manually update the CRDs.

CRDs are automatically pulled in using our [CI pipeline](../../../.github/workflows/release.yaml) and always match the
AppVersion in [Chart.yaml](../Chart.yaml).

If you install the chart directly from the directory, please run `make crds` first
