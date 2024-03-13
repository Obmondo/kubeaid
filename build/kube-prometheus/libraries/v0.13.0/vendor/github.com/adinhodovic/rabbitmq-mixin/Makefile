JSONNET_ARGS := -n 2 --max-blank-lines 2 --string-style s --comment-style s
ifneq (,$(shell which jsonnetfmt))
	JSONNET_FMT_CMD := jsonnetfmt
else
	JSONNET_FMT_CMD := jsonnet
	JSONNET_FMT_ARGS := fmt $(JSONNET_ARGS)
endif
JSONNET_FMT := $(JSONNET_FMT_CMD) $(JSONNET_FMT_ARGS)

all: fmt prometheus-alerts.yaml prometheus-rules.yaml dashboards-out lint test

fmt:
	find . -name 'vendor' -prune -o -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
		xargs -n 1 -- $(JSONNET_FMT) -i

prometheus-alerts.yaml: mixin.libsonnet alerts.jsonnet alerts/*.libsonnet
	jsonnet -J vendor -S alerts.jsonnet > $@

prometheus-rules.yaml: mixin.libsonnet rules.jsonnet rules/*.libsonnet
	jsonnet -J vendor -S rules.jsonnet > $@

dashboards-out: mixin.libsonnet dashboards.jsonnet dashboards/*.libsonnet
	@mkdir -p dashboards-out
	jsonnet -J vendor -m dashboards-out dashboards.jsonnet

lint: prometheus-alerts.yaml prometheus-rules.yaml
	find . -name 'vendor' -prune -o -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
		while read f; do \
			$(JSONNET_FMT) "$$f" | diff -u "$$f" -; \
		done

	promtool check rules prometheus-rules.yaml
	promtool check rules prometheus-alerts.yaml

clean:
	rm -rf dashboards-out prometheus-alerts.yaml prometheus-rules.yaml

test: prometheus-alerts.yaml prometheus-rules.yaml
	promtool test rules tests.yaml
