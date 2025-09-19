<!--
SPDX-FileCopyrightText: 2025 Zentrum für Digitale Souveränität der Öffentlichen Verwaltung (ZenDiS) GmbH
SPDX-FileCopyrightText: 2023 Bundesministerium des Innern und für Heimat, PG ZenDiS "Projektgruppe für Aufbau ZenDiS"
SPDX-License-Identifier: Apache-2.0
-->

<h1>Scaling</h1>

This document covers the possibilities to scale the applications in openDesk.

It provides rough benchmarks for configuring your own environment across various scale levels.
In production, resource demands are primarily driven by actual usage patterns and system load, especially the number of concurrently active users.
Consequently, we strongly recommend implementing monitoring and logging solutions to detect usage trends and enable timely intervention when needed.

| Application  | Recommendation | Note(s) |
| ------------ | -------------- | ------- |
| Collabora    | - 1 vCPU per 15 active users <br/> - 50 MB RAM per active user <br/> - 1 MBit/s per 10 active users | - |
| Element      | Per 10k users with values for federation activated / federation deactivated:<br/><br/> Homeserver:<br/> - 15 / 10 vCPU<br/> - 12 / 8 GB RAM<br/><br/>Postgres:<br/> - 10 / 4 vCPU<br/> - 32 / 16 GB RAM | Required hardware resources are impacted by whether or not federation is being used |
| Cryptpad     | No large-scale deployments seen, minimum requirements: <br/> - 2 vCPU <br/> - 2 GB RAM <br/> - 20 GB storage (depending on planned usage) | Most of the computation is done client-side |
| Jitsi        | Jitsi-Meet server: <br/> - 4 vCPU <br/> - 8 GB RAM <br/> <br/> For every 200 concurrent users one JVB with: <br/> - 8 vCPU <br/> - 8 GB RAM <br/><br/> Network bandwidth: <br/> - 1 GBit/s - 10 GBit/s small deployments <br/> - 10 Gbit/s *per bridge* large deployments<br/> | JVB network bandwidth calculation depends on the stream resolution (HD vs. 4k). |
| Nextcloud    | Up to 5k / more than 5k users: <br/> - 4 to 20 Nextcloud AIO Pods with 8 vCPUs and 32 / 64 GB RAM each <br/> - 2 / 4 DB servers with 8 / 16 vCPUs and 64 / 128 GB RAM each, plus DB load balancer | - |
| OpenProject  | - 4-6 vCPU per ~500 users <br/> - 6-8 GB per ~500 users <br/> - +20-50 GB storage per ~500 users, depending on workload and attachment storage[^1] <br/><br/> - Web Workers: +4 per ~500 users <br/> - Background Workers: +1-2 multithreaded workers per ~500 users, depending on workload | These values are guidelines and should be adjusted based on actual monitoring of resource usage. Scaling should prioritize CPU and RAM, prioritize scaling Web Workers first, followed by Background Workers and Disk Space as needed. |
| Open-Xchange | For ~200 users (64 concurrent users to App Suite & 128 users to Dovecot): <br/> - 10 vCPU <br/> - 58 GB RAM <br/> - 660 GB storage | - |
| XWiki        | Advise for small instances: <br> - 4 vCPU <br/> - 6 GB RAM | - |

[^1]: Nextcloud is configured for attachment storage as well.

# Upstream information

While scaling services horizontally is the ideal solution, information about vertical scaling is helpful
when defining the application's resources, see [`resources.yaml.gotmpl`](../helmfile/environments/default/resources.yaml.gotmpl) for references.

Linked below is documentation related to scaling for upstream applications, where publically available:

- [Collabora Online Technical Documentation](https://mautic.collaboraoffice.com/asset/60:collabora-online-technical-information-pdf)
- [OpenProject System Requirements](https://www.openproject.org/docs/installation-and-operations/system-requirements/)
- [XWiki Performance](https://www.xwiki.org/xwiki/bin/view/Documentation/AdminGuide/Performances/)
- [Element Requirements and Recommendations](https://ems-docs.element.io/books/element-server-suite-documentation-lts-2404/page/requirements-and-recommendations)
- [Jitsi DevOps Guide (scalable setup)](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-scalable/), [Jitsi Meet Needs](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-requirements/)
