{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "graylog.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "graylog.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "graylog.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "graylog.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the headless service
*/}}
{{- define "graylog.service.headless.name" }}
{{- printf "%s-%s" (include "graylog.fullname" .) .Values.graylog.service.headless.suffix | trimSuffix "-" -}}
{{- end -}}

{{/*
Craft url taking into account the TLS settings of the server
*/}}
{{- define "graylog.formatUrl" -}}
{{- $env := index . 0 }}
{{- $url := index . 1 }}
{{- if $env.Values.graylog.tls.enabled }}
{{- printf "https://%s" $url }}
{{- else }}
{{- printf "http://%s" $url }}
{{- end -}}
{{- end -}}

{{/*
Print external URI
*/}}
{{- define "graylog.url" -}}
{{- if .Values.graylog.externalUri }}
{{- printf .Values.graylog.externalUri }}
{{- else if .Values.graylog.ingress.enabled }}
{{- if .Values.graylog.ingress.tls }}
{{- range .Values.graylog.ingress.tls }}{{ range .hosts }}https://{{ . }}{{ end }}{{ end }}
{{- else }}
{{- range .Values.graylog.ingress.hosts }}http://{{ . }}{{ end }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Create a default fully qualified opensearch name or use the `graylog.opensearch.hosts` value if defined.
Or use chart dependencies with release name
*/}}
{{- define "graylog.opensearch.hosts" -}}
{{- if .Values.graylog.opensearch.uriSecretKey }}
    {{- if .Values.graylog.opensearch.uriSSL }}
        {{- printf "https://${GRAYLOG_ELASTICSEARCH_HOSTS}" -}}
    {{- else }}
        {{- printf "http://${GRAYLOG_ELASTICSEARCH_HOSTS}" -}}
    {{- end }}
{{- else if .Values.graylog.opensearch.hosts }}
    {{- .Values.graylog.opensearch.hosts -}}
{{- else }}
    {{- printf "http://opensearch-cluster-master-headless.%s.svc.cluster.local:9200" .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "graylog.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Standard metadata labels used by the chart.
*/}}
{{- define "graylog.metadataLabels" -}}
helm.sh/chart: {{ template "graylog.chart" . }}
{{ template "graylog.selectorLabels" . }}
app.kubernetes.io/version: "{{ .Chart.AppVersion }}"
{{- end -}}

{{/*
Selector labels used by the chart.
*/}}
{{- define "graylog.selectorLabels" -}}
app.kubernetes.io/name: {{ template "graylog.name" . }}
app.kubernetes.io/instance: "{{ .Release.Name }}"
{{- if .Values.helm2Compatibility }}
app.kubernetes.io/managed-by: "Tiller"
{{- else }}
app.kubernetes.io/managed-by: "{{ .Release.Service }}"
{{- end -}}
{{- end -}}

{{/*
Set's the affinity for pod placement when running in standalone and HA modes.
*/}}
{{- define "graylog.affinity" -}}
  {{- if .Values.graylog.affinity }}
      affinity:
        {{ $tp := typeOf .Values.graylog.affinity }}
        {{- if eq $tp "string" }}
          {{- tpl .Values.graylog.affinity . | nindent 8 | trim }}
        {{- else }}
          {{- toYaml .Values.graylog.affinity | nindent 8 }}
        {{- end }}
  {{ end }}
{{- end -}}

{{/*
Generate graylog root password if not set
*/}}
{{- define "graylog.password" -}}
  {{- if .Values.graylog.rootPassword }}
    {{- .Values.graylog.rootPassword -}}
  {{- else -}}
    {{- $secretName := (include "graylog.fullname" .) -}}
    {{- $namespace := .Release.Namespace -}}
    {{- $existingSecret := lookup "v1" "Secret" $namespace $secretName -}}
    {{- if $existingSecret -}}
        {{- (index $existingSecret.data "graylog-password-secret") | b64dec -}}
    {{- else -}}
        {{- randAlphaNum 16 -}}
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
Generate mongodb password if not set
*/}}
{{- define "graylog.mongodb.auth.password" -}}
  {{- if .Values.mongodb.community.auth.password }}
    {{- .Values.mongodb.community.auth.password -}}
  {{- else -}}
    {{- $secretName := (include "graylog.mongodb.name" .) -}}
    {{- $namespace := .Release.Namespace -}}
    {{- $existingSecret := lookup "v1" "Secret" $namespace $secretName -}}
    {{- if $existingSecret -}}
      {{- index $existingSecret.data "password" | b64dec -}}
    {{- else -}}
      {{- randAlphaNum 20 -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Generate mongodb name if not set
*/}}
{{- define "graylog.mongodb.name" -}}
{{- printf "%s-mongodb" (include "graylog.fullname" $) }}
{{- end -}}