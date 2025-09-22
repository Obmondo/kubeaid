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

{{/*
Get the formatted "External" hostname or IP based URL
*/}}
{{- define "ironic.externalHttpUrl" }}
{{- $host := ternary (include "metal3.hostIP" .) .Values.global.externalHttpHost (empty .Values.global.externalHttpHost) }}
{{- if regexMatch ".*:.*" $host }}
{{- $host = print "[" $host "]" }}
{{- end }}
{{- $protocol := "http" }}
{{- $port := "6180" }}
{{- if .Values.global.enable_vmedia_tls }}
{{- $protocol = "https" }}
{{- $port = .Values.global.vmediaTLSPort | default "6185" }}
{{- end }}
{{- print $protocol "://" $host ":" $port }}
{{- end }}

{{/*
Get the command to use for Liveness and Readiness probes
*/}}
{{- define "ironic.probeCommand" }}
{{- $host := "127.0.0.1" }}
{{- if eq .Values.listenOnAll false }}
{{- $host = coalesce .Values.global.provisioningIP .Values.global.ironicIP .Values.global.provisioningHostname }}
{{- if regexMatch ".*:.*" $host }}
{{- $host = print "[" $host "]" }}
{{- end }}
{{- end }}
{{- print "curl -sSfk https://" $host ":6385" }}
{{- end }}

{{/*
Create the subjectAltNames section to be set on the Certificate
*/}}
{{- define "ironic.subjectAltNames" -}}
{{- with .Values.global }}
{{- if .provisioningHostname }}
dnsNames:
- {{ .provisioningHostname }}
{{- end -}}
{{- if or .ironicIP .provisioningIP }}
ipAddresses:
  - {{ coalesce .provisioningIP .ironicIP }}
{{- end }}
{{- end }}
{{- end }}
