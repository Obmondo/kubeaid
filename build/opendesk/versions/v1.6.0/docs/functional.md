<!--
SPDX-FileCopyrightText: 2025 Zentrum für Digitale Souveränität der Öffentlichen Verwaltung (ZenDiS) GmbH
SPDX-License-Identifier: Apache-2.0
-->

<h1>Functional configuration</h1>

This document addresses the available functional configuration options of an openDesk deployment.

<!-- TOC -->
* [Supported functional configuration](#supported-functional-configuration)
* [Customization of functional options](#customization-of-functional-options)
<!-- TOC -->

## Supported functional configuration

While the openDesk applications allow a wide range of configuration options, only a small subset of them are supported by openDesk. This subset can be found in [`helmfile/environments/default/functional.yaml.gotmpl`](../helmfile/environments/default/functional.yaml.gotmpl)

The following categories are available. Each category contains a set of options to tailor your openDesk deployment to your needs. Please find the actual options including inline documentation in [`functional.yaml.gotmpl`](../helmfile/environments/default/functional.yaml.gotmpl) itself.

* Administrative options (`functional.admin.*`): Options affecting the IAM administrator role (users that are member of the LDAP group `Domain Admins`) of openDesk.
* Authentication options (`functional.authentication.*`): Authentication related settings, e.g. define additional [OIDC](https://en.wikipedia.org/wiki/OpenID#OpenID_Connect_(OIDC)) clients or scopes.
* External Services options (`functional.externalServices.*`): Settings controlling externally available services like APIs.
* Filestore options (`functional.filestore.*`): Configuration options for the filestore component of openDesk, like default storage quota or file sharing options.
* Data Protection options (`functional.dataProtection.*`): Data protection related settings.
* Portal options (`functional.portal.*`): Options to customize the openDesk portal, e.g. if the login dialog should be enforced.
* Chat options (`functional.chat.*`): Configuration options for the chat component of openDesk.
* Migration options (`functional.migration.*`): Helpful setting(s) for migration scenarios.

## Customization of functional options

In case the options from [`functional.yaml.gotmpl`](../helmfile/environments/default/functional.yaml.gotmpl) are not sufficient, you might want to look into [`customization.yaml.gotmpl`](../helmfile/environments/default/customization.yaml.gotmpl). The customizations give you control over all templating that is being done in openDesk, but be aware it is an unsupported approach, so in case you have a strong need for customizations, please let us know by opening a ticket. We will check if it is a use case that can be supported by implementing it as part of the aforementioned [`functional.yaml.gotmpl`](../helmfile/environments/default/functional.yaml.gotmpl).

> **Note<br>**
> You can not directly template your own values in the structure found in [`customization.yaml.gotmpl`](../helmfile/environments/default/customization.yaml.gotmpl), rather, you need to reference your custom value files to overwrite the openDesk defaults. In the app specific `helmfile-child.yaml.gotmpl` files, the openDesk value files are referenced first, then afterwards, the files you define in the customizations are read.
