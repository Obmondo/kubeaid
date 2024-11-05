{{/* vim: set filetype=mustache: */}}
{{/*
Simplified name of the secret name for issuing wildcard certificate.
*/}}
{{- define "wildcard-cert.namefix" -}}
{{ printf "%s" . | trimPrefix "*" | trimPrefix "." | replace "." "-" }}
{{- end -}}
