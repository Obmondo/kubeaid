#customizing kube-prometheus

#include ../../Makefile.common

MANIFESTS_DIR := manifests/
JSONNET_VENDOR := vendor/
MAIN_DIR := my-kube-prometheus/


#run "make generate" to create the directory
#manually cd into my-kube-prometheus/
#run "make setup" to init jb,install jb, jsonnet library(kube-prometheus), build.sh etc., update jb, install gojsontoyaml.
#run "make build" to edit build.sh file and compile/build the manifests
#run "make kubectl-apply" to apply the manifests for creating the resources

.PHONY: generate
generate:
	mkdir $(MAIN_DIR)

.PHONY: setup
setup:
	go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb
	jb init
	jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@main
	wget https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/main/example.jsonnet -O example.jsonnet
	wget https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/main/build.sh -O build.sh
	chmod +x build.sh
	jb update
	go get github.com/brancz/gojsontoyaml
	go get github.com/google/go-jsonnet/cmd/jsonnet

.PHONY: build
build:
	sed -i 's/jsonnet -J vendor -m manifests "${1-example.jsonnet}" | xargs -I{} sh -c "cat {} | gojsontoyaml > {}.yaml" -- {}/jsonnet -J vendor -m manifests "${1-example.jsonnet}" | xargs -I{} sh -c "cat {} | $(go env GOPATH)/bin/gojsontoyaml > {}.yaml; rm -f {}" -- {}/g' build.sh
	./build.sh example.jsonnet


.PHONY: kubectl-apply
kubectl-apply:
	kubectl apply -f $(MANIFESTS_DIR)
	kubectl get all -n monitoring

#.ONESHELL:
#foo : bar/lose
#        cd $(@D)
#        gobble $(@F) > ../$@
