# Netbird Self-Hosted Setup

This example provides a fully configured and tested setup for deploying Netbird using the following components:

- **Ingress Controller**: Nginx
- **Database Storage**: SQLite
- **Identity Provider**: Google

## Prerequisites

Before starting the setup, refer to the [Netbird documentation](https://docs.netbird.io/selfhosted/identity-providers#google-workspace) to configure your Google Identity Provider and generate the necessary parameters:

- `idpClientID`
- `idpClientSecret`
- `CustomerId`

Additionally, you will need the service account key downloaded as part of the documented steps for setting up the Google IDP.

## Kubernetes Secret Configuration

This setup requires Kubernetes secrets to store sensitive data. You'll need to create a secret named `netbird` in your Kubernetes cluster, containing the following key-value pairs:

- `idpClientID`: `xxxxxx` # The `clientId` from the Auth0 netbird application.
- `idpClientSecret`: `xxxxxx` # The `clientSecret` from the Auth0 netbird application.
- `relayPassword`: `xxxxxx` # Password used to secure communication between peers in the relay service.
- `stunServer`: `xxxxxx` # STUN server URL, e.g., `stun:stun.myexample.com:3478`.
- `turnServer`: `xxxxxx` # TURN server URL, e.g., `turn:turn.myexample.com:3478`.
- `turnServerUser`: `xxxxxx` # TURN server username.
- `turnServerPassword`: `xxxxxx` # TURN server password.
- `datastoreEncryptionKey`: `xxxxxxx` # A random encryption key for the datastore, e.g., generated via `openssl rand -base64 32`.
- `customerID`: `xxxxxxx` # The Google Workspace Customer ID belong to the directory of users that will be enumerated for access to Netbird. Found [here](https://support.google.com/a/answer/10070793?hl=en).

You will also be required to set up a kubernetes secret for `netbird-gcp-service-account` which contains the `sa.json` belong to the service account generated in the prerequisites.

> **Note:** The `datastoreEncryptionKey` must also be provided in a ConfigMap for the Netbird setup.

## Deployment

Once the required secrets and configuration are in place, this setup will deploy all necessary services for running Netbird, including the following exposed endpoints:

- `netbird-dashboard.example.com` - The Netbird dashboard.
- `netbird.example.com` - The main Netbird services (management|relay|signal).

## Additional info

Starting with Netbird v0.30.1, the platform supports reading environment variables directly within the `management.json` file. In this example, we leverage this feature by defining environment variables in the following format: `{{ .EnvVarName }}`.
