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
Generate puppetdb name with optional customerid
*/}}
{{- define "puppetdb.name" -}}
{{- if .Values.customerid -}}
puppetdb-{{ .Values.customerid }}
{{- else -}}
puppetdb
{{- end -}}
{{- end -}}


{{/*
Generate service name with optional customerid
Usage: {{ include "puppetserver.serviceName" (dict "root" . "service" "puppet") }}
       {{ include "puppetserver.serviceName" (dict "root" . "service" "puppetdb") }}
*/}}
{{- define "puppetserver.serviceName" -}}
{{- if .root.Values.customerid -}}
puppetserver-{{ .root.Values.customerid }}-{{ .service }}
{{- else -}}
puppetserver-{{ .service }}
{{- end -}}
{{- end -}}
