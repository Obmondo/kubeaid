{{/*
Expand the name of the chart.
*/}}
{{- define "snapshot-validation-webhook.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "snapshot-validation-webhook.fullname" -}}
{{- if contains .Chart.Name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "snapshot-validation-webhook.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "snapshot-validation-webhook.labels" -}}
helm.sh/chart: {{ include "snapshot-validation-webhook.chart" . }}
{{ include "snapshot-validation-webhook.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "snapshot-validation-webhook.selectorLabels" -}}
app.kubernetes.io/name: {{ include "snapshot-validation-webhook.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "snapshot-validation-webhook.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "snapshot-validation-webhook.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Certificate secret name
*/}}
{{- define "snapshot-validation-webhook.certifcateName" -}}
{{- if .Values.tls.certificateSecret }}
{{- .Values.tls.certificateSecret }}
{{- else }}
{{- include "snapshot-validation-webhook.fullname" . }}-tls
{{- end }}
{{- end }}
