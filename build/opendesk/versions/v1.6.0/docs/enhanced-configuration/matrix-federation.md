<!--
SPDX-FileCopyrightText: 2024 Zentrum für Digitale Souveränität der Öffentlichen Verwaltung (ZenDiS) GmbH
SPDX-License-Identifier: Apache-2.0
-->

<h1>Matrix federation</h1>

<!-- TOC -->
* [Example configuration](#example-configuration)
  * [Disable federation](#disable-federation)
  * [Separate Matrix domain](#separate-matrix-domain)
<!-- TOC -->

The Element chat application and its server component Synapse are based on the Matrix protocol,
which supports federation with other Matrix servers, allowing communication with the users with accounts on these servers.

By default, you can chat with users who have an account within your openDesk installation and federate with other
matrix-based servers.
Federation support can be turned off.

# Example configuration

The following values are used in this example documentation.
Please ensure when you come across such a value,
even if it is part of a URL hostname or path, that you adapt it where needed to your setup:

- `opendesk.domain.tld`: the mandatory `DOMAIN` setting for your deployment resulting in
`https://chat.opendesk.domain.tld` for access to the Element chat.
- `my_organization.tld`: an optional alternative domain used for mail and/or Matrix.
It is also set to `opendesk.domain.tld` if not used.

## Disable federation

The following setting can turn off federation:

```yaml
functional:
  externalServices:
    matrix:
      federation:
        enabled: false
```

## Separate Matrix domain

If you want to federate with other Matrix instances and use a separate Matrix domain, you need to provide a JSON file for
the Matrix domain to use delegation. It is not part of your openDesk deployment.

Domain path: `https://my_organization.tld/.well-known/matrix/server`

Content:
```JSON
{
    "m.server": "matrix-federation.opendesk.domain.tld:443"
}
```

More detailed information can be found in the Matrix/Synapse documentation:
[Matrix Delegation](https://element-hq.github.io/synapse/latest/delegate.html)
