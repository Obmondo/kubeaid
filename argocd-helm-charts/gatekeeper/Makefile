# This Makefile assumes that the opa binary is installed and reachable in the PATH
# You can install OPA from here : https://github.com/open-policy-agent/opa/releases

.PHONY: test

test: ## Run unit tests
	opa test -v ./policies

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
