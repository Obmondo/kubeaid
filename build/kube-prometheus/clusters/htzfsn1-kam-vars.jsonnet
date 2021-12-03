{
	platform: 'kubeadm',
	grafana_root_url: 'https://grafana.kam.obmondo.com',
	grafana_signout_redirect_url: "https://keycloak.kam.obmondo.com/auth/realms/devops/protocol/openid-connect/logout?redirect_uri=https://grafana.kam.obmondo.com",
	grafana_auth_url: "https://keycloak.kam.obmondo.com/auth/realms/devops/protocol/openid-connect/auth",
    grafana_token_url: "https://keycloak.kam.obmondo.com/auth/realms/devops/protocol/openid-connect/token",
    grafana_api_url: "https://keycloak.kam.obmondo.com/auth/realms/devops/protocol/openid-connect/userinfo",
    grafana_ingress_host: "grafana.kam.obmondo.com",

}