# Sonarqube Upgrade Guide from 10.3.0 to 25.8

Sonarqube project has moved into different editions like _community_, _developer_, _enterprise_, and _datacenter_.
The earlier release cycle was following semver with 10.8.0 being the last in the series.
Up to version 10.8 SonarQube Server followed the `MAJOR.MINOR.PATCH` version scheme.
The [newer release model](https://docs.sonarsource.com/sonarqube-server/latest/server-upgrade-and-maintenance/upgrade/release-cycle-model/)
follows the `YYYY.ReleaseNumber.PatchReleaseNumber` (f.ex. 2025.1.2).

The Sonarqube community editions do not have LTA releases now, and only the commercial versions will have the LTA releases.
For us to upgrade from _10.3.0_ to _25.8_, we need to upgrade to last major release of 10.X, which is 10.8.0.
Once Sonarqube is migrated, we will then upgrade the 10.8.0 edition to 25.1.
Keep in mind that the `sonarqube:10.8.0-community` docker image has been retagged as `sonarqube:24.12.0.100206-community`.
See https://community.sonarsource.com/t/sonarqube-10-8-0-is-missing-from-docker-hub/132178/4 for details.

Then, we will upgrade from 25.1 to 25.8.

### The upgrade path is 10.3.0 -> 10.8.0 -> 25.1 -> 25.8

This has also caused some upheaval in the underlying helm charts, so keep in mind to run _helm template_ locally, to check
if the helm chart and values file are able to generate a correct manifest.

## Other Factors to Consider

Apart from reading the Release Notes and going through the Changelogs of each version, you should be familiar with these things
before starting on the upgrade.

### Database Migrations

It is recommended to use an external or a standalone database instead of using the bitnami postgresql chart from the sonarqube helm chart.
We recommend using CNPG operator or Zalando operator to have managed postgres clusters running on top of Kubernetes.
Before starting the upgrades, ensure you have the database backed up using a pgdump or a similar command. The logical backup cronjob,
if you are using zalando, should be manually triggered to take a db backup before starting the upgrade.

Sonarqube pod logs will have a message like

```
The Database needs to be manually upgraded
```

When you see this, you can go to the url where Sonarqube is deployed, and that will redirect you to `https://sonarqube.yourdomain.com/maintenance`.
You will need to go to `https://sonarqube.yourdomain.com/setup` to **Manually** approve the DB upgrade. Without this
critical step, Sonarqube will be stuck in maintenace mode.
Although, we did not observe any issues with Postgresql 14, be sure to check your db version is compatible with the Sonarqube version
you intend to upgrade to.
Sonarqube [recommeds](https://docs.sonarsource.com/sonarqube-community-build/server-upgrade-and-maintenance/upgrade/post-upgrade-steps/#clean-up-postgresql) 
to vaccum and reindex postgres dbs after upgrade.

### Plugins

There can be plugin incompatibility while moving from 10.3.0 to 25.8. We found this with the sonarqube-auth-oidc plugin
and had to specify the latest version(v3.0.0) to avoid the sonarqube pod going into CrashloopBackoff.
Refer to this compatibilty matrix for the common plugins
https://docs.sonarsource.com/sonarqube-server/latest/server-installation/plugins/plugin-version-matrix/.

Custom plugins will have the details on what versions are supported in their respective repos.

### Steps

#### Testing the latest helm chart and sonarqube version

- Run _helm template_ locally with the values file to catch any errors beforehand.
- Spin up a fresh sonarqube instance with the target version (25.8) and the current postgres version (pgsql 14) alongside the desired sonarqube plugins.
- Once the new sonarqube instance is healthy, create a user, add a repo to check if everything works as it should.
If there is OIDC or SAML login, check if some test users can login via external providers like Google, Azure, Okta, etc.
- Completely delete the test sonarqube instance and cleanup any pending resources like PVCs or secrets.

#### Testing the upgrade path for a replica of sonarqube as close as possible to original

1) Find the current sonarqube version and the helm chart version that you are running already.
2) Take a logical backup of the current postgres db and restore it in a new pgsql instance.
3) Spin up a test sonarqube instance with the same version and the pgsql instance you restored.
This will be an exact replica of the original sonarqube that you will perform the upgrade on eventually.
4) Upgrade the helm chart to _10.8.0_ version of sonarqube. Approve the db migrations by navigating to sonarqube url `/setup`.
5) Check if the sonarqube says it is operational, elasticsearch cluster is green or not and you are able to log into the UI.
6) Once you are sure that all existing data (users, repos, plugins, rbac, etc) have been correctly migrated, then we can jump to the next version.
7) Upgrade the helm chart to _25.1_ version of sonarqube. Repeat the same steps from 4 to 6 above.
8) Upgrade the helm chart to _25.8_ version of sonarqube. Repeat the same steps from 4 to 6 above.
9) Once you have verified that the _25.8_ version works correctly, you can upgrade the actual sonarqube version now.
10) Completely delete the test sonarqube instance and cleanup any pending resources like PVCs or secrets.

#### Upgrading the acutal sonarqube from 10.3.0

1) Take a backup of the current postgres db and store it in S3 or locally where it can be easily restored in case of a failure.
2) Upgrade the helm chart to _10.8.0_ version of sonarqube. Approve the db migrations by navigating to sonarqube url `/setup`.
3) Check if the sonarqube says it is operational, elasticsearch cluster is green or not and you are able to log into the UI.
4) Once you are sure that all existing data (users, repos, plugins, rbac, etc) have been correctly migrated, then we can jump to the next version.
5) Take a logical backup of postgres db, and then run the `VACCUM FULL ANALYZE` commands on pgsql to cleanup old objects.
6) Upgrade the helm chart to _25.1_ version of sonarqube. Repeat the same steps from 2 to 5 above.
7) Upgrade the helm chart to _25.8_ version of sonarqube. Repeat the same steps from 2 to 5 above.
8) Check sonarqube logs after it has become operational, take care to document any errors or warnings and work on fixing them.
9) After an upgrade, the project repos need to be reindexed. Either do a manual reindex using the admin account by calling the web API, or via the project webhook.
10) The plugins might need an upgrade from the Marketplace, look at the list of possible plugin upgrades available for your sonarqube version.

## References

- https://github.com/SonarSource/helm-chart-sonarqube/releases
- https://github.com/SonarSource/sonarqube/releases
- https://docs.sonarsource.com/sonarqube-server/2025.1/server-upgrade-and-maintenance/upgrade/upgrade/
- https://docs.sonarsource.com/sonarqube-server/2025.1/server-upgrade-and-maintenance/upgrade/pre-upgrade-steps/#postgresql
- https://next.sonarqube.com/sonarqube/web_api/api/issues?query=reindex
- https://docs.sonarsource.com/sonarqube-community-build/server-upgrade-and-maintenance/upgrade/marketplace/