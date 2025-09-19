<!--
SPDX-FileCopyrightText: 2024 Zentrum für Digitale Souveränität der Öffentlichen Verwaltung (ZenDiS) GmbH
SPDX-License-Identifier: Apache-2.0
-->

<h1>Federation with external identity provider (IdP)</h1>

<!-- TOC -->
* [References](#references)
* [Prerequisites](#prerequisites)
  * [User accounts](#user-accounts)
  * [External IdP with OIDC](#external-idp-with-oidc)
* [Example configuration](#example-configuration)
  * [Versions](#versions)
  * [Example values](#example-values)
  * [Keycloak admin console access](#keycloak-admin-console-access)
  * [Your organizations IdP](#your-organizations-idp)
    * [Separate realm](#separate-realm)
    * [OIDC Client](#oidc-client)
  * [openDesk IdP](#opendesk-idp)
<!-- TOC -->

Most organizations already have an Identity and Access Management (IAM) system with an identity provider (IdP) for single sign-on (SSO) to internal or external web applications.

This document helps in setting up your organization's IdP and openDesk to enable IdP federation.

# References

We would like to list successful IdP federation scenarios:

| External IdP                                                        | openDesk versions tested |
|---------------------------------------------------------------------|--------------------------|
| [EU Login](https://webgate.ec.europa.eu/cas/userdata/myAccount.cgi) | v0.9.0, v1.2.0           |
| [ProConnect](https://www.proconnect.gouv.fr/)                       | v0.9.0                   |

> If you have successfully federated using another External IdP, please let us know so we can update the list above.

# Prerequisites

## User accounts

In addition to the configuration, it is required that user accounts with the same name exist within openDesk. While this prerequisite is outside the scope of this document, the following approaches are feasible:

- Manual user management
  - A lightweight option to test your IdP federation setup or if you have only a small number of users to manage.
  - Create and maintain your user(s) in openDesk and ensure the username in your IAM and openDesk is identical.
- User import
  - If you need to create more than just a couple of test accounts, you can use the [openDesk User Importer](https://gitlab.opencode.de/bmi/opendesk/components/platform-development/images/user-import) that utilizes the UDM REST API for user account creation.
  - Downsides: Managing groups and deleting accounts needs to be done manually.
- Automated Pre-provisioning:
  - Pre-provisioning users and groups, including de-provisioning (deleting) accounts, is the best practice to ensure that openDesk is in sync with your organization's IAM.
  - There are at least two ways of implementing the pre-provisioning:
  - UDM REST API:
    - Build a provisioning solution using the [UDM REST API](https://docs.software-univention.de/developer-reference/5.0/en/udm/rest-api.html).
    - The API gives you complete control over the contents of the IAM to create, update, or delete users and groups.
  - Nubus Directory Importer:
    - It is based on a Python one-way directory synchronization for users and groups.
    - Please find more details in the [upstream product's documentation](https://docs.software-univention.de/nubus-kubernetes-operation/latest/en/howto-connect-external-iam.html).
- Ad-hoc provisioning (AHP)
  - This feature is currently unavailable in openDesk's Keycloak, but Univention plans to make it available in the future.
  - Ad-hoc provisioning creates a user account on the fly during a user's first login.
  - While ad-hoc provisioning is an excellent approach for a quick start with openDesk, it has various downsides:
    - Users are created after their first login, so you cannot find your colleagues in the openDesk apps unless they have already logged in once.
    - A user account would never be deactivated or deleted in openDesk.
    - Group memberships are not transferred.

## External IdP with OIDC

This document focuses on the OIDC federation between an external IdP and the openDesk IdP. It uses the OpenID Connect (OIDC) protocol, so your external IdP must support OIDC.

# Example configuration

The following section explains how to configure the IdP federation manually in an example upstream IdP and in openDesk.

With openDesk 1.4.0 IdP federation has to be enabled as part of the deployment using the `functional.authentication.ssoFederation` section, see [`functional.yaml.gotmpl`](../../helmfile/environments/default/functional.yaml.gotmpl) for reference.

You can use the description below to configure and test the federation that can be exported and used as part of the deployment afterwards, e.g. with the following commands from within the Keycloak Pod:

```shell
# Set the variables according to your deployment first, below are just example values.
export FEDERATION_IDP_ALIAS=sso-federation-idp
export NAMESPACE=example_namespace
export CLUSTER_NETWORKING_DOMAIN=svc.cluster.local
# Authenticate with Keycloak
/opt/keycloak/bin/kcadm.sh config credentials --server http://ums-keycloak.${NAMESPACE}.${CLUSTER_NETWORKING_DOMAIN}:8080 --realm master --user ${KEYCLOAK_ADMIN} --password ${KEYCLOAK_ADMIN_PASSWORD}
# Request details of IdP configuration
/opt/keycloak/bin/kcadm.sh get identity-provider/instances/${FEDERATION_IDP_ALIAS} -r opendesk
```

## Versions

The example was tested with openDesk v0.7.0 using its integrated Keycloak v24.0.3. As external IdP, we also used an openDesk deployment of the same version, but created a separate realm for proper configuration separation.

## Example values

The following values are used in this example documentation. Please ensure when you come across such a value, even if it is part of a URL hostname or path, that you adapt it where needed to your setup:

- `idp.organization.tld`: hostname for your organization's IdP.
- `id.opendesk.tld`: hostname for the openDesk IdP, so openDesk is deployed at `opendesk.tld`.
- `fed-test-idp-realm`: realm name for your organization's IdP.
- `opendesk-federation-client`: OIDC client for the openDesk federation defined in your organization's IdP.
- `sso-federation-idp`: Identifier of your organization IdP's configuration within the openDesk Keycloak.
- `sso-federation-flow`: Identifier of the required additional login flow to be created and referenced in the openDesk Keycloak.

## Keycloak admin console access

To access the Keycloak admin console in an openDesk deployment, you must add a route for `/admin` to the Keycloak ingress. This is done automatically if you deploy openDesk with `debug.enabled: true`, but beware that this will also cause a lot of log output across all openDesk pods.

The admin console will be available at:
- Organization's IdP: https://idp.organization.tld/admin/master/console/
- openDesk IdP: https://id.opendesk.tld/admin/master/console/

For the following configuration steps, log in with user `kcadmin` and grab the password from the `ums-keycloak` pod's `KEYCLOAK_ADMIN_PASSWORD` variable.

## Your organizations IdP

In this example, we use the Keycloak of another openDesk instance to simulate your organization's IdP. However, URL paths differ if you use another product.

Please let us know about your experiences or any differences you encountered.

### Separate realm

To not interfere with an existing configuration for our test scenario, we create a separate realm:

- `Create realm` (from the realm selection drop-down menu in the left upper corner)
- *Realm name*: `fed-test-idp-realm`
- `Create`

### OIDC Client

If you just created the `fed-test-idp-realm`, you are already in the admin screen for the realm; if not, use the realm selection drop-down menu in the upper left corner to switch to the realm.

- *Clients* > *Create Client*
  - Client create wizard page 1:
    - *Client type*: `OpenID Connect`
    - *Client-ID*: `opendesk-federation-client`
    - *Name*: `openDesk @ your organization` (this is the descriptive text of the client that might show up in your IdP's UI and therefore should explain what the client is used for)
  - Client create wizard page 2:
    - *Client authentication*: `On`
    - *Authorization*: `Off` (default)
    - *Authentication flow*: leave defaults
      - `Standard flow`
      - `Direct access grants`
  - Client create wizard page 3:
    - *Valid Redirect URLs*: `https://id.opendesk.tld/realms/opendesk/broker/sso-federation-idp/endpoint`
  - When completed with *Save*, you get to the detailed client configuration that also needs some updates:
    - Tab *Settings* > Section *Logout settings*
      - *Front channel logout*: `Off`
      - *Back channel logout URL*: `https://id.opendesk.tld/realms/opendesk/protocol/openid-connect/logout/backchannel-logout`
    - Tab *Credentials*
      - Copy the *Client Secret* and the *Client-ID* as we need them to configure the openDesk IdP.

## openDesk IdP

> **Note**
> While manual configuration is possible, an SSO federation can also be configured as part of the deployment.
> Check `functional.authentication.ssoFederation` section from the `functional.yaml.gotmpl` for details.

The following configuration is taking place in the Keycloak realm `opendesk`.

- *Authentication* > *Create flow*
  - *Name*: `sso-federation-flow`
  - *Flow type*: `Basic flow`
  - *Create*
  - *Add execution*: Add `Detect existing broker user` and set it to `Required`
  - *Add step*: `Automatically set existing user` and set it to `Required`

- *Identity providers* > *User-defined* > *OpenID Connect 1.0*
  - *Alias*: `sso-federation-idp` (used in our example)
  - *Display Name*: A descriptive Name, in case you do not forcefully redirect the user to the IdP, that name is shown on the login screen for manual selection.
  - *Use discovery endpoint*: `On` (default)
  - *Discovery endpoint*: `https://idp.organization.tld/realms/fed-test-idp-realm/.well-known/openid-configuration` - this URL may look different if you do not use Keycloak or a different Keycloak version as IdP in your organization
    - You will get an error if the IdP metadata cannot be auto-discovered.
    - If everything is fine, you can review the discovered metadata for your IdP by clicking on *Show metadata*.
  - *Client authentication*: `Client secret sent as post` (default)
  - *Client ID*: Use the client ID you took from your organization's IdP config (`opendesk-federation-client` in this example)
  - *Client Secret*: Use the secret you took from your organization's IdP config
  - When completed with *Add*, you get to the detailed IdP configuration which at least needs the following update:
    - *First login flow override*: `sso-federation-flow`
    - Depending on your organizations IdP and process preferences, additional configuration may be required

- In case you want to forcefully redirect all users to your organization's IdP (disabling login with local openDesk accounts):
  - *Authentication* > `2fa-browser`
    - Click on the cogwheel next to the *Identity Provider Re-director*
      - *Alias*: `sso-federation-idp`
      - *Default Identity Provider*: `sso-federation-idp`
