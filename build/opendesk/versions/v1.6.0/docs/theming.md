<!--
SPDX-FileCopyrightText: 2023 Bundesministerium des Innern und für Heimat, PG ZenDiS "Projektgruppe für Aufbau ZenDiS"
SPDX-License-Identifier: Apache-2.0
-->

<h1>Theming</h1>

This document covers the theming options for an openDesk deployment.

<!-- TOC -->
* [Settings](#settings)
* [Known limitations](#known-limitations)
<!-- TOC -->

# Settings

All default settings can be found in [`theme.yaml.gotmpl`](../helmfile/environments/default/theme.yaml.gotmpl). Most of the components adhere to these settings.

Please review the default configuration that is applied to understand your customization options.

You can just update the files in [helmfile/files/theme](../helmfile/files/theme) to change logos, favicons etc. Note that the `.svg` versions of the favicons are also used for the portal tiles.

> **Note**<br>
> Theming focuses on colors, iconography and imagery. If you like to adapt the default links in the portal pointing to external
> resources (like "Support", "Legal Notice") please check the `functional.portal` section
> in [`functional.yaml.gotmpl`](../helmfile/environments/default/functional.yaml.gotmpl)

# Known limitations

- Portal and Keycloak screen styles, especially colors, must be applied in the [`portalStylesheets.css`](../helmfile/files/theme/portalStylesheet.css),
