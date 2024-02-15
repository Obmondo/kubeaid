.PHONY: lint test

test:
	docker run ${DOCKER_ARGS} --rm -v $(CURDIR):/charts -w /charts quintush/helm-unittest:3.11.0-0.3.0 --color /charts;
