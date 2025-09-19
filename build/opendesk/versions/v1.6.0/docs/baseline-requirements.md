<!--
SPDX-FileCopyrightText: 2024 Zentrum für Digitale Souveränität der Öffentlichen Verwaltung (ZenDiS) GmbH
SPDX-License-Identifier: Apache-2.0
-->

<h1>Baseline Requirements</h1>

* [Preamble / Scope](#preamble--scope)
* [Software bill of materials (SBOMs)](#software-bill-of-materials-sboms)
  * [Artifact SBOMs](#artifact-sboms)
  * [Source code SBOMs](#source-code-sboms)
* [License Compliance](#license-compliance)
* [Software supply chain security](#software-supply-chain-security)
* [Container architectural basics](#container-architectural-basics)
* [Security](#security)
  * [IT-Grundschutz](#it-grundschutz)
* [Accessibility](#accessibility)
* [Data protection](#data-protection)
* [Functionality and features](#functionality-and-features)
  * [Non-overlapping](#non-overlapping)
  * [User lifecycle](#user-lifecycle)
    * [Pull: LDAP](#pull-ldap)
    * [Push: Provisioning](#push-provisioning)
  * [Authentication](#authentication)
  * [Top bar](#top-bar)
    * [Look and feel](#look-and-feel)
    * [Central navigation](#central-navigation)
  * [Functional Administration](#functional-administration)
  * [Theming](#theming)
  * [Central user profile](#central-user-profile)
* [Footnotes](#footnotes)

# Preamble / Scope

This document lays out the requirements for open-source products that should become part of openDesk.

As this is a comprehensive set of requirements most new components will not adhere to all of them.

This document can be used to assess the status and possible gaps for a component which might itself be the basis for a decision if a component should be integrated into openDesk by working on closing the identified gaps.

> **Note**<br>
> Even an already integrated application might not adhere to all aspects of the documented requirements yet.
> Closing the gaps for existing applications therefore is an openDesk priority.

# Software bill of materials (SBOMs)

openDesk is looking into options for in-depth SBOM creation first for container images and later for source code. It is still expected by the suppliers to provide artifact and source code SBOMs in a standardized manner, ideally in the openCode preferred [SPDX 2.2.1](https://spdx.org/rdf/ontology/spdx-2-2-1/) format.

**Reference:** https://gitlab.opencode.de/bmi/opendesk/deployment/SBOM/-/tree/main/sboms/0.5.74

## Artifact SBOMs

There are various free tools like [syft](https://github.com/anchore/syft) available to generate SBOMs for container images. It is expected that this kind of artifact SBOMs is provided (and signed) for all containers delivered to be integrated into openDesk.

**Reference:** As part of [openDesk's standard CI](https://gitlab.opencode.de/bmi/opendesk/tooling/gitlab-config) a container image SBOM is derived from the container's content and gets signed. Both artifacts (SBOM and signature) are placed next to the image in the related registry ([e.g.](https://gitlab.opencode.de/bmi/opendesk/components/platform-development/images/semantic-release/container_registry/827)).

## Source code SBOMs

Today's software development platforms like GitLab or GitHub provide dependency list/graph features that are the basis for your source code SBOMs. These features are usually based on analysis of language-specific package manager dependency definition files. As part of a supplier's software development process, it is expected that source code SBOMs are at least created on the level of the already defined software dependencies within the source code tree of the component.

**Reference:** Currently we do not have source code SBOMs in place.

# License Compliance

All parts of openDesk Community Edition must be open source with source code (also) published or at least publishable on openCode.

openCode provides some boundaries when it comes to open source license compliance openDesk has to adhere to:

- The components must be published under a license listed in the [openCode license allow list](https://wikijs.opencode.de/de/Hilfestellungen_und_Richtlinien/Lizenzcompliance#h-2-open-source-lizenzliste).
- Delivered artifacts (container images) must contain only components licensed under the aforementioned allow list. A container must not contain any artifact using a license from the [openCode license block list](https://wikijs.opencode.de/de/Hilfestellungen_und_Richtlinien/Lizenzcompliance#h-3-negativliste-aller-nicht-freigegebenen-lizenzen).

Deviations from the above requirements must be documented in the openDesk license deviation report.

**Reference:** https://gitlab.opencode.de/bmi/opendesk/deployment/SBOM/-/blob/main/sboms/openDesk%20Deviation%20Report-0.5.74.md

# Software supply chain security

ZenDiS plans to provide secured key storage as a service on openCode.

openDesk is going to implement [SLSA v1.0](https://slsa.dev/spec/v1.0/).

The minimum requirement for all of openDesk's functional components is that all component artifacts (i.e. container images, Helm charts) are signed and their signature can be verified based on the ZenDiS-provided secure key store.

**Reference:** The [openDesk standard CI](https://gitlab.opencode.de/bmi/opendesk/tooling/gitlab-config) ensures that each container image being built and each Helm chart being released is signed. In the case of container images, the related SBOMs are signed as well.

# Container architectural basics

Note: openDesk is operated as a Kubernetes (K8s) workload.

openDesk applications should adhere to best practices for K8s application/container design. While there are dozens of documents about these best practices please use them as references:
- https://cloud.google.com/architecture/best-practices-for-building-containers
- https://cloud.google.com/architecture/best-practices-for-operating-containers

As some applications were initially created years before K8s was introduced they naturally might take different approaches.

You will find below some of the most common best practice requirements, some of which are auto-tested as part of the openDesk deployment automation:

- Containers come with readiness and liveness probes.
- Containers are stateless and immutable (read-only root file system), state should be placed into a database (or similar).
- Allow horizontal scaling (auto-scaling is of course nice to have).
- Provide resource requests and limits (we do not want to limit CPU though).
- Provide application-specific monitoring endpoints and expose the health of the application.
- Write your logs to STDOUT/STDERR and ideally provide JSON-based logs.
- Use one service per container (microservice pattern).
- Minimize the footprint of your container e.g. removing unnecessary tools, ideally providing a distroless container.
- Allow restrictive setting of the security contexts (see [security-context.md](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/-/blob/main/docs/security-context.md) for reference).
- Support for external secrets.
- Support for externally provided/self-signed certificates.

**Reference:** Some of these requirements are tested and/or documented within the deployment automation:
- CI executed Kyverno tests: https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/-/tree/main/.kyverno/policies
- Generated documentation regarding security contexts: https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/-/blob/main/docs/security-context.md

# Security

openDesk should be compliant with the "Deutsche Verwaltungscloud Strategie" (DVS). While this is a moving target it references some already established standards like the BSI's [IT-Grundschutz](https://www.bsi.bund.de/DE/Themen/Unternehmen-und-Organisationen/Standards-und-Zertifizierung/IT-Grundschutz/IT-Grundschutz-Kompendium/it-grundschutz-kompendium_node.html) and [C5](https://www.bsi.bund.de/DE/Themen/Unternehmen-und-Organisationen/Informationen-und-Empfehlungen/Empfehlungen-nach-Angriffszielen/Cloud-Computing/Kriterienkatalog-C5/C5_AktuelleVersion/C5_AktuelleVersion_node.html). These standards address hundreds of requirements which are published at the given links. So here's just a summary to understand the approach of the broadest requirements from IT-Grundschutz.

**Reference:** [Deutsche Verwaltungscloud-Strategie – Rahmenwerk der Zielarchitektur](https://www.cio.bund.de/SharedDocs/downloads/Webs/CIO/DE/cio-bund/steuerung-it-bund/beschluesse_cio-board/2023_11_Beschluss_CIO_Board_DVS_Rahmenwerk_Anlage.pdf)

## IT-Grundschutz

The IT-Grundschutz catalog knowns a lot of modules ("Bausteine"), but not all of them apply to all components, as there are some related to hardware or some just relevant for the operator while openDesk is "just" the software platform. The first step for an IT-Grundschutz evaluation of a component (or the platform as a whole) requires defining which modules are applicable. Other modules apply to all components e.g. [APP.4.4 Kubernetes](https://www.bsi.bund.de/SharedDocs/Downloads/DE/BSI/Grundschutz/IT-GS-Kompendium_Einzel_PDFs_2023/06_APP_Anwendungen/APP_4_4_Kubernetes_Edition_2023.pdf), [SYS.1.6 Containerisierung](https://www.bsi.bund.de/SharedDocs/Downloads/DE/BSI/Grundschutz/IT-GS-Kompendium_Einzel_PDFs_2023/07_SYS_IT_Systeme/SYS_1_6_Containerisierung_Edition_2023.pdf) and [CON.2 Datenschutz](https://www.bsi.bund.de/SharedDocs/Downloads/DE/BSI/Grundschutz/IT-GS-Kompendium_Einzel_PDFs_2023/03_CON_Konzepte_und_Vorgehensweisen/CON_2_Datenschutz_Edition_2023.pdf).

Within each module are multiple requirements ("Anforderungen") that are usually composed of multiple partial requirements ("Teilanforderungen"). Each requirement has a given category:
- B for basic ("Basis") - the requirement must be fulfilled.
- S for standard ("Standard") - the requirement should also be fulfilled, if not there must be a good reason why it is not the case that does not tamper the security of the overall system. There is only a defined amount of deviations allowed for standard requirements.
- H for high ("Hoch") - in certain scenarios you have extended security requirements, in that case, the high requirements must be fulfilled. openDesk is working towards making that possible.

Different requirements address different roles in IT-Grundschutz.

- Supplier: processes & product (component -> e.g. Open-Xchange, OpenProject)
- Provider: processes & product (platform -> openDesk)
- Operator: processes & product (service)
- Customer: processes.

As a supplier of an openDesk component, you will focus on the "Supplier" requirements, while the outcome (your product) must enable the Provider to fulfill the requirements that lay with its responsibility for the openDesk platform. Operators use openDesk to provide a service, therefore the openDesk platform must enable an Operator to fulfill the related requirements. Finally, the service must enable the customer to align with the scope of the IT-Grundschutz catalog. So it will happen that a requirement from e.g. the customer level needs a specific capability by the product (Supplier's responsibility), a defined core configuration from the platform (Provider's responsibility), or a certain service setup from the Operator.

We are aware that IT-Grundschutz is a complex topic and are working towards a streamlined process to reduce overhead as much as possible and ensure to maximize the use of synergies.

**Reference:** https://gitlab.opencode.de/bmi/opendesk/documentation/it-grundschutz

# Accessibility

Accessibility is a key requirement for software that is being used in the public sector. Therefore the products of the suppliers are expected to adhere to the relevant standards.

Please find more context about the topic on the [website of the German CIO](https://www.cio.bund.de/Webs/CIO/DE/digitaler-wandel/it-barrierefreiheit/vorgaben-und-richtlinien/vorgaben-und-richtlinien-node.html) followed by a more detailed look at the actual accessibility standard [WCAG 2.1](https://www.barrierefreiheit-dienstekonsolidierung.bund.de/Webs/PB/DE/gesetze-und-richtlinien/wcag/wcag-artikel.html).

Each vendor must provide a certificate that their product - or the parts of the product relevant for openDesk - complies with at least WCAG 2.1 AA or [BITV 2.0](https://www.bundesfachstelle-barrierefreiheit.de/DE/Fachwissen/Informationstechnik/EU-Webseitenrichtlinie/BGG-und-BITV-2-0/Die-neue-BITV-2-0/die-neue-bitv-2-0_node.html). As the certification and related product improvements are time-consuming the focus of openDesk is that a supplier provides a plan and certification partner (contract) that shows the supplier is working towards the certification. While the aforementioned standard states the priority is the "A" level requirements, the "AA" level must be met at the end of the process.

> **Note**<br>
> Please keep in mind that WCAG 2.2 and 3.0 are work in progress. If you already work on accessibility improvements you might want to take these standards already into consideration.

**Reference:** In the past the [accessibility evaluations](https://gitlab.opencode.de/bmi/opendesk/info/-/tree/main/24.03/Barrierefreiheit) have been executed by Dataport. But they do not do certifications.

# Data protection

Each component must be able to operate according to the [EU's General Data Protection Regulation (GDPR)](https://gdpr.eu/). This requires some key messages to be answered when it comes to personal data[^1]:

- Who are the affected data subjects?
- What personal data (attributes) from the subjects is being processed?
- Who is the controller and processor of the subject's data?
- Which processing activities involve which data attributes?
- How can the data be deleted?
- Are personal data-related activities traceable?
- How can data be provided uniformly to affected people?
- What does a data privacy-friendly configuration look like?

While this can be answered by each component that will be in the spotlight for the suppliers, we also need an aligned overall picture for openDesk that at least has the platform-specific user lifecycle and cross-application interfaces in focus.

Note: The topics of availability, integrity, and confidentiality of personal data are also being addressed by the IT-Grundschutz module "CON.2". It has to be ensured that it is not in contradiction to what is being done in the general area of data protection.

**Reference:** https://gitlab.opencode.de/bmi/opendesk/documentation/datenschutz

# Functionality and features

## Non-overlapping

To avoid having functionality twice in openDesk it might be required to disable certain functionality within a component. There needs to be an assessment for each new component if it has overlapping functionality and how to deal with that.

**Reference:** The contact management from Nextcloud is done in OX, so Nextcloud has its internal contact management disabled, as well as most of the Nextcloud Talk functionality, due to the presence of Element and Jitsi.

## User lifecycle

With a central Identity- and Access Management (IAM) also the user lifecycle (ULC) that addresses account create-update-delete actions with support for "inactive" accounts must be harmonized within the platform.

The focus is to have all the account information in all applications including the account's state, profile picture ([reference](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/-/issues/27)) and - where required - the user's group memberships. This cannot be done purely by pushing that data through OIDC claims when a user logs in to an application therefore two ways of managing an account are applicable and described in the following subchapters.

> **Note**<br>
> Allowing ad hoc updates of account data through OIDC claims during login is still encouraged.

### Pull: LDAP

Applications can access the IAM's LDAP to access all data necessary for managing their part of the ULC.

**Reference:** Most applications use LDAP access as per https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/-/blob/main/docs/components.md?ref_type=heads#identity-data-flows

> **Note**<br>
> The direct access to LDAP is going to be deprecated for most use cases. openDesk is looking into active provisioning of the user/group data into the applications using [SCIM](https://scim.cloud/).

### Push: Provisioning

Some applications require active provisioning of the centrally maintained IAM data. As the actual provisioning is part of the openDesk provisioning framework it is necessary to define the ULC flow regarding its different states to get a matching provisioning connector implemented. This is done collaboratively between the supplier and openDesk product management.

**Reference:** New applications will make use of the [provisioning framework](https://gitlab.opencode.de/bmi/opendesk/component-code/crossfunctional/univention/ums-provisioning-api). At the moment to only active (push) provisioned component is OX AppSuite fed by the [OX-connector](https://github.com/univention/ox-connector/tree/ucs5.0).

## Authentication

The central IdP ensures the single sign-on and logout workflows. As standard openDesk uses [Open ID Connect](https://openid.net/). It can be configured to provide additional user information from the IAM when required by a component.

Minimum requirements regarding the OIDC support in an application besides the actual login flow:

- Back-channel logout: [OIDC Back-Channel Logout](https://openid.net/specs/openid-connect-backchannel-1_0.html) must be supported by the components unless there is a significant reason why it technically cannot be supported, in that case [OIDC Front-Channel Logout](https://openid.net/specs/openid-connect-frontchannel-1_0.html) is the alternative.
- IdP Session Refresh: Ensure that your application regularly checks the IdP session for its validity and invalidates the local session when there is no longer an IdP session.

**Reference:** Most applications are directly connected to the IdP and are using OIDC: https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/-/blob/main/docs/architecture.md#identity-data-flows

## Top bar

The top bar of all applications should provide a common UX.

### Look and feel

The current status is subject to review, but the basics will most likely stay the same. Ensure that the top bar can be customized (or adheres to a given openDesk standard) in various settings:

- Size (height) of the bar.
- Foreground and -background colors, including hover/active.
- Size and color of the bar's bottom line.
- Logo position, size, and link including the link's target.
- Icon position and size of the central navigation.
- Ideally have the user's menu on the right-hand side of the top bar using the user's profile picture.
- Have the search option/bar as the leftmost option in the right content section of the top bar or even allow the search bar to be rendered in the center of the top bar.

**Reference:** This is available in current deployments, see e.g. Nextcloud, Open-Xchange, and XWiki.

### Central navigation

From the top bar, the user can access the central navigation. A menu that gets its contents from the portal, rending the categories and (sub-)applications available to the logged-in user.

When implementing the central navigation into an application there are two options to access the user's data from the portal:

- Frontend-based: Issuing an IFrame-based silent login against the intercom service (ICS) to get a session with the ICS, followed by a request for the JSON containing the user's central navigation contents through the ICS.
- Backend-based: Requesting the JSON using a backend call to the portal providing the user's name and a shared secret.

**Reference:** This is available in current deployments in all applications except for Jitsi, Collabora, and CryptPad.

## Functional Administration

While applications usually support technical and functional administration the technical part should be in the responsibility of the operator and is usually done at (re)deployment time. Therefore the administrative tasks within an application should be limited to functional administration.

Example for "technical administration":
- Configuring the SMTP relay for an application to send out emails.

Example of "functional administration":
- Creating and maintaining users and groups.

**Reference:** OpenProject took the approach that all settings pre-defined in the deployment are still rendered in the admin section of OpenProject, but can not be changed.

## Theming

Theming should be controlled with the deployment and affect all components that support branding options.

**Reference:** https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/-/issues/27

## Central user profile

The user profile is maintained centrally, therefore the applications should make use of that central data and not allow local editing of the data within the application except for data that is required by the application and cannot be provided by the central IAM.

The data can still be rendered but must not be tampered with in any way within an openDesk application outside of the IAM, as it would either cause inconsistent data within the platform or the changed data being overwritten, which is at least unexpected by the user.

The user's preferred language and theme (light/dark) are also selected in the IAM's portal and the setting should be respected in all applications.

**Reference:** No reference yet.

# Footnotes

^1: For definitions see [GDPR Article 4](https://gdpr.eu/article-4-definitions/).
