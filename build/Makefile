#customizing kube-prometheus

#include ../../Makefile.common

MANIFESTS_DIR := manifests/
JSONNET_VENDOR := vendor/
MAIN_DIR := my-kube-prometheus/




#run "make setup" to init jb,install jb, jsonnet library(kube-prometheus), update jb, install gojsontoyaml.
#run "make build" to compile/build the manifests
#run "make kubectl-apply" to apply the manifests for creating the resources


.PHONY: setup
setup:
	go install -a github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
	jb init
	jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@main
	jb update
	go install github.com/brancz/gojsontoyaml@latest
	go install github.com/google/go-jsonnet/cmd/jsonnet@latest

.PHONY: build
build:
	./build.sh example.jsonnet


.PHONY: kubectl-apply
kubectl-apply:
	kubectl apply -f $(MANIFESTS_DIR)
	kubectl get all -n monitoring

#.ONESHELL:
#foo : bar/lose
#        cd $(@D)
#        gobble $(@F) > ../$@
