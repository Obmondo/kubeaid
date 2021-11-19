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
	go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb
	jb init
	jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@main
# build.sh and example.jsonnet files have been downloaded and provided in this same directory
	chmod +x build.sh
	jb update
	go get github.com/brancz/gojsontoyaml
	go get github.com/google/go-jsonnet/cmd/jsonnet

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
