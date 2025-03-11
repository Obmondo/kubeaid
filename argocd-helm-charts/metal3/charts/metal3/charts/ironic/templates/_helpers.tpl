{{/*
Expand the name of the chart.
*/}}
{{- define "ironic.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ironic.fullname" -}}
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
{{- define "ironic.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ironic.labels" -}}
helm.sh/chart: {{ include "ironic.chart" . }}
{{ include "ironic.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ironic.selectorLabels" -}}
app.kubernetes.io/component: ironic
app.kubernetes.io/name: {{ include "ironic.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ironic.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ironic.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Shared directory volumeMount
*/}}
{{- define "ironic.sharedVolumeMount" -}}
- mountPath: /shared
  name: ironic-data-volume
{{- end }}

{{/*
Get ironic CA volumeMounts
*/}}
{{- define "ironic.CAVolumeMounts" -}}
- name: cert-ironic-ca
  mountPath: "/certs/ca/ironic"
  readOnly: true
{{- if .Values.global.enable_vmedia_tls }}
- name: cert-ironic-vmedia-ca
  mountPath: "/certs/ca/vmedia"
  readOnly: true
{{- end }}
{{- end }}
