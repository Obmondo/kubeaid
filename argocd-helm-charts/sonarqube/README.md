# SonarQube

please look at the [README](./charts/sonarqube/README.md)

## OpenID Connect

We use delegated authentication via openID connect identity provider Keycloak

For OIDC integration we use this [plugin](https://github.com/vaulttec/sonar-auth-oidc).
Please follow the steps in the README of the plugin.

In addition to these steps you will need to set the sonar.core.serverBaseURL variable.
This is done as shown below.

![set sonar.core.serverBaseURL](./docs/images/sonar.core.serverBaseURL.jpg?raw=true "set sonar.core.serverBaseURL")

## Upgrading SonarQube

- First check the [release notes](https://github.com/SonarSource/helm-chart-sonarqube/releases) for any specific upgrade
    guide for the new version

### If there is no specific upgrade guide available for the chart version then follow the below steps

1. Sync the latest version of the chart via argocd
2. After successfull sync, open sonarqube in browser if it shows message regarding maintance follow step 3 else skip.
    ![maintanance](./docs/images/maintanance.png?raw=true "set maintanance")
3. Visit the `/setup` endpoint and click on start upgrade database.
    ![setup](./docs/images/upgradedb-1.png?raw=true "setup")
    After successfull upgrade it will show the below message
    ![setup](./docs/images/upgradedb-2.png?raw=true "setup")

- For more info checkout[SonarQube Upgrade Guide](https://docs.sonarqube.org/latest/setup/upgrading/)
