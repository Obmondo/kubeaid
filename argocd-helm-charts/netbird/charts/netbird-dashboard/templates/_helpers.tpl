{{/*
Expand the name of the chart.
*/}}
{{- define "netbird-dashboard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "netbird-dashboard.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "netbird-dashboard.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels for all workloads
*/}}
{{- define "netbird.defaultLabels" -}}
{{- if .Values.defaultLabels }}
{{- range $key, $val := .Values.defaultLabels }}
{{ $key }}: {{ $val }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "netbird-dashboard.labels" -}}
helm.sh/chart: {{ include "netbird-dashboard.chart" . }}
{{ include "netbird.defaultLabels" . }}
{{ include "netbird-dashboard.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "netbird-dashboard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "netbird-dashboard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "netbird-dashboard.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "netbird-dashboard.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Overrides container entrypoint based on a flag
*/}}
{{- define "netbird-dashboard.disableIPv6" -}}
{{- if .Values.netbird.disableIPv6 }}
command: ["/bin/sh", "-c"]
args:
- >
  sed -i 's/listen \[\:\:\]\:80 default_server\;//g' /etc/nginx/http.d/default.conf &&
  /usr/bin/supervisord -c /etc/supervisord.conf
{{- end }}
{{- end }}
