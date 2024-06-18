# Configuring external dns with cloudflare

1. Login to cloudflare.

2. Select "my account" in the right corner.Select api tokens in the left menu

3. Create a token with the rights: Zone:Read, DNS:Edit - limited to the domains it applies to.

4. You can possibly also correctly create subzones (e.g. az1.abc.com) - and then only give access to it.
   so all sites for that cluster must be under az1.kilroy.eu (e.g. argocd.az1.abc.com etc.)

5. Each cluster should preferably not be able to overlap in the dns names they can create themselves.

NB. Do NOT share this token across multple clusters - instead issue one per cluster.
so you can revoke per cluster and also see which cluster is doing what in cloudflare.

## Upgrading external-dns chart

At the time of writing upgrading to the latest version, 0.14.2 posed some issues regarding syncing of CRD's
   Ref - https://github.com/kubernetes-sigs/external-dns/pull/4488 so we are sticking to 0.14.0 for now utill
   the fix is released.
