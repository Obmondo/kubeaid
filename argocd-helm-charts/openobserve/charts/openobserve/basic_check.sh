#!/bin/sh

helm -n o2 template . -f values.yaml > o2.yaml
# helm -n o2 template . -f test_values_external_secret.yaml > o2.yaml
