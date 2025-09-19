<!--
SPDX-FileCopyrightText: 2024 Zentrum für Digitale Souveränität der Öffentlichen Verwaltung (ZenDiS) GmbH
SPDX-License-Identifier: Apache-2.0
-->

<h1>Separate domains for mail and or Matrix </h1>

<!-- TOC -->
* [Example configuration](#example-configuration)
  * [Mail domain](#mail-domain)
  * [Matrix domain](#matrix-domain)
    * [DNS](#dns)
    * [Webserver](#webserver)
      * [Content Security Policy](#content-security-policy)
      * [.well-known](#well-known)
<!-- TOC -->

As communication over mail and chat can go beyond the borders of your openDesk installation, you may want to use different domains for the mail and/or Matrix.

# Example configuration

The following values are used in this example documentation. Please ensure when you come across such a value, even if it is part of a URL hostname or path, that you adapt it where needed to your setup:

- `opendesk.domain.tld`: the mandatory `DOMAIN` setting for your deployment resulting in `https://mail.opendesk.domain.tld` to access emails and `https://chat.opendesk.domain.tld` to access the Element chat that is based on the Matrix protocol.
- `my_organization.tld`: the alternative domain used for mail and/or Matrix.

## Mail domain

By default, all email addresses in openDesk are created based on the `DOMAIN` you specified for your deployment. In our example, the users have `<username>@opendesk.domain.tld` as their mail addresses. In case you prefer the users to send and receive emails with another domain, you can set that one using the optional `MAIL_DOMAIN` in the deployment:

```yaml
global:
  mailDomain: "my_organization.tld"
```

or via environment variable

```shell
export MAIL_DOMAIN=my_organization.tld
```

Of course, this requires the domain's MX record to point to the mail host for your openDesk deployment. You can optionally add the SPF and DMARC records.

| Record name                | Type | Value                                            |
| -------------------------- | ---- | ------------------------------------------------ |
| my_organization.tld        | MX   | `10 mail.opendesk.domain.tld` |
| my_organization.tld        | TXT  | `v=spf1 +a +mx +a:mail.opendesk.domain.tld ~all` |
| _dmarc.my_organization.tld | TXT  | `v=DMARC1; p=quarantine` |

## Matrix domain

Similar to the specific domain for email addresses, you may want to specify a domain that differs from your deployment's default `DOMAIN` to define your user's Matrix IDs. Use the `MATRIX_DOMAIN` to do so:

```yaml
global:
  matrixDomain: "my_organization.tld"
```

or via environment variable

```shell
export MATRIX_DOMAIN=my_organization.tld
```

### DNS

The following changes apply to the standard DNS:

| Record name                      | Type | Value                                  | Comment                                                                                |
| -------------------------------- | ---- | -------------------------------------- | -------------------------------------------------------------------------------------- |
| _matrix._tcp.my_organization.tld | SRV  | `1 10 PORT matrix.opendesk.domain.tld` | `PORT` is your NodePort/LoadBalancer port of the `opendesk-synapse-federation` service |

*Note:* `matrix.opendesk.domain.tld` in the "Value" column can also be the IP address synapse TLS port listens to.

### Webserver

#### Content Security Policy

The `my_organization.tld` webserver should add `*.opendesk.domain.tld` to its CSP header.

#### .well-known

If you want to use other Matrix clients,
e.g., Element Messenger for [iOS](https://apps.apple.com/de/app/element-messenger/id1083446067)
or [Android](https://play.google.com/store/apps/details?id=im.vector.app),
you need to create a JSON file with the following contents that is served from
`https://my_organization.tld/.well-known/matrix/client`:

```json
{
  "m.homeserver": {
    "base_url": "https://matrix.opendesk.domain.tld"
  }
}
```

The above configuration ensures clients know where to find the Matrix protocol endpoint when users specify `my_organization.tld`
as their homeserver.
