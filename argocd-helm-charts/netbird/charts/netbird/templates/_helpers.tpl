{{/*
Expand the name of the chart.
*/}}
{{- define "netbird.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "netbird.fullname" -}}
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
{{- define "netbird.chart" -}}
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
Common management labels
*/}}
{{- define "netbird.management.labels" -}}
helm.sh/chart: {{ include "netbird.chart" . }}
{{ include "netbird.defaultLabels" . }}
{{ include "netbird.management.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Common signal labels
*/}}
{{- define "netbird.signal.labels" -}}
helm.sh/chart: {{ include "netbird.chart" . }}
{{ include "netbird.defaultLabels" . }}
{{ include "netbird.signal.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Common relay labels
*/}}
{{- define "netbird.relay.labels" -}}
helm.sh/chart: {{ include "netbird.chart" . }}
{{ include "netbird.defaultLabels" . }}
{{ include "netbird.relay.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Management selector labels
*/}}
{{- define "netbird.management.selectorLabels" -}}
app.kubernetes.io/name: {{ include "netbird.name" . }}-management
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Signal selector labels
*/}}
{{- define "netbird.signal.selectorLabels" -}}
app.kubernetes.io/name: {{ include "netbird.name" . }}-signal
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Relay selector labels
*/}}
{{- define "netbird.relay.selectorLabels" -}}
app.kubernetes.io/name: {{ include "netbird.name" . }}-relay
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the management service account to use
*/}}
{{- define "netbird.management.serviceAccountName" -}}
{{- if .Values.management.serviceAccount.create }}
{{- default (printf "%s-management" (include "netbird.fullname" .)) .Values.management.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.management.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the signal service account to use
*/}}
{{- define "netbird.signal.serviceAccountName" -}}
{{- if .Values.signal.serviceAccount.create }}
{{- default (printf "%s-signal" (include "netbird.fullname" .)) .Values.signal.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.signal.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the relay service account to use
*/}}
{{- define "netbird.relay.serviceAccountName" -}}
{{- if .Values.relay.serviceAccount.create }}
{{- default (printf "%s-relay" (include "netbird.fullname" .)) .Values.relay.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.relay.serviceAccount.name }}
{{- end }}
{{- end }}
