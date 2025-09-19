# [1.6.0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v1.5.0...v1.6.0) (2025-07-14)


### Bug Fixes

* **dovecot-pro:** Use of `requiredEnv` instead of `env` and update `README-EE.md` ([a79e40f](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a79e40f44af68a16f0944265cc447ec9b0d84922))
* **helmfile:** Prefix NATS passwords as workaround for upstream issue and add documentation to `gettings-started.md` [[#185](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/issues/185), [#202](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/issues/202)] ([7f478bf](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7f478bffd60bdf3af536bc593ef397d823a22e88))
* **helmfile:** Remove default setting from `repositories.helm.registryOpencodeDeEnterprise` for better support of `PRIVATE_HELM_REGISTRY_URL` ([c5dd881](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c5dd8814ae7576eaaf7cfcdd1cb4aa101f164c62))
* **helmfile:** Set `nubusKeycloakBootstrap` debug mode when openDesk is running in debug mode ([4e0ffee](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/4e0ffeea1f9d0420c404d78c5188ff6bdb0f81ea))
* **helmfile:** Streamline license header comment style [[#192](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/issues/192)] ([20cbad3](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/20cbad31e75d9ae27081675072561650fa168935))
* **nubus:** Explicitly template `nubusStackDataUms.stackDataContext.portalFqdn` to fix custom hostname support [[#193](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/issues/193)] ([6aa6d3a](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6aa6d3af2fed1be99b4f4eb5de2e2703ca00578a))
* **nubus:** Replace openDesk portal fork with upstream `portal-frontend` image ([e4f1afc](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e4f1afca0fdf4af184f4e287f1317ed57d229013))
* **nubus:** Update from 1.11.1 to 1.11.2 ([237c9af](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/237c9af3c16885b51dcd1d7c793bf7fd23dbcefb))
* **open-xchange:** Add missing `imagePullSecrets` for `core-imageconverter` and `core-documentconverter` ([9b7f439](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/9b7f439d83c9cd5a60b70f8d3ba7d36bb35ebd5c))
* **open-xchange:** Enable `com.openexchange.smime.test` only when openDesk is running with `debug.enabled: true` ([51ff7a5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/51ff7a5fdb7b7f3bdef02a32e44e6204df9db6ea))
* **open-xchange:** Enable searching by LDAP `mailAlternativeAddress` when resolving global contacts. Note: OX App Suite evaluates all `mailAlternativeAddress` values of a user when searching, but only the first address is returned, which might differ from the one that matched the search criteria. ([9014324](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/90143241564d7e66bf1b864c704e13c677dcbc93))
* **open-xchange:** Use `objectstore.dovecot.secretKey` when defined ([5c33226](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/5c332264edfcbb3343bcfd39352db6ddefd0a85c))
* **opendesk-services:** Add missing certificates ([acbabdb](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/acbabdb80662bf0599a157b24d3f8461e1f98cad))
* **openproject:** Update from 16.1.0 to 16.1.1 ([e30d4f1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e30d4f126dda29183cffc078307d41d3dce6f4fa))


### Features

* **collabora:** Update from 24.04.13 to 25.04.2 ([c56f564](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c56f564025531d25a1966792f8c161aedf644c99))
* **element:** Update NeoBoard from 2.1.0 to 2.2.1, NeoChoice from 1.5.1. to 1.5.2, NeoDateFix from 1.7.0 to 1.7.1 widgets and NeoDateFixBot from 2.8.2 to 2.8.3 latest releases ([98d31f8](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/98d31f811bdb007e40c4b3436ff65cdcf610db7e))
* **helmfile:** Add options in `functional.yaml.gotmpl` for setting the portal's corner links, toggling the welcome message and the newsfeed ([1a6f438](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1a6f438724cc442ca7b9c423a326c67690510301))
* **nextcloud:** Update from 30.0.10 to 31.0.6 and support for notify-push ([a4c8be6](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a4c8be60f335af98270e40478e53e6fa34c23d38))
* **nubus:** Update from 1.9.1 to 1.11.1; required minimum openDesk version for this upgrade is 1.5.0, see `migrations.md` for details ([ccd5ab8](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/ccd5ab84e3f5bb67eb879a3683c299d7a61ddba0))
* **open-xchange:** Store attachments for calendar, contact and task objects in object storage; review `migrations.md` for required upgrade steps ([4eb6570](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/4eb6570b0a69931f09042bdc40edfad23e6f28c1))
* **open-xchange:** Updated OX App Suite from 8.37 to 8.38 ([2b31751](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/2b317514c61eba4ebc4cc9e7041aac606d8c16b8))

# [1.5.0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v1.4.1...v1.5.0) (2025-06-16)


### Bug Fixes

* **dovecot:** Enable Dovecot ACL for CE (file) & EE (cassandra) ([9354ee7](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/9354ee719628c876c26e91e1b57a4a0cfafedca1))
* **notes:** Support templating of Ingress annotations `bodyTimeout` and `bodySize` to allow application defined upload limits to be reached ([69faf77](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/69faf77d15d1df441eb62c58374620f8035f2596))
* **nubus:** Create required LDAP objects for `global.additionalMailDomains` ([4dcb683](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/4dcb6831189fc9cedb244c3fd7997d57e8a78c5a))
* **nubus:** Explicitly template security context for Keycloak proxy ([e959438](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e9594382ed7a2469240d62134b34bcf3e5d06a59))
* **nubus:** Update CSS for login screen to show login button for federated IdP ([0d4e1b0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/0d4e1b01e3e82ace7f7438a754235a009036b90d))
* **nubus:** Use read-only root filesystem for Keycloak bootstrap ([1edd7c3](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1edd7c3f062ec411b8b38f45be9ef22a200b4bea))
* **open-xchange:** Enabled mail login resolver ([7547f49](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7547f4948ea13357c4cbc3ae69ae4e7210fdf4a2))
* **open-xchange:** Update App Suite 8.37 to latest patch level (8.37.69) ([bc436b2](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/bc436b248525bf76584dd21f735694065bcb67a5))
* **open-xchange:** Update Dovecot CE chart to support ACLs (mailbox sharing) and usernames different from local part of mail address ([87c30ab](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/87c30ab8e32c1b405f6aff8eda5eed5f74d5df0a))
* **open-xchange:** Use login name instead of email between OX and Dovecot ([8e9ef08](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/8e9ef0867beb8381ad4a5f55f2e9d12bd7dbbba2))
* **openproject:** Update from 16.0.0 to 16.0.1 ([b60f9c7](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b60f9c7576deca327ad36c48ad0b1a7e3e9d3c9c))


### Features

* **ci:** Update Helm to 3.18.1 and Helmfile to 1.1.1 ([59a4086](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/59a40864edbdf9775e0d6003425c3b05b7b7cb15))
* **notes:** Update from 2.4.0 to 3.2.1 ([9f4e3c8](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/9f4e3c86c74ef6c6f618150a7a9d0935fb5ed437))
* **open-xchange:** Support for `mailAlternativAddress`(es) for sending and receiving emails ([6d6b1a6](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6d6b1a6dd754dcb283fd23f08f9df937f8e08c59))
* **openproject:** Update from 15.5.1 to 16.0.0 including Helm chart update ([add7266](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/add72669aedfcd57b41fe8680f14940ab77f6aef))

## [1.4.1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v1.4.0...v1.4.1) (2025-06-02)


### Bug Fixes

* **nextcloud:** Update NC CE to 30.0.10 ([785be8b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/785be8b6621305e79acca62250720028b9ca7a30))
* **nextcloud:** Update Nextcloud incl. apps to 30.0.10 ([559fbf6](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/559fbf6801fc785f26f9e6287e0730f86b459a01))
* **nubus:** Use `.Values.theme.texts.productName` for Keycloak's `loginTitle` instead of static product name string ([d1a1e5d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d1a1e5dc29ca21fd822abd127406f6859603b9c7))
* **open-xchange:** Re-adding `com.openexchange.oauth.provider.*` to fix central contacts feature ([561e44f](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/561e44fd4cc42089954868da60edbd210b9a2608))
* **open-xchange:** Set `com.openexchange.hostname` to get working links in outgoing system mails (e.g. task assignments) ([0d61687](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/0d616871e3f5114ec429714658500c09af842fe6))
* **postfix:** Require TLSv1.3 ([3b3d8ac](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/3b3d8aca54bdaea055289c993e3f158d93864223))
* **requirements.md:** Helm 3.18.x is not supported due to upstream bug ([1ea9cae](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1ea9cae1ce46f864dc03d94c1a72956c5f5ba9a9))

# [1.4.0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v1.3.2...v1.4.0) (2025-05-20)


### Bug Fixes

* **docs:** Update requirements, bump helmfile to v1.0.0 ([88b29c5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/88b29c57e8197f072b9c80019255ee0b7d1188e1))
* **dovecot:** Encode object storage password and add more template values ([c40de73](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c40de73ccf02bf77df0c3a17c2fccf2e113c4b35))
* **nubus:** [[#182](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/issues/182)] Add `KC_TRUSTSTORE_PATHS` to Keycloak when using self-signed certificates ([006aed7](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/006aed791e5cf58850712e468a15c8abe1ee0973))
* **nubus:** [[#183](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/issues/183)] Do not override `nubusPortalConsumer.waitForDependency.image` when using self-signed certificates ([b45a0bf](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b45a0bf832506fb60488cd01c9c883b58e1d60b6))
* **nubus:** Update ArgoCD hook annotations ([f2b1384](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/f2b13846700d8a49a066b3343b043dac89d326f5))
* **open-xchange:** Update Open-Xchange to v8.36 ([b40b863](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b40b8630c1a5ba7452d0461d38b1175fa647226d))
* **open-xchange:** Update Open-Xchange to v8.37 ([174c73c](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/174c73c012e911342644bdcb89d22b35be9baa36))
* **openproject:** Update to 15.5.1 ([e91efa8](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e91efa8ecc1be9b444092e1a291747bb9f0c00ea))
* **openxchange:** Add proper dav URLs in client onboarding and disable unnecessary oauth section ([bba2af0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/bba2af0f06942bd2063cc7b79f3e39fdb07838f0))
* **openxchange:** Disable redundant o-x-authentication-oauth package ([1d2b17b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1d2b17b4951581e1f60d8a7f2402512dc1c1c568))
* **openxchange:** Enable DAV support ([709e50f](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/709e50ff7c020347dad953be7380d08438d3ab69))


### Features

* **collabora:** Update enterprise image to 24.04.13.4.1 ([b590810](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b5908100ddbd7497f7f858e874bcbf7979480d1b))
* **helmfile:** Define `global.additionalMailDomains` as list; if you use the setting already, check `migrations.md` for details ([4b30576](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/4b305768c444c166e28829ee05631451ba997126))
* **helmfile:** Option to select default file format for weboffice using; see `functional.weboffice.defaultFormat` in `functional.yaml.gotmpl` for details ([5f58a85](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/5f58a857acab38fa7f56e1e14ef0a6f805c7622e))
* **nubus:** Update nubus to v1.9.1 ([3d694a8](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/3d694a8248d5e983ab3e05753326088b375f2d82))

## [1.3.2](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v1.3.1...v1.3.2) (2025-05-06)


### Bug Fixes

* **dovecot:** Update Helm chart to fix migration mode ([7ba84b9](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7ba84b99caf61e5a4a35b71d875e9ede0f71423e))
* **helmfile:** Explicitly template auth-modules in OX App Suite; Streamline name of OX App Suite EE image ([6cbb6b6](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6cbb6b6922864467ca365bcc9b1cfa49182df050))

## [1.3.1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v1.3.0...v1.3.1) (2025-04-24)


### Bug Fixes

* **ci:** Update Helm to v3.17.3 ([9446faa](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/9446faaa597777e9fb15d33953e02fdbfef646b2))
* **ci:** Update Helm to v3.17.3 ([d794a20](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d794a2036ed6543bf89a0b661cc8a4c8a383a5f0))
* **docs:** Update "Ingress controller" section and add footnote on volume provisioner in `requirements.md` ([17efbd7](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/17efbd79f177f635885735823696a6e50b919d3e))
* **helmfile:** Conditional templating of additional annotations in selected components to unblock openDesk deployment despite a bug in Helm 3.17 (https://github.com/helm/helm/issues/30587) ([861b84b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/861b84b14de9fb42c483f3ddb9e083305750d137))
* **postfix:** Disable unauthenticated relaying of mails in `postfix-ox` ([7414f05](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7414f05005e019f2121e8458fe63e795819fe92c))

# [1.3.0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v1.2.1...v1.3.0) (2025-04-22)


### Bug Fixes

* **helmfile:** Fix Kyverno lint issues for EE components ([46b3834](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/46b38342d3cb6789e1734cd6eba412bc726c834b))
* **helmfile:** Remove no longer used `secrets.nubus.defaultAccounts.*` ([6e6d155](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6e6d15552e87a77870755db3b48f2af686916c1f))
* **helmfile:** Support for Keycloak session settings via `functional.authentication.realmSettings.*` ([3fcfa00](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/3fcfa00503854f752a3885321b16b3f3597cb09a))
* **migrations:** Optional delete of `ums-minio-rewrites` Ingress, as it is non-existing in deployments with external object storage ([6932953](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/693295391bb02892b537a48513c9e0c2824ed466))
* **ox-connector:** Update to v0.19.0 ([fe664a7](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/fe664a7f8d696fea53b6abadec5a0cb5db751f43))
* **xwiki:** Update Helm chart to v1.4.4 to fix the problem with XWiki not starting when secrets contained specific (XML interpreted) characters ([67a1df0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/67a1df0f80dc598287174a8dd6bda3f477227f0d))


### Features

* **collabora:** Update to 24.04.13 ([8f12208](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/8f12208074b2947ec65ebc3c21920d4f775e0c6e))
* **helmfile:** Add template support for annotations ([9cde57d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/9cde57d74b8cfdd09e4f6b82cf45f1b1a686e035))
* **helmfile:** Support for SSO federation; see `ssoFederation` section in `functional.yaml.gotmpl` for details ([79975a5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/79975a58e3a4f50e59d1d790045c22a32ab49372))
* **nubus:** Show openDesk version to all users (instead of admin users only) ([393ee31](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/393ee311630630fd1aae8354ead90bcaaf5e4dba))
* **nubus:** Update to 1.8.0 ([90c49f6](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/90c49f6f83df0b34b86c17164eaa4e137d0cd9be))
* **openproject:** Update to 15.5.0 ([7f1cfc5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7f1cfc55551f608603e0401dfef24bbb9cc334e5))

## [1.2.1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v1.2.0...v1.2.1) (2025-03-28)


### Bug Fixes

* **dovecot:** Support external secrets ([f758685](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/f758685a2eb4c04bad6bce103cc5ba273c80606d))
* **element:** Update Synapse to 1.127.1; Fixes https://www.cve.org/CVERecord?id=CVE-2025-30355 which applies to Synapse installations with unrestricted (no allow list) federation enabled ([5cd12b9](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/5cd12b91c78269b84749280e71aee0fcb195da17))
* **openproject:** Update to 15.4.2 ([aa8e30b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/aa8e30b34f24302c756b2297b05e138d15ed0d2d))

# [1.2.0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v1.1.2...v1.2.0) (2025-03-25)


### Bug Fixes

* **collabora:** Set proper theming for Collabora Online (openDesk EE) ([896b3c1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/896b3c102cd59a9c4d0ae28457261a4749b37a6d))
* **collabora:** Update to 24.04.12 ([4296db7](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/4296db7c90c93c3c268a7642ae920d412cb70429))
* **dev-tooling:** Fix path names when refencing local Helm chart copies in `helmfile-child.yaml.gotmpl` files ([60f5e36](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/60f5e36b7cf183ac9f15b0e56b486e642c54ac4d))
* **docs:** Add `functional.md` and reference it in `getting-started.md` ([0efc0af](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/0efc0af761703a63392034df3f34acf569174e0c))
* **docs:** Add testing.md ([c4e4258](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c4e425816272951082fa15f1ab4ff4aee4a4598d))
* **dovecot:** Update EE Helm chart to resolve issue with mandatory set `PriorityClass` ([696f2da](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/696f2daa9c3df6b0db744d81bd6e159b3f9be440))
* **element:** Run UVS container as a non-root user ([f262507](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/f26250774e4bdb157181c3c8fe5c51f7429771ed))
* **element:** Update NeoChoice and NeoBoard widget to latest releases ([7456543](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7456543d81625599372f781f963fe5902f969627))
* **helmfile:** Add missing `deletePodsOnSuccessTimeout` statements ([87144b8](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/87144b8fd3268ad8196673999241ed1a1bf234fa))
* **helmfile:** Support for `functional.externalServices.matrix.federation.domainAllowList` ([817af98](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/817af98fcdf9bca0028365796fb17a8cd5d9f4f9))
* **intercom:** Allow transient session cookies and rolling session duration configuration ([4d59d12](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/4d59d12a9703e05cb6bc47fe413ebcaafdcb4c8b))
* **intercom:** Update to Intercom Service v2.10.3 ([7b05213](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7b05213d6eaa96717e368bc68b79af44c9b3d921))
* **jitsi:** Update chart to v3.1.0 incl. a fix in room history toggle ([1480253](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1480253a52e5a9848b626f60b7fb75ad7c43c4a5))
* **migrations:** Explicit scoping of role required for access to the migration's ConfigMap ([02488fe](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/02488fe2dd84046735bdb9351e47d4508eaf191f))
* **nextcloud:** Disable integration with OX App Suite if groupware it is not available ([fdfe76c](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/fdfe76c37e597534b2a8b4bf609e28628aabff3e))
* **nextcloud:** Update apps and support branding of the HTML title ([bc55f6a](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/bc55f6a366398aae497bde8d81b9663b04f992de))
* **nextcloud:** Update images for improved log output ([f1147f0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/f1147f0fdf12271c47225f81069013afdf8bd5f3))
* **nextcloud:** Update images to allow logging in environments where inotify cannot be used ([0110675](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/01106757da8d8d5a60629126a794c1d61d850f0b))
* **nextcloud:** Update to 30.0.6 including latest apps ([52b0b13](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/52b0b13e6bf4be738bd29029d1f2940e93a99045))
* **nubus:** Add imagePullSecrets to nginx-s3-gateway ([466b70a](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/466b70a9bb9bbbaf25c920fcca965388eb4d0350))
* **nubus:** Add migrations for Nubus 1.7.0; See migrations.md for details ([7d7e9e6](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7d7e9e65b32e6445b45edcb8bf15f64f79d63a2f))
* **nubus:** Always use S3 gateway for assets ([1e62a0d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1e62a0dfe14ccd840e910d6aea79fb7beabb8da5))
* **nubus:** Change logo URLs for apps referencing the openDesk logo provided by Nubus ([5d398f5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/5d398f5d64fd03ad9e9a3898424f485fef8888b1))
* **nubus:** Cleanup of unnecessary LDAP groups; customization option to show the OX App Suite context selection in the IAM's admin UI ([4c42ed7](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/4c42ed76e82fc0cd517a7409e21cadb757fdac8a))
* **nubus:** Delete now legacy Ingress `ums-minio-rewrites` ([1c50aa5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1c50aa5ce2ffef4446b28504c461faf84ef856c8))
* **nubus:** Fix mixed up links for legal and privacy statement ([dbcc785](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/dbcc785134a79ebe500724739338702c5e6772a3))
* **nubus:** Indent `nubusPortalConsumer.persistence.groupMembershipCache` causing `persistence.storages.nubusPortalConsumer.*` to be ignored; See migrations.md for details ([baa5b14](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/baa5b14551f405a5e17ddfc62733c98868a1f205))
* **nubus:** Register OX provisioning consumer only when OX is enabled; See migrations.md for details ([adb3fa1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/adb3fa18eb36de91927c8118493038b400ff77d5))
* **nubus:** Remove unnecessary inactive portal tiles and folders ([1724fa1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1724fa14a3fcab9473da06f7702eb248eef334c6))
* **nubus:** Update openDesk customizing: Preset openDesk specific attributes on `Administrator` account; Remove unused portal categories ([6edfe72](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6edfe7239fd3916be71f830543c01084100b8aba))
* **opendesk-services:** Add notes to certificate resource ([d18abb0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d18abb0d0a2e011065a6c40f80f56bbdb5a48a90))
* **openproject:** Update `opendesk-openproject-bootstrap` to support external secrets ([41e0aae](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/41e0aaeffec3e0b4f83662b4381713d2480533fc))
* **openproject:** Update to 15.3.0 including update for seeding relevant environment variables ([a6de1fe](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a6de1fe694e7cbee88db5a0688b60e7c8d8e4cff))
* **openproject:** Update to 15.3.1 ([f34a4a3](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/f34a4a360178f3a54cfe45198c4717241a9c5289))
* **openproject:** Update to 15.3.2 ([6723a34](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6723a34c229fb683d5adb1c8c900afb0c3f24087))
* **openproject:** Update to 15.4.0 ([2a0f2a3](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/2a0f2a33330e149f8b4b26a3b3c5273274b2c0ca))
* **openproject:** Update to 15.4.1 ([747cae5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/747cae545abf186b8ec19b5203cdf47c67667601))
* **openxchange:** Template HTML title from `.Values.theme.texts.productName` ([2e992fc](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/2e992fc23606a497d770e44fb3afeada1f5d54dd))
* **openxchange:** Update to latest 8.35 patch level ([44c2081](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/44c2081bd860bd66204d2648f287fc6c5b928faa))
* **ox-connector:** Update to v0.14.7 ([dd3b35b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/dd3b35b626d860389fad4fc0541dc962fe51c060))
* **postfix:** Add internal authentication ([2389d59](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/2389d597358f53e43be5982e29125eabda94bf6c))
* **postfix:** Add recipient delimiter support ([f92b76b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/f92b76b2b28c7955123f83881d23f719ea8dfd5c))
* **requirements.md:** Set Ingress NGINX 1.11.5 as requirement ([2bf8e1d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/2bf8e1de9873e15501b282d8e0d16350559e54dd))
* **synapse:** Use synapse-guest-module by Element (supplier) ([2730b03](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/2730b03e701922c3b14fdd5f8e8dfb64223b3edc))


### Features

* **helmfile:** Use PostgreSQL as default database for Nextcloud and XWiki;  follow `migrations.md` when upgrading an existing environment ([2f584bd](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/2f584bd8e82ab7262659d6b24613f214f6e9ad25))
* **nextcloud:** Support external secrets for metrics token ([dbec2ec](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/dbec2ec36f5019bc0f5e9769ab02701ebac4aa2c))
* **notes:** Update to v2.4.0 ([3d35440](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/3d35440dc76c703872488ec468649ed274099fd5))
* **nubus:** Support of external secrets in opendesk-keycloak-bootstrap ([3d2f751](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/3d2f75165a571a67d08f7e9588297c70fc808179))
* **nubus:** Update to v1.7.0 ([d018385](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d018385473df1f5154e15ca8c55145d10e713797))
* **openxchange:** Update to OX App Suite 8.35 ([037537b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/037537b394b2e07aa05590c8bcf7c1145df7d7e9))
* **xwiki:** Update to 16.10.5 ([bfd27f3](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/bfd27f3c396d6f05ed3e6dd4cd9f2ff424250da8))

## [1.1.2](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v1.1.1...v1.1.2) (2025-02-19)


### Bug Fixes

* **dovecot:** Add Dovecot Pro [EE] ([6e343c7](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6e343c76a32a5bf4b431bdad6be1f7d107caa4f5))
* **element:** Add Element EE components ([61d94a8](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/61d94a8de655d1289aaf59c42f0dbf30b0156e1f))
* **helmfile:** Add missing customizing option for Matrix widgets ([9c79c44](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/9c79c44453af7b0c68f4ee2a5e40f1f9fb298570))
* **helmfile:** Add SSL option for Keycloak Extensions Proxy's PostgreSQL connection ([91d0f98](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/91d0f9868226b08128af518be741c8614342581e))
* **helmfile:** Fine-grained service types ([de8b560](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/de8b560fe7e2294229a959398be60bec9b6a7790))
* **helmfile:** Integrate oD EE ([03ec704](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/03ec70435c365eca9f555a195b7ab92cc9eee907))
* **helmfile:** Introduce `apps` as top level in `opendesk_main.yaml.gotmpl`; Please check migrations.md for upgrades of existing installations ([2fcf014](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/2fcf014894ac3356ef8c6e57dda30c5176172e5e))
* **helmfile:** Make openDesk IAM attributes optional with enabled as default ([b32996d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b32996da347c7ec24fb53afe72fee8c07631bebe))
* **helmfile:** Provide toggle in `functional.yaml.gotmpl` for "new device notification" mails ([284c9fe](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/284c9fe0c7e217e3f92ec70eaad6ccf593ff2a87))
* **helmfile:** Remove reference to no longer required `elementWeb` chart ([cd9c54b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/cd9c54b17733f9e334c558ccd86e69677264970a))
* **helmfile:** Set default for domain to `opendesk.internal` to avoid enforcing DOMAIN environment variable for deployments using YAML overrides ([930ae9d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/930ae9d3e71bcd3f4034aa4dae5eabb3ae04d11b))
* **helmfile:** Update/streamline theming ([8eeaa23](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/8eeaa23c2f68e8e0cbda5b3763ab15ba8262c48d))
* **jitsi:** Support for phone dial-in into Jitsi conferences ([1323ef1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1323ef142e789820acb05cb4991d10502a35498b))
* **nextcloud:** Update `groupfolders` app to fix group selection in admin mode ([ab49bf9](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/ab49bf9f6bb945cdce3950e46382b7361c48e6e4))
* **nextcloud:** Update Nextcloud to 29.0.11 and support for Cron-Job specific resource definitions ([09f4829](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/09f482981b96774b3fe0948b7bb120be90157148))
* **nubus:** Disable unused notification feature ([955f17e](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/955f17ef8bb72459beb536cdcf6b502b16eabbff))
* **nubus:** Fix Keycloak dialogue background length on small screens ([4662709](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/466270967310fab9333b892c904efa86d21f7d17))
* **nubus:** Only configure apps that are deployed to show up in IAM admin UI and Keycloak ([1f051e7](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1f051e777905668297c98dfa507875c08158bfda))
* **nubus:** Re-implement toggle for UDM-REST-API based on `functional.externalServices.nubus.udmRestApi.enabled` ([777e7d2](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/777e7d2fc6afa9c53a4ff1c6853c9960b9a22d5f))
* **nubus:** Remove doublet `resources` key in `udm-listener` StatefulSet ([10e0b0a](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/10e0b0ad6cbd89bd88b119f17b6cba6ec698f698))
* **nubus:** Support for custom UDM commands ([aff8edb](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/aff8edbde2150763d6a36f97b9403c8c67e51fab))
* **nubus:** Update Keycloak Extensions Proxy ([601e649](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/601e6499132c3adaaaea374033511eab09132cb2))
* **open-xchange:** Parameters to split read and write queries to MariaDB ([370247b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/370247b95197792a65b84b2d01b9c1806f8b059a))
* **open-xchange:** Update OX App Suite to 8.33 ([581c8ae](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/581c8aed1f86bad251141ecb105e59d0054d5a1a))
* **openproject:** Update OpenProject to 15.2.1 ([83c311b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/83c311b101a6fa551d9c25ea4e9a7ef6673137ca))
* **oxconnector:** Update to strict `securityContext` from upstream defaults ([32df165](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/32df1657d29a2d73495d52b62bb77521cb8b8e86))

## [1.1.1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v1.1.0...v1.1.1) (2025-01-27)


### Bug Fixes

* **docs:** Add permissions.md ([04ab28c](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/04ab28c029bb60575c1936ca5acdd2f829b26c06))
* **element:** MatrixID for Element "Welcome User" to support deployments where matrix domain differs from homeserver FQDN ([ccb51a0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/ccb51a0de32525a93fd982d52dc8e6a35db8f09a))
* **element:** Update Element to 1.11.90 ([335806a](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/335806a53e51c3fc6a03440316e909aa51af5be8))
* **element:** Update Helm chart to v6.0.2 for a fix when using non generated secrets in `opendesk-synapse` ([d5e73fe](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d5e73feb880c33e8127f284fcc685ffdc15874a8))
* **element:** Update Synapse to 1.121.1 ([33ff922](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/33ff9227b745f99e3abdde6dbbe6b00042fca655))
* **helmfile:** Move the access restriction configuration for Keycloak client scopes into helmfile templating, instead of hardcoded Helm chart values ([3662b5c](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/3662b5cd255b37321d3a3625f78feff07b7e633c))
* **helmfile:** Remove duplicate entries from `secrets.yaml.gotmpl` ([a13cf63](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a13cf630242343dc8f759cfeb423ff626480b086))
* **helmfile:** Support component specific storageClassNames. **Note:** Please check the migration.md if you upgrade a deployment that has set custom PVC sizes using `persistence.size` settings. ([bacf51e](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/bacf51efb1b042b80f13f5cf3f50557006f32374))
* **helmfile:** Support PostgreSQL as alternative database backend for Nextcloud and XWiki. **Note:** PostgreSQL is likely to become the preferred option/default in the future and MariaDB might be deprecated at a later point. ([a0f52ee](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a0f52ee7d4f6a9b82c9d4e288bc4c6cc96018985))
* **helmfile:** Update `opendesk-alerts` and `opendesk-dashboards` to get predictable sort order, improving GitOps deployments ([0c91117](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/0c91117575a3b56ff9f0b4ae72a501b9f3b4384c))
* **helmfile:** Update upstream images for k8s/kubectl to v1.32.0 ([b71c2e5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b71c2e57eec10093d96804e249fbaf81c51fb22e))
* **intercom:** Remove legacy OIDC claims ([6796f32](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6796f320f72db02d67b73685aa6356cda9ac86d1))
* **nextcloud:** Update image and Helm chart to support app toggles during deployment ([1cdfcf2](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1cdfcf2784271f2b8ea61d2e8e534db2aa386f4b))
* **nextcloud:** Update to Nextcloud 29.0.10 ([d096fb1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d096fb1154dbcd092e105d4450e7996dfda0388e))
* **nubus:** Fix `pullPolicy` setting for `ldapServer.leaderElector` to satisfy Kyverno linter ([6f2f7cd](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6f2f7cd5db6708c1fc523e3cf3160f39f1dba2bb))
* **nubus:** Merge yaml files for better maintainability ([6c67eca](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6c67eca7aa68c3f597cc5790ba1046ca0855c329))
* **nubus:** Pre-create groups in Keycloak to avoid race condition on group sync when initial users login parallel ([5496317](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/5496317fee1ca47a80d0798b9048a1474ca8e2a6))
* **nubus:** Remove `extra` settings from ldapServer needed for openDesk 1.0.0 LDAP migration ([fab862e](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/fab862eec689bf8ef547c4bd06244313f24f6d0b))
* **nubus:** Remove b64 encoded files from CSS, instead use `opendesk-static-files` ([2926e2c](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/2926e2c93a2b4be24abd1e6dd4ce02071a629cb4))
* **nubus:** Template `secrets.nubus.masterpassword`. **Note:** Please check migrations.md for details. ([5aae75a](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/5aae75a1521f73e497859fe3d3b89a8752bb47a1))
* **nubus:** Update customizations for group cleanup ([0b230fa](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/0b230fa2cc841edfde99f5d94dc9c8054bfbb5ec))
* **open-xchange:** Add missing `registryOpencodeDe` to OX-Connector's `waitForDependency` image ([a16d907](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a16d9071c96ef7fde87e6579c328e1e05509824b))
* **openproject:** Update to 15.1.1 ([b4b714f](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b4b714ff41a8f01d4b44c6d5ced3f036f7d90699))
* **openproject:** Update to 15.2.0 ([9d8e9c3](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/9d8e9c3ade9917fb8044331ebdea8d7bca4066b0))
* **static-files:** Update Helm chart to use more generic `assets` over `theme.imagery.assets` ([63562c1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/63562c1aae6b2c33ea39b93c11e842c2ab1e2c25))
* **static-files:** Update Helm chart to v4.0.1 to support longer domain names ([b0e665b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b0e665b031baf36c59eea85b3d575f1a49290bf1))
* **xwiki:** Update Helm chart to v1.4.1 to fix support for custom `ingressClassName` values. Ref [#144](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/issues/144) ([033cb55](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/033cb558ddc0b47d17b006cdc75c593c5c356147))

# [1.1.0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v1.0.0...v1.1.0) (2024-12-24)


### Bug Fixes

* **cassandra:** Prepare cassandra for openDesk Enterprise. ([508e286](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/508e28623258542a4082e79ed75ce1e5758ae2e0))
* **cassandra:** Remove values in charts.yaml for enterprise components. ([c0cbb76](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c0cbb76921b5108d084640baf3e607e9fc6557c7))
* **ci:** Explicitly set RELEASE_BRANCH (to `main`) for scan and release steps ([e5ad0bb](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e5ad0bb2e028dafab0ba29fb2e9b0d207b8795fd))
* **ci:** Reduce Kyverno linting issues ([e4d9106](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e4d9106c457e018922dcc730df0570d41f3ec2aa))
* **collabora:** Add/update Helmfile for Collabora Controller to be used in EE deployments ([a63d7cb](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a63d7cb8614bfa7d26d997ffdf3ea807ae187664))
* **collabora:** Update to 24.04.9.2. ([407f2be](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/407f2be2ad2d40813bb37e0ba302ef14e3a06bd9))
* **docs:** Add `architecture.md` and `apis.md` ([7710858](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/77108587c71dee16ecf539608838c8c9064a66f8))
* **docs:** Add GitOps / Argo CD documentation ([bbe7550](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/bbe7550c4617b4799190192b5316ac04295e9e88))
* **docs:** Update and streamline README.md and migrations.md. ([a86c0af](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a86c0afdbb7fa1230aa90cf210323969fd580431))
* **element:** Add extensive database options ([9e102e2](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/9e102e2d1b9d6621b9c5d6ed0643432e8879f663))
* **element:** Prepare element for openDesk Enterprise. ([00a1a93](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/00a1a9394ee3544b1a0d7b3e975c36830ba8b13c))
* **element:** Rename release opendesk-element to opendesk-element-web ([1213ecc](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1213ecc425041ac4adba99a0ae2d8188932a7d9f))
* **element:** Switch `element-web` base image to Alpine ([47ce294](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/47ce29440388370f7d63e373eeda90d067830ebd))
* **element:** Toggle IPv4-only mode depending on cluster.networking.ipFamilies ([627b9c1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/627b9c1e8464fd9529ddf50f171031053710323c))
* **element:** Update Matrix Meetings Bot to 2.8.2 ([4403dfe](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/4403dfe720982a8339043951a4dfc88bfb0af57c))
* **element:** Update Synapse to 1.120.2 and Element to 1.11.87 update also related containers ([9d7644d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/9d7644dc04c9ef97449680e5197f2129d62d56f8))
* **helmfile:** Add `opendesk-static-files` to `opendesk-services` to serve favicons ([6438284](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6438284090f3e552843679c1ea62b5538be5dff9))
* **helmfile:** Add Redis username and tls option ([564fb2d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/564fb2d7c7190a91446293ce21950701503ecbb7))
* **helmfile:** Allow usage of pre-defined CA certificates. ([0738fa0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/0738fa080d61f0e6c084dd8fd5e09635469b1dca))
* **helmfile:** Auto-redirect user to login dialogue, please read migrations.md for more details ([a9c8dfe](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a9c8dfeab125510a7d9a137e16b14685155aa441))
* **helmfile:** Remove `default.user` and `default.admin` for new deployments. ([54f9e4c](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/54f9e4c3f8fd425bde1272e3eec490efa30461f7))
* **helmfile:** Remove `theme` subtree from the migration's `.Values` secret to avoid a bloated secret hitting limits in certain clusters setups and GitOps tools. ([b6725dd](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b6725dddc19f22e142a214c02aef5139b2921d5a))
* **helmfile:** Splitting the directory `./helmfile/apps/services` into `-external` and `opendesk-` services, please read migrations.md for more details ([277a1f5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/277a1f5a65e340180feeb84cce2097be5a2157e1))
* **helmfile:** Streamline `commonLabels.deployStage`. ([f969425](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/f96942536f931e8f8eb714ce0503716b873b593b))
* **helmfile:** Streamline `requests.cpu` in `resources.yaml` ([43f427e](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/43f427e06a83aea8979e1b54f7ea7f2d24ab28cf))
* **helmfile:** Streamline file extensions in `/helmfile/environments/default` to ([0e3b661](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/0e3b6615653d7bbe30b09e57428b1f5c19f171f8))
* **helmfile:** Unify templating name for Open-Xchange to `openxchange` and for OX App Suite to `oxAppSuite`. ([6ff1fcd](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6ff1fcd438103534e78a5898f25fcea1080dfb86))
* **helmfile:** Use dictionaries for defining `customization.yaml`, please read migrations.md for more details ([86ef0be](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/86ef0be542b0e34d76a85cb226e223a3e7dbc76e))
* **jitsi:** Update Jitsi Helm chart and images. ([5c691e4](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/5c691e450821c81b363040b68ffba96e38d1712b))
* **jitsi:** Update to 2.0.9823 and chart to 2.1.1 ([56ce335](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/56ce3355fcedf60595f33609848f6c8bd8644914))
* **jitsi:** Update to switch the colors of `Hang up` and `End meeting for all` buttons. ([9dbb2b7](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/9dbb2b755caa8e6bda80bed691c54e66b1a63eb9))
* **migrations:** Cleanup of jobs ([539a302](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/539a30263c9ce25ab7c6aa6607fd41cd1099315b))
* **migrations:** Update to support Nubus 1.5.1 ([7f60ab3](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7f60ab3b7a155c8f95bfcf139fa896cbc41ca767))
* **nextcloud:** Add Redis TLS option ([1402593](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1402593556af9cf039878a1261b656424fc45c88))
* **nextcloud:** Fix templating for nextcloud database name ([7f1f6cd](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7f1f6cdcd4385d24cf13cdf9425b615337a131de))
* **nextcloud:** Fix templating for nextcloud database user ([c8c12a2](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c8c12a278e8d00f04c1c7b6dd7fbdf3826c89a19))
* **nextcloud:** Support IPv4 only clusters ([b25ada1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b25ada1f603659cd551be23d62992e8fa6a0603d))
* **nextcloud:** Trusted Proxy setting. ([bc0ca8b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/bc0ca8b4c1dfdcd046c9b4ddd1f63a28e6a5531a))
* **nextcloud:** Update Chart to 3.6.1 and Image to 2.3.3 (including rollback to 29.0.8). Introducing setting for `functional.filestore.sharing.external.sendPasswordMail` ([18fcaa0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/18fcaa0331c9c94bb2f260f97fbadad44b019bb6))
* **nextcloud:** Update to 29.0.9 incl. latest apps. ([c63cca7](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c63cca72a35cdeb35b8ea48d98a5c5d55982d145))
* **notes:** Add `favicon.ico` via `opendesk-static-files` ([669995b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/669995bb95235a56f7b2387c4c582d6e7250e4a9))
* **notes:** Add https to all endpoints ([174951c](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/174951cd5145e83d776a9b4bda4f091d5b827402))
* **nubus:** Add nginx s3 proxy when minio disabled ([b3b6ab5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b3b6ab5a61dc5bca13c8b1f4e6b716bbcad64e8c))
* **nubus:** Enable Keycloak debug mode logging; add Keycloak specific section to debugging.md ([3b3679b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/3b3679bab150ece327ce1e132933820b1e3afa88))
* **nubus:** Fix selfsigned certificate mounts ([b90bff3](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b90bff30b35b91fff792f2d5d617de4cdba30f23))
* **nubus:** Leader election on re-deployments ([b965677](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b9656772a9c743c9119a850e0b48cb39d68f48fa))
* **nubus:** Start ums keycloak bootstrap already during Sync phase ([16dfd25](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/16dfd255c621b1da311fd6fee775f7397e5f6792))
* **nubus:** Update external portal links and login screen background. ([901b1f5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/901b1f529e7d16a8164511bebac1e7f9a475d111))
* **nubus:** Update to 1.4.0 ([2a94f2d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/2a94f2dd4bdfa039b4459b3711e171ee46172583))
* **nubus:** Update to v1.5.1 ([4c7422a](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/4c7422a411a4fa1ddc36430d363ae06226efb31d))
* **nubus:** Use favicon with transparent background for portal ([1b13c3e](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1b13c3ea658786420d960c8e67aed81f40067c0a))
* **open-xchange:** Extend Dovecot LDAP filter to also match OX-Resources ([31ea6e0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/31ea6e0e08226afb8d9cba4370033fd6f742459b))
* **open-xchange:** Fix truststore decrypt error on self-signed deployments ([8611d95](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/8611d95e5a4ab7b158ed8322676589c3d196b548))
* **open-xchange:** Update AppSuite to 8.30, update Helm chart to 2.12.85 ([0c88699](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/0c886999174f87030af268c7fdd0beee11f01346))
* **opendesk-services:** Update minio to 2024.12.13 ([4cda827](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/4cda827f5554ed7ff92a85fc62f6908183181f9b))
* **opendesk-services:** Update otterize Network Policies ([4602396](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/4602396583c454a23b3458c54cb40e259f245163))
* **openproject:** Bump Helm chart to 9.2 ([718eb45](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/718eb45e9c9961f1f792b59e232fd7da66916c7d))
* **openproject:** Bump version to 15.0.2 ([c06e0bb](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c06e0bb8d4d04c8794dafddecc189d5f376d661e))
* **openproject:** Update 15.1.0 image ([6d329e1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6d329e18cff8c6ebbbf1b0965801827079904f88))
* **openproject:** Update branding and Helm chart to 9.0.1 ([d3b1916](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d3b191644b0bf20cac1cd9f85ed4b4dc7c6b549d))
* **openproject:** Update to 14.6.3 incl. latest Helm chart (8.3.2). ([4c82adf](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/4c82adf668c7f90489bc4ae46426cf607e3425d8))
* **postfix:** Added service type definition analogous to dovecot ([31ec100](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/31ec1003c0874a2920132c61d48a1a88e5569cb8))
* **services:** Add template for certificate issuerRef.kind ([df144fe](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/df144fe3d3ffd70ca0b7e5aa4c2894b96d0138f1))
* **services:** Update MariaDB chart to v3.0.3 in preparation for the use of external secrets. ([08feab1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/08feab1cfcc099d9b8caed2c4db9a97d4542a5ac))
* **services:** Update Redis to 7.4.1 as required by OX Appsuite, please read migrations.md for more details ([5e0b2e2](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/5e0b2e26fc33d7befcb3f94d748e8e9d6f93f383))
* **xwiki:** Fix templating for xwiki database port ([de15071](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/de15071ae9d6194d93f9a5fbb0033650b266eaf9))
* **xwiki:** Set superadmin password account only when debug is enabled ([e2b3bd5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e2b3bd543fab7be512cef58382c4d62c48cd79b4))


### Features

* **helmfile:** Add grafana dashboards ([1441c57](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1441c5734f42b995505e6aa97f59bdb1eae32b1b))
* **helmfile:** Add openDesk specific alerts ([f630a36](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/f630a369da12ef7f19d5553c6dbd5955e414868f))
* **helmfile:** Add template support for antivirus icap/milter ([83da87e](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/83da87e9623be294753302686a8d8270c28bcc58))
* **helmfile:** Allow custom/self-signed ca-certificates ([c71faf5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c71faf5e8011c42b02fd5025a9b1629300a4f1e3))
* **jitsi:** Enable Jitsi room history by default. ([45add79](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/45add7981c3a50045caeadb7f2b0bc11254ae562))
* Newsfeed in Portal based on XWiki blog feature ([3ad285a](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/3ad285a8695a32607c4bf0faea0747c7e685dcd6))
* **notes:** Integrate Preview of Notes app ([96f1819](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/96f18196c53267dbd72cd28e6fbadf06448db93a))

# [1.0.0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v0.9.0...v1.0.0) (2024-10-14)


### Bug Fixes

* **ci:** Add TESTS_GRACE_PERIOD variable for run-tests job. ([1023f3d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1023f3d081a980a794850399f133cf817448c431))
* **ci:** Re-enable e2e test trigger. ([603b102](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/603b102f41b8a7e3bfab1c7d45cd05da96c455f6))
* **ci:** Remove K8s secret creation for `EXTERNAL_REGISTRY_USERNAME` / `EXTERNAL_REGISTRY_PASSWORD`. ([cbe6b1a](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/cbe6b1ae6c01beb68ae3bcc0d2444f4b48c8e2ea))
* **ci:** Trigger e2e tests for multiple languages. ([9d7d89f](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/9d7d89f74f49c384e9632b74cbe20a641725caa7))
* **collabora:** Add ipFamilies cluster.networking option ([add2ab1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/add2ab1a41e422295ccd58c09aa9fab9b45f18cb))
* **collabora:** Reduce Collabora's securityContext capabilities. ([a7ea701](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a7ea701cc65ab230d269e4f6b91b39a03c126fad))
* **collabora:** Set Nextcloud URL for custom font support. ([370c7cd](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/370c7cd836b46fb31c79b59d76297abd8748a711))
* **collabora:** Update to 24.04.6.1.1. ([97f7a1c](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/97f7a1cafd743c5e91f9cce6d028c54281afda81))
* **collabora:** Update to 24.04.6.2.1. ([3d44193](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/3d441933ca1c28911218ebc073e7b1d39e402325))
* **collabora:** Update to 24.04.7.1.2. ([11ebb80](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/11ebb80494d181b8ef4793e3e59f3e6ac225b072))
* **collabora:** Update to 24.04.7.2. ([5f72da4](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/5f72da4e579aeb749c045bb7f25355b3e12b411a))
* **docs:** Update `replicas.yaml` and  `docs/scaling.md`. ([45715a2](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/45715a20594dafe833041d5843c857bc0e23dcbc))
* **docs:** Various updates. ([8aa1a7f](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/8aa1a7fa7d106d2e70b1e31b6bda5febb3afec66))
* **element:** Feature toggle for user controlled updates of their Element display name; new default for generating MatrixID, check docs/migrations.md for details. ([efc41cb](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/efc41cb3aa0294d79f6cad3d9e879380745fef57))
* **element:** Set Synapse rate limit. ([4ff720d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/4ff720d36fa30f5f3a7328edd3bfc7edf89cf48f))
* **element:** Update 'capabilities_approved' for NeoBoard Widget ([ade8535](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/ade8535c4456ef9db8c8ef7915bcc4c5ae215f6a))
* **element:** Update NeoBoard to 1.20.0 and `synapse-guest-module` to 2.0.0. ([11b0d44](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/11b0d441e0c886b5360690d23bf266a4ccb57a10))
* **element:** Update NeoDateFix translations. ([71f21dc](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/71f21dc4333765f4bdaf7cfd8910b9b6982b0340))
* **element:** Update Synapse to v0.1150. ([12680e5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/12680e5c1ae40a7722db0417751b014229bdd559))
* **element:** Use Element upstream without widgets. ([bdc6ad2](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/bdc6ad286425e429c8195014251046ac0cfe6424))
* **helmfile:** Add `cluster.networking.proxies`. Deployments need to set this if their load balancer or reverse proxy IPs are not part of the `cluster.networking.cidr`. ([a395759](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a3957595516e6864c762fbeedb9fdc50c02920cb))
* **helmfile:** Add `sample.yaml.gotmpl` to `dev` and `prod` env directories. ([dd80abe](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/dd80abe622fd824b8af358a8923d6fb47715825d))
* **helmfile:** Add new settings to `functional.yaml` for fileshare expiry dates. ([6b88f73](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6b88f731eb2b6c8ceebc9a7a0c96e63d13743b24))
* **helmfile:** Check imagePullSecrets templates for all resources ([13e0bb8](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/13e0bb8d68df12b8451b7318059d35f7eaa018b8))
* **helmfile:** Move Intercom-Service to Nubus component. ([ef1dad7](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/ef1dad7433bbf64b9d021bd581d9016ffc68e610))
* **helmfile:** Move OX-Connector to Open-Xchange component. ([751f578](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/751f5783d05ec4577e563d135c04d2925a14da47))
* **helmfile:** Remove NET_RAW capabilities ([e512486](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e512486e74545449a0e3dca5254ffb44f2d1790f))
* **helmfile:** Remove some YAML linter warnings. ([d641359](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d641359c29c81c774880196febaf4e979b98e5d6))
* **helmfile:** Remove toggle `functional.email.systemGenerated.useComponentInSenderdomain`. Mails will no longer use a component subdomain in their sender address. ([b60fe39](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b60fe39b5c7f6479180495eb76a52b77385fb92d))
* **helmfile:** Switch fom dep5 to REUSE.toml. ([592f031](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/592f03135f226a18038dff534c5b8f8dfc327670))
* **helmfile:** Update portal and branding. ([6ba6923](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6ba69236129e2176afd14d05060f6db1671df863))
* **helmfile:** Update replicas.yaml. ([8ef69ec](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/8ef69ecaf22a8cee51ea4029173d30ff5f1213a0))
* **helmfile:** Update to support Helmfile 1.0.0-rc5. ([f4b9395](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/f4b9395b4134b28eb969e71bc2321eae3054da00))
* **intercom-service:** Customizable user mapper. ([a7e5f64](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a7e5f64b50f102855bd15568ff698160f2b616e3))
* **jitsi:** Improve handling of non authorized users. ([8bca56d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/8bca56d4acb1e8baf1d9bd6e640080b15aac35df))
* **jitsi:** Update chart for improved openDesk look & feel. ([f297d8c](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/f297d8c0b70bd923670a6107471dafe750d8a352))
* **jitsi:** Update Helm chart and Keycloak Adapter image. ([3ad81e6](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/3ad81e6b92ac652fbf20f56f2cc85e6d8eb5d0d4))
* **jitsi:** Update images to `9646-stable`. ([49ad36e](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/49ad36ef4e04640493373e0ba9f4d596968e5412))
* **jitsi:** Updated branding and new option `functional.dataProtection.jitsiRoomHistory.enabled` defaulting to `[secure]`. ([67d52c7](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/67d52c771ef596e444d021886cf5554e12fc1a65))
* **nextcloud:** Add support for secret keys for administrator and ldap credentials ([7aee88e](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7aee88ec94be75f096c31bbb08246c563736b5bc))
* **nextcloud:** Bump image to incorporate latest PHP fixes. ([c9ae039](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c9ae0391b07e18f22c91f4eb6ac746f43210a3f3))
* **nextcloud:** Remove `/index.php`. ([3baf37c](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/3baf37c5097e763069ad66163362e19a90bd5d4e))
* **nextcloud:** Update to 29.0.5 and support for new functional settings regarding sharing of files. See the options related to `functional.filestore.sharing` in `functional.yaml` and also `migrations.md` regarding their defaults that differ from the previous standard behaviour of openDesk. ([ac148d0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/ac148d0c28cf8382c8b96dbedddeccdd0fcd762b))
* **nextcloud:** Update to 29.0.6 including latest app updates. ([9950b73](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/9950b73ae3789fbae31e98a6ad9845822797cb78))
* **nubus:** Add interim ingress configuration fixing UMC in German ([6a60c6d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6a60c6dd43a31e6e972d7149977638d077cbe77b))
* **nubus:** Only use one LDAP Primary and make replica count of Secondary and Proxy others configurable ([31753ff](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/31753ffb19dcd4a82766ed39e7584cbba46b57b0))
* **nubus:** Reduce lint failures, especially take care of pullSecrets ([e923468](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e923468cd6070615c5ba776bb223759988283ecd))
* **nubus:** Remove duplicated "nubusPortalFrontend" ([8cd2f3a](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/8cd2f3a993af673eba3c931a2a9e5a9756943a5d))
* **nubus:** Remove superfluous variables ([a7d3d25](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a7d3d2585ca73543902d5240f3629bc4e1bc4fe8))
* **nubus:** Update "openDesk Standard" OX profile. ([fdb37c3](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/fdb37c3943b08a49badf15da93f4d07abf8f7706))
* **nubus:** Update customization for improved UX. ([b9db81f](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b9db81f69d19985571486aaa4cc11077e0a2abc2))
* **nubus:** Update LDAP openDesk schemas and add related openDesk config options to user. ([e3238f9](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e3238f96f74bfea0b52125d0b5c384aacb75287c))
* **nubus:** Update LDAP to openLDAP 2.5. ([c63e725](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c63e7255254db140d622b658603b99dee5af9879))
* **nubus:** Update opendesk-nubus to set default OXContext and improved OXProfile, update migrations to (optionally) ldap-patch OXContext for `Administrator`/`default.admin` as well as patch the OXProfile to 1.0 default state. ([e619db6](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e619db6da20710a9c1f3df6d8777a370be90c697))
* **nubus:** Update to 0.63.2 ([28dd762](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/28dd762db397f47f0741087fd376be9e3e194dbe))
* **nubus:** Update to 0.64.2. ([fc7099a](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/fc7099a8a6d71f10be1e9ac92279cfdb5f0ebb7d))
* **nubus:** Update to Nubus 0.62.2. ([8229949](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/8229949b47b15933fd4bcc198ec8b27302e2ea32))
* **nubus:** Update to version 0.57.3. ([11f750e](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/11f750e1d603c44fdcbc9711fbe66cbf15ff0c10))
* **open-xchange:** DisplayName settings for OX-Connector. ([b7faa24](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b7faa24d76d6078336d222b195fb83f0860e7e35))
* **open-xchange:** Update cluster internal Nextcloud URL. ([b1946d0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b1946d0c1df6a8825bb5ba6ce61bb8d51d8eefa5))
* **open-xchange:** Update Migrations for OX-Connector. ([6325b69](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6325b69a9145d90328237c359315d057bb187fc5))
* **open-xchange:** Update OpenXchange Appsuite Bootstrap to v2.1.0 ([fb8f7cd](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/fb8f7cd28a82025be5bdc1f9eb92cb2497e22e16))
* **open-xchange:** Update OX AppSuite to 8.26 and improve configuration including server-side Element integration. ([61d7496](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/61d74966d0427ed9214858af2126f250117a8962))
* **openproject:** Bump OpenProject to 14.5.1. ([deacbc9](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/deacbc9db5f30a492e77eb1516182a40427b0c02))
* **openproject:** Remove `OPENPROJECT_PER__PAGE__OPTIONS` to enable functional administration of the setting. ([df9380b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/df9380b92445b992dc3917c63f1d3ce02f9c6633))
* **openproject:** Update Helm chart to v8.0.0 and explicitly template resources. ([91e34aa](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/91e34aabaae8e72b0edb6afe466d4de028dc6a38))
* **openproject:** Update to 14.6.0. ([560aa30](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/560aa30cba2e528094231cb41474a2554f535438))
* **openproject:** Update to 14.6.1. ([cc4b359](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/cc4b35912428b6f4f5541500020f7a4aaff1674e))
* **openproject:** Updated bootstrap image does not fail on rerun. ([7d0d6ea](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7d0d6ea8d15a226d34a0605daf6d635f6c1caae9))
* **services:** Bump Postfix Helm chart to 2.2.0. ([f194f24](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/f194f248459ac0bd39246c72f937672ed24e5f14))
* **services:** Support application based connection limits and password updates for PostgreSQL and MariaDB. ([c03566d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c03566dd63afd0c66de4627880b33ae359cba54f))
* **xwiki:** Disable check for local Office component. ([a91f181](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a91f181c463a5feaa3ac04b4b39fcd27a55fe4a1))
* **xwiki:** Enable IAM controlled functional admin role. ([fa8572f](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/fa8572f785e59b0797c0e5fee12776d0fdc66361))
* **xwiki:** Update to 16.4.4 - updated. ([6347966](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6347966765c3a1caeec0840d2132c8c41a5d1237))
* **xwiki:** Update to 16.4.4. ([d693ff9](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d693ff94f4f79ee26df661f738c843bd4d887716))


### Features

* **element:** Add feature flag `functional.dataProtection.matrixPresence.enabled` that defaults to `[secure]` to avoid that openDesk provides presence information on users unintended. We include the hardcoded configuration in openDesk Synapse that users cannot change their displayname. ([4b99357](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/4b99357b21176f57b75b745a9e3fa04d3cba9d9a))
* **helmfile:** Add customization.yaml to define custom files for helmfile releases ([180ccdd](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/180ccddfaa71e6dcf5f0383bbf1175e6568fc7ee))
* **helmfile:** Add fine-granular registry overwrites ([7348547](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7348547d9602edb2f52c73d26749c4a4d8aadd91))
* **helmfile:** Add support for argocd git-ops deployment ([9f081d8](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/9f081d856724c06928dbb3d6119fd7a090bb4048))
* **helmfile:** Change default subdomain names. Attention, consult docs/migrations.md for upgrade deployments. ([3d84e80](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/3d84e804c2e93d758e42a477888faf681aa56e7e))
* **helmfile:** Full ArgoCD support ([7bf8e69](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7bf8e6976a14a1bb3d1a06135c17211d6530a1c3))
* **helmfile:** Support feature toggle `email.systemGenerated.useComponentInSenderdomain`. ([a46a632](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a46a6326164e2462cd95a7421c7785e7d529e9c0))
* **nextcloud:** Use nextcloud image with bundled nginx ([81f5969](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/81f5969653388b6ce4ef4d15f4fe1cbd61a17e10))
* **nubus:** Update IAM components. ([ce03400](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/ce03400043414ce0d13e2a0f90909d65d7b6eb99))
* **nubus:** Update to Nubus 0.39.2 chart ([7345563](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/73455630fdfada47d0f4895d3f2969c7e80b8847))
* **open-xchange:** Support for email migration feature toggle enabling masterpassword authentication in Dovecot and AppSuite. Requires openDesk Enterprise. ([356d8df](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/356d8dfbfd3825f30fc6c0786551d239e1c5e02e))
* **services:** [bmi/opendesk/deployment/opendesk[#66](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/issues/66)] Add dkimpy-milter to sign outgoing emails with DKIM and use local postfix as mail relay in all components. ([fbe4909](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/fbe4909a8e4c78fd541facea4bd052d10100ea71))


### BREAKING CHANGES

* **helmfile:** Upgrading from previous releases requires manual steps, read `./docs/migrations.md` carefully.

# [0.9.0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v0.8.1...v0.9.0) (2024-07-24)


### Bug Fixes

* **collabora:** Update to 24.04.5.1.1. ([8a2d951](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/8a2d951c3b59c3f8ddb508ad8f95798774b7c4b0))
* **collabora:** Update to 24.04.5.1.2. ([74d444e](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/74d444e2d6065082be3ca90373a4d3b1836ea7a8))
* **docs:** Update workflow.md. ([fd3df7d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/fd3df7df6740d8e54b433c039d294843582e8947))
* **docu:** Update documentation on integration uses cases ([#95](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/issues/95)). ([382af1d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/382af1dfb966b5d10da4790212d6422a4a8c5618))
* **helmfile:** Add S3 bucket for migrations. ([972020f](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/972020f946d8238e65b1c1e2942682c797306e1a))
* **helmfile:** Streamline prefixes for customizable defaults. UPGRADES: See `./docs/migrations.md` for more details. ([26a7641](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/26a7641a5ab764196af6bbe26d97907de86f541e))
* **jitsi:** Raise memory limit for jicofo and jvb as required by upstream product. ([fe923bb](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/fe923bb9cd58873957adb018c1410d33bb4d8f3a))
* **keycloak:** Support for custom OIDC Clients and ClientScopes. ([46412d1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/46412d1a9e4547dea8d0da3e322400ea148edf19))
* **nextcloud:** Support templating of default quota and `*_retention_obligation` settings ([#93](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/issues/93)). ([23ef1d5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/23ef1d557bc0fdf6faac59f7a287f1ef1b302404))
* **nextcloud:** Update to 28.0.7 including latest apps for 28. ([671f57a](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/671f57a809eb4bb791698cda39f7711ac4833334))
* **nextcloud:** Update to 28.0.7 including the apps, fix admin panel warnings ([#94](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/issues/94)). Updated `cluster.networking.cidr` potentially requires manual migration, see `docs/migrations.md` for details. ([63f8394](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/63f8394e044670a89a642e933600b68ff740a102))
* **openproject:** Bump to 14.3.0 and update Helm chart to 7.0.0. ([6b609ed](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6b609edc4a60601ca45372b4fc691f0ac7c9ed93))
* **openproject:** Support for adding token to enable OpenProject Premium. ([dfaf4be](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/dfaf4be640209f5908815cceaf29db591212ddaa))
* **xwiki:** Add email address mapping to LDAP sync; Fix hostname `null` value in notification links. ([1067e72](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1067e725b3dabce4ddfeb60b4cbe9e5b4d0db0e5))
* **xwiki:** Remove .rtf and .odt export options as they are currently non functional. ([b806d51](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b806d51311c6d406ea3c93842601ddf5dbd13bb3))
* **xwiki:** Update to 16.4. ([db7f5d6](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/db7f5d60bdae437cebe58ab10f928a4a348e1ee3))
* **xwiki:** Update to 16.4.1. ([e54aaab](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e54aaab072f31713b5172e4bab9ba7e9ca9c5c26))


### Features

* **authentication:** Avoid that users can open a app they do not have the appropriate LDAP group set for. Implementation is based on role based client scopes. Introducing also an openDesk migration approach with a pre and post deployment stage. ([b4570a9](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b4570a9a873efa6c896fe543ab0ba3b94fd086c0))

## [0.8.1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v0.8.0...v0.8.1) (2024-07-01)


### Bug Fixes

* **collabora:** Bump image to 24.04.4.1.1. ([368fe13](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/368fe13ddb080f0c8f42cbd3612a29f818308708))
* **collabora:** Bump image to 24.04.4.2.1. ([01767d3](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/01767d38061259853e4bd8b2eba31d3b04c4e672))
* **docs:** Add Ports section to getting started. ([c07b25c](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c07b25c4b9a702e214373fe08d95827286ebd866))
* **docs:** Correction regarding the currently supported ingress controller. ([8514908](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/85149086ae70cb85a1718715747985a3da2a7b64))
* **docs:** Update regarding the currently supported ingress controller. ([064a5ad](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/064a5ad246ea7217c2fb107787228d7aca9b5028))
* **element:** Provide the internal cluster domain to `synapse-web`. ([a8692d5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a8692d5506dc65895a562423d8ddb7da9078fc3a))
* **helmfile:** Add script to ease local development of platform charts. ([d8f3e05](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d8f3e05e584116f6196d43e0ea9bb8946ab2e5ab))
* **helmfile:** Enable SMTP for XWiki and Element/Synapse; Streamline mail sender addresses within platform based on `<localpart>@<component>.<domain>` and allow configuration of `<localpart>`. ([01c5e6b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/01c5e6b359dd5eb42c98e818da301871bea79264))
* **helmfile:** Include all `.yaml.gotmpl` files for the envs in `environments.yaml`. ([e523434](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e52343440d81c0596177399058b4711cc0d5da67))
* **helmfile:** Streamline `functional.yaml`. *Upgrade notice:* If you set a non default value for `.Values.portal.enableDeploymentInformation` please change it to `.Values.admin.portal.deploymentInformation.enabled` with this version. ([e89b16a](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e89b16a747f95be7661b1fd4f5c90acce638542e))
* **jitsi:** Update PatchJVB bitnami/kubectl image to 1.30.2. ([6ef3641](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6ef3641d82d88d6fed80652b239bc63115abbf2d))
* **nubus:** Enable Keycloak's user account console. ([c03e4a5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c03e4a534090dde46363a7cfab718bb307e22621))
* **nubus:** Remove doublette ingress annotations. ([890b36e](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/890b36ecbb8c9311b5048d8d6d50ee5acf00ea61))
* **open-xchange:** Fixing YAML indentation of updater resources ([0ce346b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/0ce346b162feb0bc6fee7f18caee84917117abe1))
* **openproject:** Bump image to 14.2.0. ([1ad35f1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1ad35f1e12e236607e3830da6d08010eb465b501))
* **openproject:** Switch DBInit container image to Alpine based version to reduce footprint. ([c90f7c1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c90f7c1742d415d5a787ff5832959e2974b77b83))
* **openproject:** Update PostgreSQL image for DB init to 16.3. ([45e5699](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/45e569955d09c584490e6826651f7564567c1f9b))
* **services:** Allow Postfix "relayHost" to be empty. ([7268f60](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7268f607a5839c6e940ce07fa15c1ffec9610d19))

# [0.8.0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v0.7.1...v0.8.0) (2024-06-10)


### Bug Fixes

* **ci:** Allow CI to be triggered by API authorized personal access token. ([b95fd11](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b95fd1152a2122de0fbc2b31cacb8a1b1c5917b7))
* **collabora:** Semi-disable update checker. ([d7a127f](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d7a127fe269ddf0347adce692f138eb1a6359508))
* **collabora:** Update to 24.04.3.1.1. ([5869316](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/58693162e6c2f72ba6254dd0168dea48539b7d43))
* **docs:** Spell check and streamline. ([4d99bf3](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/4d99bf3bf085a6f8d4dbdef442fa969150dfff4d))
* **element:** Bump container images (widgets, community artifacts). ([f856205](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/f856205afce914ea62a9e309b9400714f4c4d040))
* **element:** Bump to v1.11.67. ([a4ff89b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a4ff89b213afef9fd35dd6ab3c54bf0e8e8b20c9))
* **element:** Update Synapse. ([9fa8ace](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/9fa8ace80f9af5d5c96073fe836cf606956c4f43))
* **helmfile:** Remove unused ox-provisioning hostname. ([e31a0a2](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e31a0a258e274274e20aab41c4c757d891bff639))
* **jitsi:** Update jitsi-keycloak-adapter image to Docker tag v20240314. ([6202bc4](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6202bc4719e96c537c67a65a9419aa183edc6d55))
* **nubus:** Change to new Univention upstream registry. ([d7fbc57](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d7fbc572ca5b3ee4eca31bf50f4e00f257a72b83))
* **nubus:** Disable UDM REST API routing by default and always disable UMC local login. ([e1e8a7f](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e1e8a7f121c41c3f23db4541211d255dfb06591a))
* **nubus:** Guardian version bump and refactoring. ([2f88752](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/2f88752ae6a9df7ff3cb9a3c2d158589f7defb33))
* **nubus:** Re-add selfservice-listener image configuration. ([af711b0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/af711b0edb05bb96fe2ad7e51d5862ed97043178))
* **open-xchange:** Set Nubus LDAP attribute to render manager_name in address book. See https://forge.univention.org/bugzilla/show_bug.cgi?id=53741 for reference. ([4f92001](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/4f92001d688416133fcfd3415afb5f4bbceb7356))
* **openproject:** Bump library/postgres image to v16. ([742c293](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/742c293243e5c8165e065b5b53af7bac6647fad1))
* **openproject:** Bump to 14.1.0, set default timezone on deployment to `Europe/Berlin` and raise default memory limit to 2Gi. ([6e49721](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6e4972107e8eac498ace98217488f4e07fabb6b1))
* **openproject:** Update Helm chart to v5.1.4. ([75cd077](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/75cd077351c0a892afcd57c835b77206ea90da66))
* **openproject:** Update to 14.1.1 and bump PostgreSQL 13 image for InitDB. ([bd2d7cf](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/bd2d7cf748f8cb6b1693056c4a5fc4a60b598acd))
* **services:** Update `opendesk-home` to v1.0.2 to fix issue with Element `.well-known` ingress collision. ([b0eb28b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b0eb28bc3f577a46021444832e0cc132f6e4b0e1))
* **univention-management-stack:** Add functional switch to disable deployment information. ([a31c5f5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a31c5f59a68e90ba9e80350ebd5827e7b05d4ef5))


### Features

* **element:** Enable Matrix federation via https. ([ecb566f](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/ecb566f61e9818ff204501730576af360e4e90d0))
* **helmfile:** Add support for Ingress parameter configuration (proxy-body-size, proxy-read-timeout, proxy-send-timeout). ([dc39b94](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/dc39b94e8824683e54e0f2902e8b4bfe1c43442a))
* **helmfile:** Create child helmfile for GitOps approach. ([a899699](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a899699e21b1d8da9886a93a2e74442799e23e96))
* **nubus:** Cleanup Keycloak values. ([f3d8cf0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/f3d8cf08efbba1b1dd5969821c3af7603202e67f))

## [0.7.1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v0.7.0...v0.7.1) (2024-05-21)


### Bug Fixes

* **ci:** Add Renovate dependency update automation. ([650c41c](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/650c41c3f04b6c7c04a1d5eca76aba7f75e14b96))
* **cryptpad:** Update Helm chart v0.0.19 and include CryptPad app in Helmfile deployment. ([931ed95](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/931ed95ce16d5be6bde7ea1c1140406f00fef060))
* **docu:** Add IdP federation documentation. ([7167055](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7167055303bdbe9ad677b16635089c0328a849ff))
* **docu:** Rename SYNAPSE_DOMAIN to MATRIX_DOMAIN. If you use SYNAPSE_DOMAIN in your deployment, ensure you set the MATRIX_DOMAIN accordingly before upgrading. ([96baa6c](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/96baa6cc15bac8d3ce315132699e301093d5d6d8))
* **element:** Provide certificate for alternative Synapse domain. ([88ac239](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/88ac2396e6888e0f28a80ceebaa0f51d2ba436ee))
* **helmfile:** Use Open CoDE as default registry for Univention helm chart ([#71](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/issues/71)). ([4e56ce4](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/4e56ce4073105003dffbcaa91af473c1f707cd13))
* **jitsi:** Bump images to stable-9457-2. ([1d47fa6](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1d47fa681adf29e4b4ca432a9d5390972098d2e0))
* **jitsi:** Raise Jibri memory limits to fullfil Jibri's 2Gi /dev/shm requirement and update Helm chart; To update an existing installation you need to manually delete the `jitsi-prosody` stateful set before the update e.g. `kubectl -n <your_namespace> delete --cascade=orphan statefulsets jitsi-prosody`. Ensure you use the `--cascade=orphan` part, otherwise you have to remove and reinstall the complete deployment. ([6570c13](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6570c13f3a3ad5864de5afe6afb4c60483cd489f))
* **nextcloud:** Bump to 28.0.5 incl. latest app versions. ([04d9372](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/04d9372cfccc80145962faf4c2387949a43c8f2c))
* **nubus:** Bump Keycloak to 24.0.3. ([923533d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/923533d7b7527de728f73813397ed0c2a0427da5))
* **nubus:** Enable 2FA for group "Domain Admins" by default. ([1179669](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/11796699bb551f8b83badd13204654c880b65efe))
* **nubus:** Update keycloak-bootstap and keycloak-extensions. ([1c6666f](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1c6666fe45fb7acd83c26b5f2b808fce3fb9e20b))
* **open-xchange:** Support change of username. ([b2cfa8b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b2cfa8b9965ce50f593295c80c363bad7ef0454e))
* **openproject:** Bump version to 14.0.1, update Helm chart to 4.5.0. ([e085211](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e0852119e8e248431f51a86e3bd5177cef0b1e93))

# [0.7.0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v0.6.0...v0.7.0) (2024-05-06)


### Bug Fixes

* **ci:** Add debug option. Has to be supported by stage specific configuration containing: `debug.enabled: {{ env "DEBUG_ENABLED" | default false }}` ([3dc6484](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/3dc648421b80d4e170a11792604be127a3960c0e))
* **element:** Provide the internal cluster domain to synapse web ([b9ac5ec](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b9ac5ecf2def57bba0070f1c2f4a01449808f106))
* **univention-management-stack:** Add the image configuration for NATS ([e9ec2f3](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e9ec2f3a6e51975ccdbd6d3575b5fc6a909502aa))
* **univention-management-stack:** Fix [#55](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/issues/55), [#35](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/issues/35) by updating chart "ums" to 0.11.2 and image "portal-listener" to 0.20.6; To update an existing installation you need to manually delete the `ums-portal-listener` stateful set before the update: `kubectl -n <your_namespace> delete statefulsets ums-portal-listener` ([2ad0270](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/2ad027082f4cb958d68d7728d8db05f786dba0f0))
* **univention-management-stack:** Migrate UDM-REST-API image to new Univention registry ([9be3b78](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/9be3b78761610db0274572d5a7c526aa34d0615f))
* **univention-management-stack:** Objectstore credentials ([d1bd43f](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d1bd43fa957accdb70f0cda69983e0490ac6cfa0))
* **univention-management-stack:** Update Helm chart to 0.12.0 including required changes to openDesk Helmfile deployment. ([fefd2f6](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/fefd2f6cae3617ba1f00ef0c5fa3a80cde1d6ba1))
* **univention-management-stack:** Use the NATS related image configuration ([cd22570](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/cd225703ebe67bc78faa878080639dd7cc1845a9))


### Features

* **element:** Add support for Matrix federation ([36139b4](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/36139b42f1df9785b8414059bf70dc3e37616e8a))
* **helmfile:** Introduce additional variables for mailDomain and synapseDomain ([e6fe2a7](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e6fe2a7c18581f637d6bd4d0553d558f753dadd2))
* **services:** Add opendesk-home service, which redirects on domain to portal ([c7e2172](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c7e217208c4cb812cc23f9aa5ea42fcb77ea7c3a))

# [0.6.0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v0.5.81...v0.6.0) (2024-04-11)


### Bug Fixes

* **helmfile:** Improve support for external Objectstore, and fix issue with DoveCot storageClassName ([1b748b6](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/1b748b6bf63d75fc5232c90407a3fa885c2dd3c8)), closes [#57](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/issues/57) [#60](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/issues/60) [#56](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/issues/56)
* **nextcloud:** Bump to 28.0.4 ([cb33a92](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/cb33a929ef7c13a9a578e56a631951292d14d0e4))
* **univention-management-stack:** add Guardian provisioning job image ([79c52d0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/79c52d014cec188d010a2827bb63b2635abafb2c))
* **univention-management-stack:** Update UMC to 0.11.8 ([5e3f4fa](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/5e3f4faade2ea02e51f260d1d614296a6a484848))
* **univention-management-stack:** Use umbrella helm chart ([10ecb44](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/10ecb44aa675d2f139aaec6fe8d4246fa1d3dd40))
* **xwiki:** Bump to 15.10.8 and enable OIDC backchannel logout ([c395d35](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c395d35dd77bbec5e6b7d01768533f87af843560))


### Features

* **open-xchange:** Bump to 8.23 and remove Istio prerequisite ([3be3564](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/3be3564ec7168a1a2d72b58f11da84e89e81911d))

## [0.5.81](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v0.5.80...v0.5.81) (2024-03-28)


### Bug Fixes

* **docs:** Various updates ([50e2638](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/50e263866be8b51ef295ebf8025c3117821a2b6c))
* **element:** Update Element Web to v1.11.59 with widget sync fix and NeoBoard v1.14.0 ([0fd4a26](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/0fd4a26c711fb345b79cdff1c775d7ef20335768))
* **helmfile:** Fix OpenAPI validations for Kubernetes v1.28 ([0aa4cfb](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/0aa4cfb46f793369a472a736b28eea834a545439))
* **nextcloud:** Bump to 28.0.3 ([34d2c05](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/34d2c059596466f8f7d6d09c2855c595391a7e0d))
* **nextcloud:** Rename default shared folder to `__Shared_with_me__` ([5f9d015](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/5f9d015f0b98579d652fd4172e74835ed67ccf11))
* **open-xchange:** Bump to 8.22 ([5ebf291](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/5ebf291a4dbe88a09c0afe2befa6140ad33bf30b))
* **openproject:** Bump OpenProject to 13.4.0 ([d565c05](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d565c057ddb7b348f7a829e0f931b1ea448b454b))
* **openproject:** Bump version to 13.4.1 ([7cc3964](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7cc39647d89538630bac9caa158c47b5cb8d2c45))
* **services:** Update Otterize Policies ([42f63e3](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/42f63e399230495c83f934e07beb9fc950ef5e29))
* **univention-management-stack:** Add missing authenticator secret mount to portal-server ([5a39e87](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/5a39e8725b6454591f552f87f12535201e52df7c))
* **univention-management-stack:** Update LDAP server for BSI base security compliance ([8e889db](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/8e889db63eaf05b24cc23838545f63d969232c65))
* **univention-management-stack:** Update ldap-notifier and ldap-server ([a41ddd5](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a41ddd5451a9fbd3c6319827fee3eaffbd931271))
* **univention-management-stack:** Update provisioning charts, images and helm value to add authentication ([8c97bcf](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/8c97bcf994487281ae94e6d66c73f4a11c08a0be))

## [0.5.80](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v0.5.79...v0.5.80) (2024-03-11)


### Bug Fixes

* **ci:** Remove creation of release artefacts, use the `images.yaml` and `charts.yaml` in `./helmfile/environments/default` for information about the artefacts instead. ([ee99eef](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/ee99eefb72d3207866ffd1b3bd21a36bd55ad288))
* **collabora:** Bump image to 23.05.9.4.1 ([9c32058](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/9c32058fcc21a14e9e66a46064ea044402638920))
* **docs:** Add development.md and refactor `images.yaml` and `charts.yaml` ([a2b333b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a2b333b46277a4bb86b75ca04edb64e69efff916))
* **helmfile:** YAML handling of seLinuxOptions and align overall `toYaml` syntax ([011ad2c](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/011ad2cd6bfe552e04a598452e8814d4d1029152))
* **nextcloud:** Update images digests ([bc18724](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/bc18724d70ffff749d5192487944e62233cf4376))
* **openproject:** Bump to 13.3.1 ([7ee9e47](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7ee9e47e8269334294c80093a359b247d86f5d62))

## [0.5.79](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v0.5.78...v0.5.79) (2024-02-29)


### Bug Fixes

* **collabora:** Bump image to 23.05.9.2.1 ([f4b8226](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/f4b8226ea13971a38d61145ea9ac3821bc35f6b3))
* **collabora:** Fix aliasgroups configuration whitelisting the Nextcloud host ([8b065fd](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/8b065fd9d789cdd597a584937fefaae40f42bba2))
* **docs:** Update version numbers of functional components for release in README.md ([31e5cf3](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/31e5cf317ca7cd84a94cf42d57d0964152904471))
* **element:** Provide end-to-end encryption as user controlled option ([3d31127](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/3d31127a6ab0fa1d3af02695b521db5918932279))
* **helmfile:** Enhance objectore environment variables to allow external Object Store ([d444226](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d4442261aa141e21222dc13407023b96570d055f))
* **helmfile:** Set debuglevel to WARN instead of INFO when debug is not enabled. ([2efceef](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/2efceef076beb06a3719859d7f4e2f0d03b99f44))
* **nextcloud:** Bump images to enable password_policy and fix email with groupware ([8807b24](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/8807b24ce09e59aaea39c349e9e12ee2a44a117a))
* **univention-management-stack:** Bump Keycloak Extensions chart and configure the `/univention/meta.json` to be retrieved from `ums-stack-gateway` to avoid the inline 404 during Keycloak login. ([2023d5b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/2023d5bce4642f794831670713b1a2520a0419d6))
* **univention-management-stack:** Provisioning version bump ([410a023](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/410a0237149a5e41434c09795959bc53e57fb4ca))
* **univention-management-stack:** Template more Keycloak Extension values incl. logLevel ([7ec123b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7ec123b9a174c8dade1fe9f6679796979749efab))

## [0.5.78](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v0.5.77...v0.5.78) (2024-02-23)


### Bug Fixes

* **ci:** Move main development repo OpenCoDE ([43718b8](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/43718b8da2966b87fab8e206df449c923f6615e7))
* **ci:** Run release pipeline only on pushes to main ([13dcb00](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/13dcb004419b4efd8ded8c25e7afa41d10156be8))
* **ci:** Update kyverno rules ([d9263c9](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d9263c90110df241adaef8d1a5df8e8d8ceda11b))
* **docs:** Add missing footnote regarding Nubus ([bc6e4f8](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/bc6e4f8e5dcc32cc476de579fd56dbade79b7c31))
* **nextcloud:** Set admin priviledges for users in central IAM ([a3e415d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a3e415d575ba24b99e741994fb29d0f0cfd11d8a))
* **univention-management-stack:** Scaling udm-rest-api ([57d0f61](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/57d0f61b2c3e789b72a0098907817c97fee69268))
* **univention-management-stack:** Set Keycloak CSP header to allow session continuation in admin portal. ([a398e5a](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a398e5aaf131c1f00b09e1776d6daf10f2c343ad))
* **univention-management-stack:** UMS portal-server scalability ([b1b4c28](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b1b4c28618e0eca31b59719e9e1f2db8ecff7f5c))
* **univention-management-stack:** Univention Portal upstream codefixes version bump ([c2f62f7](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c2f62f7c9487b2119b0d3efd98b40c92efb97c5d))
* **univention-management-stack:** Update provisioning to fix high CPU usage when in idle ([d9c23bd](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d9c23bdf0b955c0b5e4c82dd1ee785b75ce18a3b))

## [0.5.77](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v0.5.76...v0.5.77) (2024-02-16)


### Bug Fixes

* **ci:** Complete CI var usage for external registry ([3bcdcd0](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/3bcdcd06b7c4829686f11b8f065ec38829b5a5a6))
* **ci:** Update openDesk CI Lint to v2.3.1 ([250ef2b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/250ef2bc3fe9047b49b236b606ec3e3fa28e13ce))
* **collabora:** Add chart validation ([0159902](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/01599022f14d447dfdadf390ca9e8e29668dfb07))
* **collabora:** Bump to 23.05.9.1.1 ([b525a81](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/b525a814fc25867c068579d5cbd8d1a993144519))
* **cryptpad:** Update chart to v0.0.18 ([6f0b1f3](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6f0b1f37fc06c40bf537dbaed60f314341211e41))
* **docs:** Add functional component table referencing the component versions to README.md ([bc7eeb8](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/bc7eeb8c9d3dd19f625d6f7ba94b15eb4b782d20))
* **docs:** Add generated security-context.md ([d9e07ff](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d9e07ff7bd0e8be090f4fe2c370fa9978c22dfd5))
* **element:** Change name of neodatefix bot job ([dd535da](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/dd535daac0bb0e602eefa45e8dc448fd07fbdd33))
* **element:** Disable e2ee ([ba0824b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/ba0824bac30ae1fc43458bdc8c09a143076e874c))
* **helmfile:** Add additional provisioning components and configuration ([110ff56](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/110ff56f7487e7ac89b1b75c8c63d04e1c2a41c0))
* **helmfile:** Add seLinuxOptions for all applications ([02d04fa](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/02d04faa2a8d8a0b3bfc179cc8efb3fec086bc70))
* **helmfile:** Annotations in image.yaml ([7ebbd03](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7ebbd03bdcb11abf4e459035c459b74adf8cfcda))
* **helmfile:** Bump Collabora Chart to 1.11.1 and Image to 23.05.8.4.1 ([d2b1f0b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/d2b1f0b07b5ebe4b98b2dc29b916857e28ce5706))
* **helmfile:** Fix annotations in images.yaml ([acaec3b](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/acaec3b8ac6e0ecd58167fca874cd56caa15fa98))
* **helmfile:** Fix umsPortalFrontend image annotation ([8f83261](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/8f832619864504eaa04945a9a79d6790d2ab8a48))
* **helmfile:** Improve debugging ([56f5e35](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/56f5e35895c712440c1a7d249be672c86fc34eeb))
* **nextcloud:** Bump openincryptpad to 0.3.3 and disable circles app ([f2b8acf](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/f2b8acfba85d384ed425779fa52133935e553e86))
* **nextcloud:** Set backchannel logout url ([c0fc225](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c0fc225349794034feea1d0c05b29068b9a455af))
* **nextcloud:** Update image, nextcloud apps and chart ([fd2a66f](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/fd2a66f8f2a987aa71872122267f29aee3d5f22a))
* **nextcloud:** Update nextcloud image and chart to support upgrades ([5d95e7a](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/5d95e7ab2a71097d8c6231bff8c3a6aa3b6f163a))
* **nextcloud:** Update to Nextcloud to v28 ([7c9f38f](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/7c9f38f06e1f0d000992ecdfd77921d6fc28015c))
* **open-xchange:** Bump Gotenberg image ([49f126d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/49f126d169759b3e9dd130101e64892822750d7b))
* **open-xchange:** Dovecot image on OpenCoDE without mirror ([1396071](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/139607186549f7a9a129023f1f72aff82cf36460))
* **openproject:** Bump version to 13.3.0 ([c2087ef](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c2087efcf95bf2eef19556ba1a1d26b7807021c4))
* **univention-management-stack:** New device login notifications on first login with 2FA ([ee1a337](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/ee1a337ab5dea7001045860eb6a5bee1dfc84219))
* **univention-management-stack:** Patches not applied to uldap ([2909e1d](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/2909e1d821397797244d7c11c0935a3bbc902bb1))
* **univention-management-stack:** Support for object-storage icons and portal files ([83ac645](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/83ac645faec748e773dd7940ca0ca1102bd6dff3))
* **univention-management-stack:** Update NGINX Helm chart to 15.9.3 ([c16c0ac](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/c16c0ac7955e64254214d7129ae70d5dd8808743))
* **univention-management-stack:** Update otterize to allow umc-server communication with memcached ([6c15dc1](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/6c15dc1d668623ddd95090e321d1bb268e681db5))
* **xwiki:** Add bottom border to top nav bar to be aligned with the other components ([affa92c](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/affa92cde2caa175707f8ae0e8d4adedbdceb608))
* **xwiki:** Bump XWiki chart to 1.3.0 ([cabee0c](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/cabee0c9da3a32e180931b3bd490ba8f83aadb79))

## [0.5.76](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v0.5.75...v0.5.76) (2024-01-24)


### Bug Fixes

* **nextcloud:** Correct indent in monitoring resources ([bea1413](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/bea1413b860aa69cab3bb4a9dfb6d8593594cc25))
* **services:** Monitoring for minio with correct labels and there are no prometheusRule ([af63e5c](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/af63e5c18dbd6d7d1e1ebd79ad91c4f994fe7003))
* **univention-management-stack:** Fix external registry for nats charts ([cbb33b9](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/cbb33b922d397467d01a9227f3eb18d789cdc39c))

## [0.5.75](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/compare/v0.5.74...v0.5.75) (2024-01-24)


### Bug Fixes

* **ci:** Add Kyverno CI Lint ([e778a59](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/e778a59cddecc7c73b827e03af5e47ddd5c3dcee))
* **helmfile:** Cleanup and small conformity fixes ([db0a544](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/db0a5441550ae08450afc04ef274ff8d19e85138))
* **helmfile:** Merge .yaml and .gotmpl files for Services, Provisioning, Cryptpad, Intercom-Service and Element ([a49daa6](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a49daa6fa27dc7c51c3163b1155eec33b78949f5))
* **helmfile:** Split image and helm registry ([89c149a](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/89c149af954a6f0884ae905e55b52e8db9036b05))
* **univention-management-stack:** UMC secure session cookie ([67f7c05](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/67f7c050387157808f010857395715335b42d767))
* **univention-management-stack:** Update guardian to version 2 ([a99f338](https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/commit/a99f3389dc90aa89ce2ba4bcfc266a2dfdf15ab9))

## [0.5.74](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.73...v0.5.74) (2024-01-12)


### Bug Fixes

* **ci:** Add opendesk-ci linter ([b23152b](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/b23152bb20f3460c62719e47ce519d093a42c034))
* **ci:** Scan all images for malware on release ([807b73c](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/807b73c8a4f39de31f6ae02003541cf19597a3b7))
* **ci:** Switch to 'on_success' instead of 'always' ([e1f6370](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/e1f63701f108bcc124ec67079df1a8649cc2e7c2))
* **collabora:** Migrate collabora to yaml.gotmpl file ([09d001b](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/09d001b6db167ff0a5cd95a1cd58dd2f117f338f))
* **cryptpad:** Bump image ([90152bd](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/90152bdc41131c359075556d26873c1ad5292950))
* **cryptpad:** Bump image to 5.6.0 ([1c4db30](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/1c4db30b65249294696d71e435307d2877556b2c))
* **cryptpad:** Verify against GPG key ([fec0d1f](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/fec0d1f26acd729e71d441ae8043830049028cf4))
* **docs:** Update Helm Chart Trust Chain information ([f894370](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/f8943703ede8f3757dc10b789d95239fe8038d5c))
* **element:** Fix rights & roles of neoboard ([7daa93f](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/7daa93f06179a9d6eedbc058503252d7b7aa04b1))
* **element:** Fix rights and roles configuration ([452624c](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/452624ce749b60abb1208a9f298e92af7d0168d0))
* **helmfile:** Add image annotations for mirroring ([41e777c](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/41e777c81dcb50ead8486683fea8cbbc69f07129))
* **helmfile:** Add logLevel to globals ([8db9bf3](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/8db9bf3c993845c94331c7f1891c3abda907d6e6))
* **helmfile:** Add XWiki GPG key ([712605e](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/712605e4f14913f8e5cda61f64514e077d8df5dc))
* **helmfile:** Increase timeouts for deployment of services ([3b557a8](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/3b557a892c80f4c0061c36fc706502c49a7c4607))
* **helmfile:** Merge fix values filename for Jitsi ([7a14531](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/7a145315f9768f5b5606a1b951f7f07f8a8a7673))
* **helmfile:** Remove oci flag from charts.yaml and move user/password ([2ad48b6](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/2ad48b6fd528c002501771dea96784e54d272c03))
* **helmfile:** Sort images and charts ([acf6816](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/acf681665352c84de00246b57b0be9afa48a820d))
* **helmfile:** Switch artefacts to be pulled from Open CoDE or upstream ([6b3d99d](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/6b3d99d1d1a41368650f828eaea69d9159b8e752))
* **intercom-service:** Add scaling option. ([969c42a](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/969c42a590bb47cddf4c5f59940d53d55dba8810))
* **jitsi:** Add available securityContexts here ([8f09740](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/8f097406773ad769e3bece6af6c994df8254228c))
* **nextcloud:** Replace community Nextcloud with openDesk Nextcloud ([813a2e2](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/813a2e29e964f95bff133a6b09608ff9f6fda255))
* **open-xchange:** Enable ICAP and merge yaml and gotmpl files ([306252d](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/306252da6fb70c3728cf781ea62ab76ad1099af6))
* **openproject:** Consolidate env values set by Helm chart ([08754cc](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/08754cc527e2828a44e853277ed55d6b3d041a37))
* **openproject:** Merge yaml and gotmpl value files ([45967c7](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/45967c7a0b18df6ff23ebff62d5a4c67bde7cee2))
* **services:** Add scaling to all services ([0492420](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/0492420d60bf8e866b39dc51a2e3627cc710de75))
* **univention-management-stack:** Add guardian components ([db749d8](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/db749d8b1b5982d7ffd1728a40c343928a94dc9b))
* **univention-management-stack:** Add missing image template for ums stack gateway and imagePullSecrets to keycloak extensions ([0bf059e](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/0bf059e8e1560a63d4b5efbd80a00a896539f86b))
* **univention-management-stack:** Add ums provisioning service ([d039c65](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/d039c65c4b808e2a55a428502a8cfc05d001b43c))
* **univention-management-stack:** Bump Keycloak Bootstrap image ([bb289d5](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/bb289d545e2ee306ecf032d4889c694c7182f243))
* **univention-management-stack:** Bump Keycloak chart and image and provide settings for IT-Grundschutz ([c2e9204](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/c2e9204c56c526b96e084bd7578cb981f3be29c0))
* **univention-management-stack:** Keycloak clients for guardian ([b30b29d](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/b30b29df8aa179dd065db4ade1d2911f6c7ab458))
* **univention-management-stack:** Provide openDesk version info for admins in portal menu ([5f5a65f](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/5f5a65f59d4f67b589f6ac1f5c51ed584ab91ff0))
* **univention-management-stack:** SAML join using internal Keycloak hostname ([acbef3a](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/acbef3ae3e335de0c5dfc2e54e2c31b64643990a))
* **univention-management-stack:** Streamline timeouts for deployment ([506ef4a](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/506ef4a20f8f5de509a678f7df64f24137e985f6))
* **univention-management-stack:** Updated base image ([78993e1](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/78993e122bad05cc2801acf516ebebb4accc1aaf))
* **xwiki:** Bump Helm chart und image, fix favicon ([87b6fcf](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/87b6fcfc37babaca03ffdbb1ba4ae603db4f1c23))
* **xwiki:** Ldap group sync filter ([9aa907a](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/9aa907a90996b7b4fe4addbd4ca9f0eae6f65aec))
* **xwiki:** Update default XWiki configuration ([f13f39a](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/f13f39a0a0fe9748f12270e9c933c985919b8eda))
* **xwiki:** Update Image to include XWiki 15.10.4 ([9ff6056](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/9ff605623c955d34dcccfdfb69c5b6245ab3f4fc))
* **xwiki:** Update to 1.2.6 and add imagePullSecrets ([2d2455f](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/2d2455fdb347ec001e6a48a5a61dc9098a66e6d6))
* **xwiki:** Verify against GPG key ([a0d5fb8](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/a0d5fb895518aa28b6e69cffdcecde1fe2a53ceb))

## [0.5.73](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.72...v0.5.73) (2023-12-21)


### Bug Fixes

* **docs:** Add and reference workflow.md ([0e1e875](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/0e1e87550f2ff10a3ff11e860e559a54251702cb))
* **helmfile:** Make GPG keys to use CC0-1.0 ([006e20f](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/006e20f06bf5969a213c40c9cbd241cb35adef6c))
* **helmfile:** Pull Univention Helm charts from OCI ([8d6503c](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/8d6503cf28e7960f914325a834032cd9c4e01724))
* **helmfile:** Switch Helm charts to Open CoDE ([0952221](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/0952221f9052f0e58e19629ccd47d85b60b53155))
* **open-xchange:** Disable debug container (appsuite-toolkit) ([40fb9dc](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/40fb9dc9faf7cf579707758d2f5d8714509d34d9))
* **univention-management-stack:** Add extended timeouts to Helm deployment ([1f7b3ca](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/1f7b3ca0f93036300d1421bedc962cf725e6459e))

## [0.5.72](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.71...v0.5.72) (2023-12-18)


### Bug Fixes

* **collabora:** Update image to 23.05.6.3.1 ([8c378c6](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/8c378c6f91a88da3b45c209da5360cabfeb911aa))
* **docs:** Update scaling.md ([d342efe](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/d342efe9a9bbc8f018831e2723e664e5365abba3))
* **open-xchange:** Update Helm chart removing yaml templating doublettes ([c21dd46](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/c21dd462895870fd6ba98bbb167ac063e747a501))

## [0.5.71](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.70...v0.5.71) (2023-12-15)


### Bug Fixes

* **docs:** Security.md ([36bbbae](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/36bbbae57918036f44ddb23e47b550b2f46e5f35))
* **univention-management-stack:** Switch to Univention Keycloak ([902076c](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/902076c62909889f8ffcf90328bc06ebb908b9b8))

## [0.5.70](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.69...v0.5.70) (2023-12-14)


### Bug Fixes

* **univention-management-stack:** Remove UCS container monolith and make UMS standard IAM ([450c434](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/450c434ed08120ad0757d672dc269a78362e780d))

## [0.5.69](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.68...v0.5.69) (2023-12-12)


### Bug Fixes

* **univention-management-stack:** Functional replacement for UCS container monolith, still optional. ([ce38714](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/ce38714a81ea3b0e1377e6ea2d640fb65f317396))

## [0.5.68](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.67...v0.5.68) (2023-12-11)


### Bug Fixes

* **jitsi:** Disable IP Blacklist ([6a649cb](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/6a649cb7f0d04736ccabcd27c035ef6d051f6fd5))
* **open-xchange:** Update to latest version ([db4bfa4](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/db4bfa488401f10bad111ce03c20a60473c64837))

## [0.5.67](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.66...v0.5.67) (2023-12-11)


### Bug Fixes

* **services:** Use Charts from openCoDE registry ([cc0daa2](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/cc0daa2a22837c00583038ffd9df7e669004e84e))

## [0.5.66](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.65...v0.5.66) (2023-12-08)


### Bug Fixes

* **element:** Update Element and Widgets ([6a26299](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/6a26299a7507ae749ffcf25288d2cf5b24d220db))

## [0.5.65](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.64...v0.5.65) (2023-12-08)


### Bug Fixes

* **univention-management-stack:** Bump OX Connector ([83192b7](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/83192b78345c62465e2979195d9a1c882ddbf0ea))

## [0.5.64](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.63...v0.5.64) (2023-12-06)


### Bug Fixes

* **openproject:** Switch to release container and set home url link ([e67ab8f](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/e67ab8f4304a525b50a3a723c86d1e610313c594))

## [0.5.63](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.62...v0.5.63) (2023-12-06)


### Bug Fixes

* **nextcloud:** Remove Talk folder ([0ea5856](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/0ea585633b4bf72fe180ca744cc99d9e9f84998f))

## [0.5.62](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.61...v0.5.62) (2023-12-06)


### Bug Fixes

* **nextcloud:** Bump image to 27.1.4 and update Helm chart to configure "Shared_with_me" folder ([d04a603](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/d04a60349dbbff2d64ca2b36b9c44b75526bf859))
* **univention-management-stack:** Update optional UMS preview state ([94ae3da](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/94ae3da78bd79c61fd7a22db5a541d473eea6a2e))

## [0.5.61](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.60...v0.5.61) (2023-12-05)


### Bug Fixes

* **services:** Fix port declaration for Postfix ([bf5dcda](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/bf5dcda3b59e1dc98cbee7e67f50a960d344b8e0))

## [0.5.60](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.59...v0.5.60) (2023-12-05)


### Bug Fixes

* **ci:** Ensure release creation with artifacts ([dc7ce0b](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/dc7ce0bc4b9501b63274f68352e6d9e76b5424e8))

## [0.5.59](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.58...v0.5.59) (2023-12-05)


### Bug Fixes

* **helmfile:** Add configurable objectstore ([3b5493d](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/3b5493d78dc027cd1f3206b26cf347dc6ce6e265))

## [0.5.58](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.57...v0.5.58) (2023-12-01)


### Bug Fixes

* **cryptpad:** Add websocket annotation ([c41643e](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/c41643ee3e5610ef27a63a0355804159030a7452))
* **openproject:** Add seederJob intent ([05cc82d](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/05cc82d7c5c5f93fb5de7df555a22e8e90279621))
* **openproject:** Bump to 2.6.2 ([c8bc8b3](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/c8bc8b3172cfef3396379e3969dc087d67a228ee))
* **services:** Add NetworkPolicy section to docs/security.md ([24812b6](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/24812b667cded720a0ac09b8b3eb89df39b02afb))
* **services:** Add Otterize based security settings ([bec9a2d](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/bec9a2d46b2b563b7001ed8c6625c10111d5f151))
* **univention-management-stack:** Add Otterize annotations for jobs ([2628a0e](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/2628a0e13e5957475ce81b12d4230400c9ffeafe))

## [0.5.57](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.56...v0.5.57) (2023-12-01)


### Bug Fixes

* **helmfile:** Using correct private registry for  postfix helm-chart ([d367739](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/d367739248ed43b3bad6a00b059b2c949dde4cb7))

## [0.5.56](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.55...v0.5.56) (2023-11-30)


### Bug Fixes

* **element:** Raise treshold for login rate limit to avoid too early barrier hitting normal users ([466e741](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/466e7414942837fdb1aecabfb08eae49f9dab272))

## [0.5.55](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.54...v0.5.55) (2023-11-30)


### Bug Fixes

* **cryptpad:** Update Helm chart to enable readiness and liveness probes ([6d3e484](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/6d3e484855540569be53130e133e0821a04b2ca5))

## [0.5.54](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.53...v0.5.54) (2023-11-29)


### Bug Fixes

* **helmfile:** Add and document security context for components ([519db51](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/519db51be2be3ce292a88965ac0ec049b4c8bb8e))

## [0.5.53](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.52...v0.5.53) (2023-11-29)


### Bug Fixes

* **univention-managemen-stack:** Integrate Attribute to Group Mapper into the containerized stack ([7bbab22](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/7bbab229396075c7d10f94f42bef14551faefe26))
* **univention-management-stack:** Add Announcements icon into "umc-gateway" ([7a9ecf7](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/7a9ecf7b8595edf0949d9c200d01b3409f25b9a7))
* **univention-management-stack:** Add Announcements module into "umc-server" ([4c52a5a](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/4c52a5aaa83ffb6f4c49faa039c94cb1855987bb))
* **univention-management-stack:** Add branding related configuration to stack-gateway ([a5f263c](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/a5f263ce489f88b90cf1151de249f36616a51632))
* **univention-management-stack:** Apply styling ([b3d45c4](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/b3d45c45e1b754e14ab0519efcb6b6a359f0ad1e))
* **univention-management-stack:** Configure openDesk branding in frontend chart ([cbe8fb2](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/cbe8fb2d65e6ce73f9da95ef9b0ed3ffbb16d367))
* **univention-management-stack:** Document database of UMS Notifications API ([3cf348c](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/3cf348c7ae8f438daf3e64addbf839230816f3d2))
* **univention-management-stack:** Move static settings from gotmpl into yaml for umc-gateway ([b3ac0ae](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/b3ac0ae6d91a058265fcd26c6653bb8a13d3e780))
* **univention-management-stack:** Quote all composed strings ([1c35ca6](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/1c35ca67ce0673e1b2f9a350bd07c82c22a05354))
* **univention-management-stack:** Remove frontend-custom ([8b6a4b2](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/8b6a4b2e88e8be1d299af91ed1ffff4405db88e6))
* **univention-management-stack:** Set SMTP host for self-service notifications ([0c7a77c](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/0c7a77c4b6f20c6d83e977dabfc4e555b652f6ac))
* **univention-management-stack:** UMC uses external memcached ([211bee9](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/211bee94bb7675860f867f0335fec9f14fc96875))
* **univention-management-stack:** Update ums-dependencies ([e0c6c14](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/e0c6c14dcaefc0755495270bbf45898721e27985))
* **univention-management-stack:** Update ums-dependencies ([c246edd](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/c246edd8f9753e37bc9c32683faf41f5b46d7675))
* **univention-management-stack:** Update ums-dependencies ([86b4818](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/86b48188e160c1f7d15f2c33f1f3cd0cc0e68bf2))
* **univention-management-stack:** Use "stack-gateway" in all deployments ([c19bca2](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/c19bca2be0d14750bbef661e45c5c424f7da8e77))

## [0.5.52](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.51...v0.5.52) (2023-11-28)


### Bug Fixes

* **ci:** Open automatic MRs for new branches ([735fec3](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/735fec3b4ccd33ba63e5fa6482526efb6853c64a))

## [0.5.51](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.50...v0.5.51) (2023-11-28)


### Bug Fixes

* **nextcloud:** Bump chart to fix central navigation ([cac6abe](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/cac6abe2510b6793963633077543684a6a4e7cbc))
* **openproject:** Update container and prepare for OIDC based user admin role setting ([6dc92df](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/6dc92df2ebcae435e3b3609cc163dc6c33fb1b83))

## [0.5.50](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.49...v0.5.50) (2023-11-27)


### Bug Fixes

* **ci:** Add metadata for renovate processing ([36aa3ed](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/36aa3ed7c9f9a6d0ffe23dc3ca2174d5f2741dfa))

## [0.5.49](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.48...v0.5.49) (2023-11-27)


### Bug Fixes

* **nextcloud:** Bump image to incorporate fix for https://github.com/nextcloud/security-advisories/security/advisories/GHSA-f962-hw26-g267 ([efbd814](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/efbd81496868c5d4274f09805a1e771f47d548be))

## [0.5.48](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.47...v0.5.48) (2023-11-24)


### Bug Fixes

* **services:** Update resource requests and remove cpu limits ([f86a74b](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/f86a74ba100c7f08f6538b58a713bbc87c00e814))

## [0.5.47](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/compare/v0.5.46...v0.5.47) (2023-11-24)


### Bug Fixes

* **helmfile:** Rename absolute paths on OpenCoDE to new 'opendesk' base group name ([7ac2e0f](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/7ac2e0f9de2a8386a7f5809ba40db4ed7164a857))
* **xwiki:** Enable the sync of user profile picture from LDAP ([6aa3d38](https://gitlab.opencode.de/bmi/opendesk/deployment/sovereign-workplace/commit/6aa3d386afe8b3f22e47f9971fd719089006b54e))

## [0.5.46](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.45...v0.5.46) (2023-11-23)


### Bug Fixes

* **element:** Fix quotes in element chart ([a447c13](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/a447c137fe58be343e7ada55afb7f6891a5cde74))

## [0.5.45](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.44...v0.5.45) (2023-11-22)


### Bug Fixes

* **open-xchange:** Add security context ([db48140](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/db48140f3ae6576b21e93ac0f10f40765efd608d))

## [0.5.44](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.43...v0.5.44) (2023-11-21)


### Bug Fixes

* **ci:** Remove default BASE_DOMAIN in .gitlab-ci.yml ([7ae65a3](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/7ae65a36a2777d249ba3784bf965da4c790a1b21))

## [0.5.43](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.42...v0.5.43) (2023-11-20)


### Bug Fixes

* **univention-management-stack:** Update optional UMS preview state ([061e588](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/061e588da90e52b531df0688347675bf4dcb431e))

## [0.5.42](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.41...v0.5.42) (2023-11-20)


### Bug Fixes

* **nextcloud:** Add exporter and serviceMonitor ([feed270](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/feed270fd7949743e8f9974e7f147e89ab623347))
* **nextcloud:** Bump openDesk bootstrap to 3.2.3 to support serverinfo token ([ea14f95](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/ea14f953a4a54c01cc0d66db1bdb645ca4a661e5))

## [0.5.41](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.40...v0.5.41) (2023-11-16)


### Bug Fixes

* **helmfile:** Split README into docs ([cd0e94f](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/cd0e94f96fa5b377ab382b6c7738ed279cb2a199))

## [0.5.40](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.39...v0.5.40) (2023-11-14)


### Bug Fixes

* **open-xchange:** Bump Dovecot and fix out-of-office replys ([55f6ba2](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/55f6ba21dc9eab811ac501bf0e2b78d4ae772194))

## [0.5.39](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.38...v0.5.39) (2023-11-14)


### Bug Fixes

* **univention-management-stack:** Update optional UMS preview state ([e231e57](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/e231e5749d3804f888ec23e12b58783856043219))

## [0.5.38](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.37...v0.5.38) (2023-11-13)


### Bug Fixes

* **collabora:** Update image to 23.05.5.4.1 ([c460467](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/c460467d7449b107134562b785e95f6280e3473d))

## [0.5.37](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.36...v0.5.37) (2023-11-12)


### Bug Fixes

* **openproject:** Add bootstrapping of Nextcloud filestore ([1971dfb](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/1971dfbded21d16909e889ba6d19ff9cf3e4cb20))

## [0.5.36](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.35...v0.5.36) (2023-11-10)


### Bug Fixes

* **element:** Update Element and Widgets ([97034a5](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/97034a556f4cdcc447f61003ad9cd036c186bc3b))

## [0.5.35](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.34...v0.5.35) (2023-11-10)


### Bug Fixes

* **helmfile:** Eliminate some yamllint errors ([1d03a6e](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/1d03a6e11f368fd81dd10b91b0d9d7fc29c0cb24))
* **helmfile:** Move ldap host variable into helpers ([08811de](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/08811decd92e7fd7802d0eba2644046512ec58a4))
* **helmfile:** Update charts to use proper quoting ([69ea840](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/69ea84051721f3aaf36a5dbafdfb37dd86b66dbb))
* **services:** Add minio as service and consume by OpenProject ([baa5827](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/baa5827de3e1e368abf238a932a5849f169af723))

## [0.5.34](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.33...v0.5.34) (2023-11-09)


### Bug Fixes

* **openproject:** Bump helmchart and properly template OP's initdb image ([0d8e92f](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/0d8e92fc5a4729ff7649e5a10e629b962a9b671b))

## [0.5.33](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.32...v0.5.33) (2023-11-09)


### Bug Fixes

* **cryptpad:** Update security context ([89ae1d9](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/89ae1d94ea4c4e8a15a395a80847a7f235365747))

## [0.5.32](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.31...v0.5.32) (2023-11-09)


### Bug Fixes

* **collabora:** Resource definitions ([65ce9a1](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/65ce9a171b7c8ebc453fb6bbe96743c8516da2c6))

## [0.5.31](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.30...v0.5.31) (2023-11-08)


### Bug Fixes

* **univention-management-stack:** Update optional UMS preview state ([d0a0799](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/d0a07997c12ddb9731a0dfed0d6fa71d9a3790e7))

## [0.5.30](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.29...v0.5.30) (2023-11-06)


### Bug Fixes

* **collabora:** Init monitoring in defaults and in collabora (for prometheus-monitor, -rules and grafana dashboard) ([0ad0434](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/0ad043406bef7bb10d561ef1418b58cbd8714d43))
* **helmfile:** Add monitoring.yaml for optional monitoring ([385d81b](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/385d81b9a9e1ec319706493c51629c8e48822aa7))

## [0.5.29](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.28...v0.5.29) (2023-11-06)


### Bug Fixes

* **xwiki:** Update XWiki Helm configuration to enable LDAP and OIDC user synchronization ([7c56c72](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/7c56c7244f3862b6b21627661430a94d804c6974))

## [0.5.28](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.27...v0.5.28) (2023-11-06)


### Bug Fixes

* **open-xchange:** Add Document- and ImageConverter, improve LDAP address book filters ([899a8c5](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/899a8c5af9052634b98d9876dfbaea517d89ad49))

## [0.5.27](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.26...v0.5.27) (2023-11-04)


### Bug Fixes

* **docs:** Re-include release artefacts ([4359b21](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/4359b21f1cdae91a87b87ad2b270d67a2b1eda21))

## [0.5.26](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.25...v0.5.26) (2023-11-02)


### Bug Fixes

* **element:** Enables user directory search for all users ([8fafd90](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/8fafd906a3b0efa7e4164b357656d7903fc55371))

## [0.5.25](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.24...v0.5.25) (2023-11-01)


### Bug Fixes

* **cryptpad:** Add CryptPad to support editing of diagrams.net files from within Nextcloud ([ab6014f](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/ab6014f8c6285785be5c56cd656fe0636df4434c))

## [0.5.24](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.23...v0.5.24) (2023-11-01)


### Bug Fixes

* **collabora:** Update image to 23.05.5.3.1 ([38336d0](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/38336d024033f4fe1a28b0f76f9c63ecdb076156))

## [0.5.23](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.22...v0.5.23) (2023-11-01)


### Bug Fixes

* **element:** Update Element Web to latest release ([b47de62](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/b47de62f987e8778878fee55ecda3032beb55f3d))

## [0.5.22](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.21...v0.5.22) (2023-10-31)


### Bug Fixes

* **openproject:** Nextcloud integration within K8s instances ([d249d0e](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/d249d0e3ce3ee0966033e870ea5c4d9e1928f045))

## [0.5.21](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.20...v0.5.21) (2023-10-30)


### Bug Fixes

* **helmfile:** Deinstall components if disabled ([7feaadf](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/7feaadf7f8830d8d0d5df752733c9b8f47315df6))
* **helmfile:** Put enviroments in first document inside of a yaml ([034e98c](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/034e98c850fa1f67300c04883904737a69448a25))

## [0.5.20](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.19...v0.5.20) (2023-10-30)


### Bug Fixes

* **helmfile:** Remove old XWiki image, set explicit timeout for OP deployment, bump Jitsi Helm chart to enable chat for stand-alone Jitsi ([5d01f8c](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/5d01f8ca46384d63d69dab0119998c4bb3183084))

## [0.5.19](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.18...v0.5.19) (2023-10-30)


### Bug Fixes

* **element:** Update Element Web and Nordeck Widgets to latest releases ([2313f75](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/2313f75dbe32d855b0c440944bd0de51c8e104ca))

## [0.5.18](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.17...v0.5.18) (2023-10-28)


### Bug Fixes

* **xwiki:** Switch to Alpine/Jetty slim image ([b399869](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/b39986907cece3cec06012531a55b2699d131f90))

## [0.5.17](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.16...v0.5.17) (2023-10-28)


### Bug Fixes

* **nextcloud:** Update swp_integration app and prepare CryptPad integration ([a046dea](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/a046deaf173ab41029c2ab5e3161bd89e0fdabcb))

## [0.5.16](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.15...v0.5.16) (2023-10-26)


### Bug Fixes

* **openproject:** Slim container with upgraded helm-chart ([535823e](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/535823e0a8b2bde72d159835248b2287fd136af7))

## [0.5.15](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.14...v0.5.15) (2023-10-25)


### Bug Fixes

* **helmfile:** Add XWiki Jetty and UniventionKeycloak to image.yaml for Compliance checks. They are not yet part of standard deployment. ([8e376bb](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/8e376bb4a5e37e16d76ea527cd02a5f614cdfe3d))

## [0.5.14](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.13...v0.5.14) (2023-10-20)


### Bug Fixes

* **element:** Support for openDesk top bar with central navigation ([e609b75](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/e609b75cc7fcbb7f03997cb5e26dd9cf4628f77d))

## [0.5.13](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.12...v0.5.13) (2023-10-20)


### Bug Fixes

* **element:** Configure rights and roles ([59d58e3](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/59d58e320e503727e42dbfe0b027ba7948275ac6))

## [0.5.12](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.11...v0.5.12) (2023-10-19)


### Bug Fixes

* **element:** Add an application service for the intercom-service ([1a4eced](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/1a4eced998998faa7ac862b8c409bbd743b16ec0))
* **element:** Add the Matrix NeoBoard Widget deployment ([5afd233](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/5afd2339c20a0be41078ae4c3ce703c62f332557))
* **element:** Add the Matrix NeoChoice Widget deployment ([7756d35](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/7756d35fa156b36ed50ba8f837273db56323f45f))
* **element:** Add the Matrix NeoDateFix Bot deployment ([785989e](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/785989e91df5547ab5ac60914b82bc99c4f1a790))
* **element:** Add the Matrix NeoDateFix Widget deployment ([27b6796](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/27b6796639f37dbd6c26f21fd54502153398aed0))
* **element:** Add the Matrix User Verification Service deployment ([30405d1](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/30405d182d44a5586a4070738dfbe1c141841d19))
* **element:** Upgrade Element to v1.11.46 ([82a037e](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/82a037ec7c25baf41bd0542c3ded47402adc2844))
* **element:** Upgrade the opendesk-element charts to 2.3.0 ([fd9e04d](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/fd9e04d9922b949d0f213016169a9024a66a1ded))
* **element:** Upgrade the opendesk-matrix-widgets charts to 2.3.0 ([cbe5141](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/cbe514176a4d86d166db248d7297d215409016d2))
* **element:** Use a separate image configuration for the bootstrap tasks ([7f7c364](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/7f7c364071072b01d485d3e248a3f8de49a07309))
* **intercom-service:** Allow access from the non-istio domain and reference to the correct synapse hostname ([16f2ac4](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/16f2ac464eb7267f1c4d87c3ccaca2c91a7ecc1b))
* **intercom-service:** Fix the nordeck configuration ([06dcdd7](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/06dcdd78afe0e6514c1f30d24924d3e7077ae6da))
* **jitsi:** Use template for the cluster networking domain ([0898d96](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/0898d9657145d66fd4c52fe6036c955ad58a0cfe))
* **keycloak:** Use the correct backchannel logout configuration for element ([86657b1](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/86657b139a6d8f4ff3f921b8755e04cb790c3786))
* **open-xchange:** Enable Element calendar integration ([f564efd](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/f564efd97f8db39cffaea317e36db3825fc9121e))

## [0.5.11](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.10...v0.5.11) (2023-10-11)


### Bug Fixes

* **helmfile:** Quote all password template strings ([fb7dba7](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/fb7dba787c232c402aa9c989c0e8ace51869d534))
* **services:** Add memcached service ([72e3afd](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/72e3afdffdeb6f88f8e926426dbc26adf4b54e7a))

## [0.5.10](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.9...v0.5.10) (2023-10-11)


### Bug Fixes

* **intercom-service:** Update intercom-service chart to v2.0.0 ([c3129f1](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/c3129f14437728be890187bb7c4a1bfc42d90958))

## [0.5.9](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.8...v0.5.9) (2023-10-10)


### Bug Fixes

* **element:** Enable the guest module in Synapse ([da1bf35](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/da1bf3581c5790786601948cabcef8a1d1c680ad))

## [0.5.8](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.7...v0.5.8) (2023-10-10)


### Bug Fixes

* **helmfile:** Add default port for SMTP in environment ([74f9ec2](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/74f9ec28e401f7caeefc4e50ac0a7e95fea41a53))

## [0.5.7](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.6...v0.5.7) (2023-10-09)


### Bug Fixes

* **openproject:** Mail sender address ([711d29e](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/711d29e374d13a3c8b7bcdf3e8440d03e0ef2b7d))

## [0.5.6](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.5...v0.5.6) (2023-10-09)


### Bug Fixes

* **helmfile:** Use signed bitnami charts from openDesk Mirror Builds ([70744d0](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/70744d04c66f32d65dc968c8570ed7a397f4efcc))
* **services:** Bump redis chart to 18.1.2 ([d4c751d](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/d4c751d29f15c718957f6bc388a99347e2923c87))

## [0.5.5](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.4...v0.5.5) (2023-10-09)


### Bug Fixes

* **openproject:** Switch image to fix central navigation; set email sender address ([e42feb4](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/e42feb4c260fc24692bc2742c97754230f8e2857))

## [0.5.4](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.3...v0.5.4) (2023-10-02)


### Bug Fixes

* **helmfile:** Add third environment (test) ([7dbcbfe](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/7dbcbfe7237b365cf53f4c850b149e8b95149901))

## [0.5.3](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.2...v0.5.3) (2023-09-28)


### Bug Fixes

* **open-xchange:** Rollback MariaDB version to fix OX Guard initialization ([e33acd3](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/e33acd33e79740144e8fe318fe34dc705834ddf3))

## [0.5.2](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.1...v0.5.2) (2023-09-28)


### Bug Fixes

* **ci:** Add Gitlab-CI sledgehammer deployment removal ([6fd655a](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/6fd655a0b1afd40303ac11130692202146bab215))

## [0.5.1](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.5.0...v0.5.1) (2023-09-28)


### Bug Fixes

* **docs:** Add 'Helm Chart Trust Chain' section ([b6b4972](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/b6b4972a5dd426bcc8fa00137d7e7b60056376c8))
* **docs:** Highlight that Helmfile >= 0.157.0 is required ([d86f516](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/d86f516747323d117f620658c4368408926c507a))
* **element:** Use OCI registry and verify chart signatures ([a41b9a6](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/a41b9a699c79bf90163bbb3c233c805b8d0a999e))
* **helmfile:** Add cleanup flag for job resources ([0f01b94](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/0f01b94aa19b40b4774ba11d9886fe6f12090e73))
* **helmfile:** Create directory for gpg pubkeys ([4c5731e](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/4c5731e6bb057cb272f660b4df0369b67709c203))
* **intercom-service:** Use OCI registry and verify chart signatures ([74b3d41](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/74b3d41381474efd2fbc5a9f3a0f1c0713811106))
* **jitsi:** Verify chart signatures ([1dd6582](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/1dd6582ec7d742250ba08f69eba9a4679984b1ae))
* **keycloak-bootstrap:** Use OCI registry and verify chart signatures ([ca5d5f8](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/ca5d5f82800ea6d7ecfa38eb2b5d8b85e709bb9f))
* **keycloak:** Use OCI registry and verify chart signatures ([095059c](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/095059c7e53bbe8a874773f574cc6794ef8af6e4))
* **nextcloud:** Use OCI registry and verify chart signatures ([41dfdc0](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/41dfdc0c8f83e3d79fa5a763ac449f6edfc76676))
* **open-xchange:** Use OCI registry and verify chart signatures ([2d5d370](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/2d5d3708f7f45600961c22ce11e750561de1fd27))
* **open-xchange:** Use renamed istio gateway ([65d2642](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/65d2642d34c1c21a00a29278f7e1143f7fabb2aa))
* **openproject:** Use OCI registry and verify chart signatures ([5343840](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/5343840bed01992b3132eace362f91588c705a98))
* **services:** Add wildcard certifcate request support ([15ad8ca](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/15ad8ca7ab34b079252f7b69219ede81ad43aa1c))
* **services:** Bump opendesk-certificates to 2.1.0 ([4372f06](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/4372f063e0a27d5156da963d44d3ed4e72490fc4))
* **services:** Only create istio gateway with webmail domain ([6a39011](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/6a390112dab11afaca06118a0ca7a18afe633a30))
* **services:** Use OCI registry for all services and add gpg verify mechanism ([892920b](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/892920b0487b41a35b5a96596c61101827e8dd6d))
* **univention-corporate-container:** Use OCI registry and verify chart signatures ([424317e](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/424317ed585f7bd5036259d7e3d77d081d2aec1b))

# [0.5.0](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.4.9...v0.5.0) (2023-09-27)


### Bug Fixes

* **element:** Move the static configuration into the values.yaml ([f22619b](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/f22619bd8ef11cb43147ef19dcff2c02d9fe0503))
* **element:** Specify resources for the guest module init container ([275798c](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/275798c1d6aa47ef33fbb0da3bb03a86d3e4b0ee))


### Features

* **element:** Activate the guest module ([5ad25ac](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/5ad25acafd54d19dd2ed330b19f7860aff5d49f4))

## [0.4.9](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.4.8...v0.4.9) (2023-09-27)


### Bug Fixes

* **nextcloud:** Bump Helm chart to add app "groupfolders" ([62b767e](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/62b767ef38c8eae2874b20a9aa51e85d2a3fe5a3))

## [0.4.8](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.4.7...v0.4.8) (2023-09-26)


### Bug Fixes

* **openproject:** Digest rollback ([9acce08](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/9acce081397c06426820b61f39c9aa0dcc1234a5))

## [0.4.7](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.4.6...v0.4.7) (2023-09-26)


### Bug Fixes

* **helmfile:** Add timeout for database services ([98ec02f](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/98ec02f230f1691eb8c17d8d3552fceda329bf7c))
* **openproject:** Image digest ([b340373](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/b340373133ad973cfd6a3632adc9a74a23419cc7))

## [0.4.6](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.4.5...v0.4.6) (2023-09-26)


### Bug Fixes

* **openproject:** Use renamed registry open_desk ([a37faf3](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/a37faf3b5769aea9944ffa7626096c16296dcc85))

## [0.4.5](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.4.4...v0.4.5) (2023-09-26)


### Bug Fixes

* **helmfile:** Streamline timeouts ([2703615](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/2703615dffb2ba5c70704a4f08bb0485629218f3))

## [0.4.4](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.4.3...v0.4.4) (2023-09-25)


### Bug Fixes

* **open-xchange:** Updates for mail templates and mail export ([ae3d0da](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/ae3d0daa117d3d0ff307f379590394914a757546))

## [0.4.3](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.4.2...v0.4.3) (2023-09-25)


### Bug Fixes

* **nextcloud:** Update image to 27.1.1 ([ce7e5f6](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/ce7e5f670a4dbc980eb8be73e5f7d15b27e8b1de))

## [0.4.2](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.4.1...v0.4.2) (2023-09-21)


### Bug Fixes

* **nextcloud:** Add Nextcloud app for OpenProject integration; Bump Collabora Image ([f46c8a9](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/f46c8a9a5f4f9778cb171d65e9a0280e4ce61c16))

## [0.4.1](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.4.0...v0.4.1) (2023-09-19)


### Bug Fixes

* **univention-management-stack:** Remove doublette triple dashes in helmfile.yaml ([41b9afb](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/41b9afb3648a0e1fddc5aa4337cc1501756b370c))

# [0.4.0](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.3.2...v0.4.0) (2023-09-18)


### Features

* **ci:** Optionally trigger E2E tests of the SouvAP Dev team ([a99c088](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/a99c088361b95b2bb7ee2b161e3a254f02bcd9ae))

## [0.3.2](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.3.1...v0.3.2) (2023-09-14)


### Bug Fixes

* **helmfile:** Fix linter issues ([1514678](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/1514678db00d32c1463d8fc496c0e6d1c2a2df96))
* **univention-management-stack:** Add "commonLabels" into helmfile ([16c08f8](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/16c08f82c9b4934567bb3b9c7fccab754bfad494))
* **univention-management-stack:** Add Helm charts ([a74d662](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/a74d66240423fd5ba87854cc2b71132f11271ec7))
* **univention-management-stack:** Add switch "univentionManagementStack.enabled" ([471a2fa](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/471a2fa26205b8ca3afb5eeeb4524897a57f5c20))
* **univention-management-stack:** Adjust Ingress configuration for portal-server ([13bcd78](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/13bcd785e8f7db22d20903020e0cdd28094309a9))
* **univention-management-stack:** Adjust Ingress configuration for umc ([320da3b](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/320da3bec3a49d974765e567878d5c2f2b4e93ef))
* **univention-management-stack:** Adjust Ingress configuration of notifications-api ([5e1a7b1](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/5e1a7b19e278147d010c48dac2da111f828dd115))
* **univention-management-stack:** Adjust ingress configuration of the portal-frontend ([c54bab1](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/c54bab165bf81854471d790200781b4181eba22a))
* **univention-management-stack:** Adjust Ingress configuration of udm-rest-api ([c61b1b8](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/c61b1b828150caa8d2fe1a5b9f0a862b2fbef4f1))
* **univention-management-stack:** Adjust Ingress conifguration of store-dav ([96097e4](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/96097e470483a5251acd81eb772da70ad7f55137))
* **univention-management-stack:** Configure cookie banner data ([12c931f](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/12c931fcff5536116af11df1c9c0468429949fe2))
* **univention-management-stack:** Define resource requests and limits ([2f8a298](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/2f8a2989250ea0f3b50dd3417f214a8864fe62d0))
* **univention-management-stack:** Disable istio for the stack ([4835a2b](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/4835a2beec408ec6267177f82257edd9ccb0d937))
* **univention-management-stack:** Prepare persistence configuration ([7ab1cb5](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/7ab1cb5c7e7bca85394eae2ed17141e513dd5a42))
* **univention-management-stack:** Process bases before releases ([ec3f1d9](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/ec3f1d96ac17cf1fb9d34ab692240460d5bd4ba1))
* **univention-management-stack:** Set externalDomainName for bootstrapping the stack ([0ba71f2](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/0ba71f2749eaf51b09429a5f3c705bd0075c1efa))
* **univention-management-stack:** Split templated from static values ([09079a1](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/09079a13031be7894a34bf92945bd25a040c2290))
* **univention-management-stack:** Split values into templated and static ([d3c4390](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/d3c439038a2551ec90324ab8659d24b65b223d4f))
* **univention-management-stack:** Update portal-listener to leverage dependency waiting ([c840608](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/c84060811229bb131bcd473a9e4668dfa73f97d7))
* **univention-management-stack:** Use global secrets to fill initialPasswordAdministrator ([a4bab40](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/a4bab4068dc298056ed864e60a244d49a2934c8b))
* **univention-management-stack:** Use global secrets to populate ldap related secrets ([9409ad8](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/9409ad829a725c84ebc3de5d1c4d42fe735e9d0c))
* **univention-management-stack:** Use global secrets to set store-dav related passwords ([90019e3](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/90019e3ef6de5e4ed1742ee9ddc3bbb256cd3dec))
* **univention-management-stack:** Use ldap base DN "dc=swp-ldap,dc=internal" ([77e362f](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/77e362f6bc053c5d456bf65649f15130ce53547c))
* **univention-management-stack:** Use postgresql service for notifications-api ([fe0e0cd](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/fe0e0cdce4622352afbf74875adcae8324d769a3))
* **univention-management-stack:** Use the prefix "ums-" for all releases ([edb25bd](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/edb25bd7655beeefa73a62fb9a8c85e076c4cc2f))
* **univention-management-stack:** Use the value "global.imagePullPolicy" ([15db5dc](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/15db5dcbba33c39f752499f2d73c77cac32d1e8c))

## [0.3.1](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.3.0...v0.3.1) (2023-09-14)


### Bug Fixes

* **collabora:** Update Ingress annotations and set securityContext ([b5583ca](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/b5583caec10c24e3bfb312edcb2800e6a60a9b10))
* **element:** Improve default container security settings ([882f1fb](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/882f1fbc93ceb4ac33683d445e100e445798b202))
* **element:** Update opendesk element version to 2.0.1 ([d725b93](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/d725b937989987ffacf87d7a9ee05803dcdd4c93))
* **helmfile:** Remove default SMTP credentials and create docs for SMTP/TURN ([e120f5f](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/e120f5fb9a91b80ba71ce78eace99852b4da5fda))
* **helmfile:** Update images and use a tag and digest together ([c7fc187](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/c7fc187f14b78cdcc698abbbaec1ba0bbfc718a1))
* **services:** Explicitly set securityContexts ([a799db0](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/a799db03c4115ba69303be1c265f7aefef95d659))
* **services:** Update Postfix to 2.0.2 fixing security gaining ([e1070ee](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/e1070eeb0602523c240a91dae1b0869a7cc42a78))

# [0.3.0](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.2.10...v0.3.0) (2023-09-12)


### Features

* **ci:** Selective tests ([d2e7ac9](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/d2e7ac93481249e9eb7e5e1a41a6c6e333abe2dc))

## [0.2.10](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.2.9...v0.2.10) (2023-09-06)


### Bug Fixes

* **helmfile:** Add imagePullPolicy default env variable ([f988644](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/f9886448b60bbbd917b5ba04d188401275293eec))
* **helmfile:** Update images and add jitsi, keycloak to security section in docs ([0eceb85](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/0eceb85e7df7455fa61cb17a854807069fbcf51a))
* **jitsi:** Update chart to 1.4.2 with improved security and fixed change on each deployment ([1349181](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/1349181d802ccb80d9e48cf50fe39f1505116c8e))
* **jitsi:** Update jitsi to 1.5.1 and fix prosody image ([ed7e5e4](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/ed7e5e428e5d9213a92f97dc03d72fa3e04334c2))
* **keycloak:** Improve default security settings ([3b90533](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/3b90533063c151a9f3cdc9861a115481f6dc440a))
* **nextcloud:** Fix yamllint disable comment ([4380e78](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/4380e789814ec2b0458fb2c341c8160ab2743afc))
* **services:** Disable https redirect in istio to fix cert-manager issues ([1ef4a86](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/1ef4a861acc955e2e85715c62f715a6629ada940))
* **services:** Fix capabilities of postifix ([a6fa846](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/a6fa846afc9744f2b399c37cc754f878b6b9e90b))
* **services:** Fix OCI registry address of postgresql, mariadb ([be82243](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/be822439661f766c4db6044fd3581db0cce214bb))

## [0.2.10](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.2.9...v0.2.10) (2023-09-06)


### Bug Fixes

* **helmfile:** Add imagePullPolicy default env variable ([f988644](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/f9886448b60bbbd917b5ba04d188401275293eec))
* **helmfile:** Update images and add jitsi, keycloak to security section in docs ([0eceb85](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/0eceb85e7df7455fa61cb17a854807069fbcf51a))
* **jitsi:** Update chart to 1.4.2 with improved security and fixed change on each deployment ([1349181](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/1349181d802ccb80d9e48cf50fe39f1505116c8e))
* **keycloak:** Improve default security settings ([3b90533](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/3b90533063c151a9f3cdc9861a115481f6dc440a))
* **nextcloud:** Fix yamllint disable comment ([4380e78](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/4380e789814ec2b0458fb2c341c8160ab2743afc))
* **services:** Disable https redirect in istio to fix cert-manager issues ([1ef4a86](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/1ef4a861acc955e2e85715c62f715a6629ada940))
* **services:** Fix capabilities of postifix ([a6fa846](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/a6fa846afc9744f2b399c37cc754f878b6b9e90b))
* **services:** Fix OCI registry address of postgresql, mariadb ([be82243](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/be822439661f766c4db6044fd3581db0cce214bb))

## [0.2.9](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.2.8...v0.2.9) (2023-09-05)


### Bug Fixes

* **collabora:** Add websocket support for NGINX Inc. Ingress ([6e5ef63](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/6e5ef639c22aad93fd2d0eb75f7a1ffc00d6cc9a))
* **docs:** Add security part in README ([ff462ab](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/ff462ab0dc2252cc7b517874f5337427b8d19053))
* **docs:** Update scaling docs ([63a1e25](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/63a1e2568e8c5ff62081c6e6594d2019c1aa4b74))
* **helmfile:** Reduce icap resources in default enviroment ([c5ab1b8](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/c5ab1b81fecbce46788c50b282ed6d1770124fa5))
* **helmfile:** Update clamav and nextcloud images in default environment ([4f2a8ae](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/4f2a8aeee4ee6c3d27b1c8a99bad14f603486be5))
* **nextcloud:** Add support for up to 4G large upload for Ingress NGINX and NGINX Inc. Ingress ([6e68f7f](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/6e68f7f28c937319d93f8afe1dbb302012f77233))
* **nextcloud:** Rename sovereign-workplace-nextcloud-bootstrap to opendesk-nextcloud-bootstrap and use OCI ([cef11ac](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/cef11acbae28510809f9bfa13224dc3a6996207f))
* **nextcloud:** Use clamav-icap when clamavDistributed is activated ([41d40c9](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/41d40c9b731b866da2666fa4ffa8cb6493737112))
* **services:** Enable security context and use default increased security settings ([9a6d240](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/9a6d2409a697f7e9811a0f4f8d31bb18bac1b926))
* **services:** Fix image registry templates for postfix ([6321ff5](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/6321ff50a00203abbfb7f5822e67a3c0e00d4b01))
* **services:** Replace image digest by tag ([f758293](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/f7582932412f13b1a087d40459e97cf633b1a97e))
* **services:** Set readOnlyRootFilesystem to true on master ([5fbf86b](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/5fbf86b6bc7b63c81b3ac07c5e0fa8cd464fdad1))
* **services:** Update clamav to 4.0.0, redis to 18.0.0, postgresql to 2.0.2, mariadb to 2.0.2 and use OCI registries ([9d78664](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/9d7866480cee889fd3b3003b2eea313a6ed73344))

## [0.2.8](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.2.7...v0.2.8) (2023-08-31)


### Bug Fixes

* **open-xchange:** Update images and Helm chart ([39565c7](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/39565c7cfd89a8d1c2e645e3ecea28fba703ccc1))

## [0.2.7](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.2.6...v0.2.7) (2023-08-30)


### Bug Fixes

* **jitsi:** Update Jitsi Helm chart to set the user's display name as default ([387bd87](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/387bd8715c5a1cf54733c6642cf57c6ef9a44316))

## [0.2.6](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.2.5...v0.2.6) (2023-08-30)


### Bug Fixes

* **ci:** Change path of asset_generator ([6ab4fa0](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/6ab4fa078b0bb3939c54f46d6475770fa9901936))
* **ci:** Include deployment environments ([0f59736](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/0f59736c5dcff905400ae2e1bbf7ae496ffb9b2c))
* **ci:** Release artefacts ([2a61b5f](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/2a61b5f2a66bf1dc1ad06f7111ef7ecaf9247b39))

## [0.2.6](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.2.5...v0.2.6) (2023-08-30)


### Bug Fixes

* **ci:** Change path of asset_generator ([6ab4fa0](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/6ab4fa078b0bb3939c54f46d6475770fa9901936))
* **ci:** Include deployment environments ([0f59736](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/0f59736c5dcff905400ae2e1bbf7ae496ffb9b2c))
* **ci:** Release artefacts ([2a61b5f](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/2a61b5f2a66bf1dc1ad06f7111ef7ecaf9247b39))

## [0.2.6](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/compare/v0.2.5...v0.2.6) (2023-08-30)


### Bug Fixes

* **ci:** Change path of asset_generator ([6ab4fa0](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/6ab4fa078b0bb3939c54f46d6475770fa9901936))
* **ci:** Release artefacts ([2a61b5f](https://gitlab.opencode.de/bmi/souveraener_arbeitsplatz/deployment/sovereign-workplace/commit/2a61b5f2a66bf1dc1ad06f7111ef7ecaf9247b39))

## [0.2.5](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/compare/v0.2.4...v0.2.5) (2023-08-30)


### Bug Fixes

* **xwiki:** Theming and language of central navigation ([3d4d45f](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/3d4d45f7114e6e3bc353b8d6c5fdbcac4cb2460f))

## [0.2.4](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/compare/v0.2.3...v0.2.4) (2023-08-29)


### Bug Fixes

* **element:** Apply the global theme to Element ([7f7eae8](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/7f7eae8f99a6d8ad8085ad99c63af27b858ff9b7))

## [0.2.3](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/compare/v0.2.2...v0.2.3) (2023-08-29)


### Bug Fixes

* **ci:** Add central branding information ([a14c42f](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/a14c42f6ed2e3d8e12af5d04cae1a4bb1336fb3d))

## [0.2.2](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/compare/v0.2.1...v0.2.2) (2023-08-16)


### Bug Fixes

* **jitsi:** Allow configuration of LoadBalancer status field for patchJVB job ([7491582](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/7491582c28c21e83a0bc6349fb68045472146aad))
* **open-xchange:** Explicitly disable core-ui-middleware ingress ([06dc7a1](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/06dc7a115d36841f1109f9e75aac844d934c2f4c))

## [0.2.1](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/compare/v0.2.0...v0.2.1) (2023-08-16)


### Bug Fixes

* **keycloak:** Increase proxy-buffer-size for ingress-nginx ([d8adcc4](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/d8adcc463adc8bec5a793a97977dddd89d7363cc))

# [0.2.0](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/compare/v0.1.2...v0.2.0) (2023-08-15)


### Bug Fixes

* **helmfile:** Replace bitnami repositories with OCI ([4c21fd2](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/4c21fd228654520bb71d56dc1bda96332334002b))


### Features

* **helmfile:** Implement private image/chart registry variables ([5788323](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/57883236219811d2a5fc422649b4f9b042a0ac22))

## [0.1.2](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/compare/v0.1.1...v0.1.2) (2023-08-15)


### Bug Fixes

* **jitsi:** Update support for NodePort setups with different ingress/egress ips ([de25789](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/de257893d4ff2b3e8ea1d6988c6bdde5ed1eae9a))

## [0.1.1](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/compare/v0.1.0...v0.1.1) (2023-08-14)


### Bug Fixes

* **open-xchange:** Bump dovecot and sovereign-workplace-open-xchange-bootstrap to 1.3.0 with image digest support ([53796da](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/53796dae660463207a460b387b6f3dd23ce20cd0))
* **open-xchange:** Bump sovereign-workplace-open-xchange-bootstrap to 1.3.1 ([390f2de](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/390f2dee5226b83855a6cca8bf1c0d0f5647ee34))

# [0.1.0](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/compare/v0.0.6...v0.1.0) (2023-08-14)


### Bug Fixes

* **docs:** Typo ([ee684a7](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/ee684a78910ce721ea834e9ec2f4222ed37572c6))


### Features

* **element:** Add element component ([5f0ca92](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/5f0ca92a058e51a27aa56e35ebcf2048bad88671))

## [0.0.6](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/compare/v0.0.5...v0.0.6) (2023-08-14)


### Bug Fixes

* **open-xchange:** Functional mailboxes auth settings update in AppSuite and Dovecot ([53948ea](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/53948eae7648cc9785d2b8a813fc7e40b36aa3aa))

## [0.0.5](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/compare/v0.0.4...v0.0.5) (2023-08-11)


### Bug Fixes

* **keycloak:** Improve digest image pinning ([b8a8932](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/b8a8932221ae4d6632c7d1f4a85f46fea01a92e7))

## [0.0.4](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/compare/v0.0.3...v0.0.4) (2023-08-11)


### Bug Fixes

* **jitsi:** Fix identifiers in resources ([3a0b246](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/3a0b246f83dc6a3ff19973959b3cf3c243c39025))

## [0.0.3](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/compare/v0.0.2...v0.0.3) (2023-08-10)


### Bug Fixes

* **keycloak:** Keycloak extensions sha256 image pinning, includes fix for failing keycloak extension handler on unavailable SMTP relay. ([27ce715](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/27ce71554d5f495731d90632a56e134762b95a25))

## [0.0.2](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/compare/v0.0.1...v0.0.2) (2023-08-10)


### Bug Fixes

* **services:** Remove fqdn from dovecot in postfix ([2033c76](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/2033c76d81e39c625112b312934668d3b3eb43fe))

## 0.0.1 (2023-08-10)


### Bug Fixes

* **ci:** Add 'qa' cluster ([43e94f8](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/43e94f8018e8fa9a98c57c9dc53709c25c643af3))
* **ci:** Deploy provisioning in separate/later stage ([ef1cb75](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/ef1cb75d45c323bc7ef43fed1a8c42aa17cdf088))
* **collabora:** Bump to 23.05.2.2.1 and add capabilites to non containerd k8s clusters ([2652b26](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/2652b2645d93106b9d6a3e50e35c9e2bd07bee12))
* **collabora:** Image version bump from 23.05.1.2.1 to 23.05.1.2.2 ([3bf7dae](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/3bf7daeeaa9a7aafe16e649dd1df0c2a537acb4a))
* **collabora:** Remove MKNOD capabilities ([2f18734](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/2f1873454c97b3e28670aca0996cdca1940515bb))
* **docs:** Cleanup and enhance README.md and CONTRIBUTING.md ([cc5f88c](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/cc5f88cbafd9147c21f4bca67f7df01c2a4c28f2))
* **helmfile:** Allow selection of environments when installing from root helmfile ([8ce01df](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/8ce01df681a5a3347e5b8e2277fc3acaf043b21e))
* **helmfile:** Comment out Open-Xchange Appsuite 8 Deployment until is publicly available ([cb65baa](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/cb65baa8afc305c8faf3484704f578e1c62f8033))
* **jitsi:** Fix wrong parameter for jitsiPatchJVB tag ([fb3fca2](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/fb3fca2e7ee8dbb22a0622f86953fcfdb9934864))
* **nextcloud:** Add Istio domain on integration for read/write contacts with Open-Xchange ([b235685](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/b2356855d5b481359a2b29e43517bbc1f9025b5c))
* **provisioning:** OX-Connector inits contexts and accessprofiles first, profile pictures are now provisioned ([94552a3](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/94552a361456b6688070cb01f80fa8a91ef086fb))
* **provisioning:** Update OX-Connector image ([3cc7ba9](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/3cc7ba911502d69e780a274e93dd9ef693fe6049))
* **services:** Bump postgresql chart to 2.0.0 ([e609bf3](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/e609bf36fc1bdb4f9b8c2b9318baf0477a20ebf9))
* **services:** Specify dovecot with fqdn ([59d64de](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/59d64de44e545904198b77528687382ddd511fc8))
* **services:** Update mariadb Chart to 2.0.0 ([f39811c](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/f39811ce44c0a6cbebb48d91c3d5f6724f8cf3e6))
* **univention-corporate-server:** Update image to improve pod restarting behaviour ([57dea1e](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/57dea1e1ddc7af7298a2b90a7b999f0a80cd0858))
* **xwiki:** Remove init job as XWiki now does the required bootstrapping internally; Restartability works now as expected ([8425c10](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/8425c10b1893c812060298d15471371bfa2c1151))
* **xwiki:** Use external-registry for image download ([841bfb6](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/841bfb62fe067d2ec73c198c46bd9a97538e20f5))


### Features

* **ci:** Add release-automation and linting ([82bf038](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/82bf0387e0057f2ef64d392341fe8c34490310e4))
* **ci:** Support for MASTER_PASSWORD to be set on Gitlab Settings > CI/CD > Variables ([e7d68ea](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/e7d68ea78e5e9f393f92d12acbf67ebe5176ccad))
* **ci:** Triggered tests ([23fc3c4](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/23fc3c4a1b77fbfa0202a283e74d14d6f8dbaec7))
* **docs:** Update various chapters and structure ([42232db](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/42232db5dbc0056e3169115546afd288e4a1d796))
* **helmfile:** Add capabilities for a RWO deployment ([d5190cd](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/d5190cd40ceb8b16252c7bd57ca7e43359634320))
* **helmfile:** Remove environment specific values to use cluster defaults ([4fb86b5](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/4fb86b5addd92f04b3315c0c722b69e6f7e7182b))
* **helmfile:** Remove environments and replace with generic one ([ef7d75f](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/ef7d75ff1f9ac7f2ce02fced3db1549639fbd0fd))
* **nextcloud:** Rename to sovereign-workplace-nextcloud-bootstrap and bump to 2.2.0 ([84de627](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/84de627e209dfd38390ec5a2ff126c75b5e71cc6))
* **open-xchange:** Add service type for dovecot ([c9a763f](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/c9a763f368f6b23a7760f90b2b4ab79245bf27ea))
* **open-xchange:** OX AppSuite 8 within SWP is now publicly available ([6dc470f](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/6dc470fd67edbb9711e406acb067569ca357b989))
* **services:** Add clamav-simple deployment ([505f25c](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/505f25c5493ebb9e0181233ed5b7d8018e3a315d))
* **sovereign-workplace:** Initial commit ([533c504](https://gitlab.souvap-univention.de/souvap/devops/sovereign-workplace/commit/533c5040faebd91f4012b604d0f4779ea1510424))

<!--
SPDX-FileCopyrightText: 2023 Bundesministerium des Innern und für Heimat, PG ZenDiS "Projektgruppe für Aufbau ZenDiS"
SPDX-License-Identifier: Apache-2.0
-->
