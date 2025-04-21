#!/bin/sh

helm -n o2 template . -f values.yaml > o2.yaml
