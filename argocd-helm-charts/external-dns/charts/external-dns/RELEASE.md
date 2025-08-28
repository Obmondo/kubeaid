### Changed

- Update RBAC for `Service` source to support `EndpointSlices`. ([#5493](https://github.com/kubernetes-sigs/external-dns/pull/5493)) _@vflaux_
- Update _ExternalDNS_ OCI image version to [v0.18.0](https://github.com/kubernetes-sigs/external-dns/releases/tag/v0.18.0). ([#5633](https://github.com/kubernetes-sigs/external-dns/pull/5633)) _@elafarge_

### Fixed

- Fixed the lack of schema support for `create-only` dns policy in helm values ([#5627](https://github.com/kubernetes-sigs/external-dns/pull/5627)) _@coltonhughes_
- Fixed the type of `.extraContainers` from `object` to `list` (array). ([#5564](https://github.com/kubernetes-sigs/external-dns/pull/5564)) _@svengreb_
