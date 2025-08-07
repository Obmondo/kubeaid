# Netbird

This Helm chart is for self hosting https://netbird.io/ 

## Integration with Keycloak IdP

See the [values.yaml](./examples/values-keycloak.yaml) for an example values file for setting up Netbird with Keycloak IdP.

The upstream docs can be referenced [here](https://docs.netbird.io/selfhosted/identity-providers#keycloak).

## Troubleshooting

### GET /api/users status 401

Netbird caches the Keycloak users locally. If it is not able to fetch the users from Keycloak, it throws an error with

```
unable to get keycloak token, statusCode 401
```

**Solution:**

- Set the log level to Debug for the netbird-management pod with `--log-level=debug` as the container arg, and check the pod logs about token not found 
- Check if the service account `netbird-backend` has the permission to `view-users` in Keycloak
- Check if the `AdminEndpoint` in the IdPManagerConfig is correct `https://keycloak.example.com/auth/admin/realms/netbird`

Once this is correct, Netbird pod should be able to warm up the cache and fetch user IDs.

## References and External Links

- https://docs.netbird.io/about-netbird/how-netbird-works
- https://docs.netbird.io/selfhosted/identity-providers#keycloak
- https://docs.netbird.io/selfhosted/troubleshooting