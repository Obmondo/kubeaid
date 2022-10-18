# SonarQube

please look at the [README](./charts/sonarqube/README.md)

## OpenID Connect

We use delegated authentication via openID connect identity provider Keycloak

For OIDC integration we use this [plugin](https://github.com/vaulttec/sonar-auth-oidc).
Please follow the steps in the README of the plugin.

In addition to these steps you will need to set the sonar.core.serverBaseURL variable.
This is done as shown below.

![set sonar.core.serverBaseURL](./docs/images/sonar.core.serverBaseURL.jpg?raw=true "set sonar.core.serverBaseURL")
