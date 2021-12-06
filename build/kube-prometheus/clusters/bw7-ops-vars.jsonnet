{
	platform: "aws",
	grafana_root_url: "",
	grafana_signout_redirect_url: "",
	grafana_auth_url: "",
    grafana_token_url: "",
    grafana_api_url: "",
    grafana_ingress_host: "",

	prometheus_operator_resources: {
		limits: { cpu: '100m', memory: '70Mi' },
		requests: { cpu: '10m', memory: '30Mi' },
	},
	alertmanager_resources: {
		"limits": { "cpu" : "100m", "memory": "50Mi" },
		"requests": { "cpu": "10m", "memory": "20Mi" }
		},
	prometheus_resources: {
		"limits": { "memory": "1Gi" },
		"requests": { "cpu": "100m", "memory": "200Mi" }
		},


}