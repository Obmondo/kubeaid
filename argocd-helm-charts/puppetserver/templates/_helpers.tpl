{{/* vim: set filetype=mustache: */}}

{{/*
Generate puppetserver name with optional customerid
*/}}
{{- define "puppetserver.name" -}}
{{- if .Values.customerid -}}
puppetserver-{{ .Values.customerid }}
{{- else -}}
puppetserver
{{- end -}}
{{- end -}}

{{/*
Generate puppetserver service name with optional customerid
*/}}
{{- define "puppetserver.serviceName" -}}
{{- if .Values.customerid -}}
puppetserver-{{ .Values.customerid }}-puppet
{{- else -}}
puppetserver-puppet
{{- end -}}
{{- end -}}
