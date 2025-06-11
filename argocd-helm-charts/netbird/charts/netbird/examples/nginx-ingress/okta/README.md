# Netbird Self-Hosted Setup

This example provides a fully configured and tested setup for deploying Netbird using the following components:

- **Ingress Controller**: Nginx
- **Database Storage**: SQLite
- **Identity Provider**: Okta

## Prerequisites

Before starting the setup, refer to the [Netbird documentation](https://docs.netbird.io/selfhosted/identity-providers#okta) to configure your Okta Identity Provider and generate the necessary parameters:

- `idpClientID`
- `oktaApiToken`
- `idpNativeAppClientID`

## Kubernetes Secret Configuration

This setup requires Kubernetes secrets to store sensitive data. You'll need to create a secret named `netbird` in your Kubernetes cluster, containing the following key-value pairs:

- `idpClientID`: `xxxxxx` # The `clientId` from the Okta netbird application.
- `oktaApiToken`: `xxxxxx`# The Okta API Token with permissions to read okta directory.
- `idpNativeAppClientID`: `xxxxxx` # The `clientId` from the Okta netbird nativeapp application.
- `relayPassword`: `xxxxxx` # Password used to secure communication between peers in the relay service.
- `stunServer`: `xxxxxx` # STUN server URL, e.g., `stun:stun.myexample.com:3478`.
- `turnServer`: `xxxxxx` # TURN server URL, e.g., `turn:turn.myexample.com:3478`.
- `turnServerUser`: `xxxxxx` # TURN server username.
- `turnServerPassword`: `xxxxxx` # TURN server password.
- `datastoreEncryptionKey`: `xxxxxxx` # A random encryption key for the datastore, e.g., generated via `openssl rand -base64 32`.

> **Note:** The `datastoreEncryptionKey` must also be provided in a ConfigMap for the Netbird setup.

## Deployment

Once the required secrets and configuration are in place, this setup will deploy all necessary services for running Netbird, including the following exposed endpoints:

- `netbird-dashboard.example.com` - The Netbird dashboard.
- `netbird.example.com` - The main Netbird services (management|relay|signal).

## Additional info

Starting with Netbird v0.30.1, the platform supports reading environment variables directly within the `management.json` file. In this example, we leverage this feature by defining environment variables in the following format: `{{ .EnvVarName }}`.
