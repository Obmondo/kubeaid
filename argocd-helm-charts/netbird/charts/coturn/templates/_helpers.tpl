{{- define "coturn.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "coturn.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "labels" -}}
helm.sh/chart: {{ include "coturn.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: "coturn"
{{- end -}}


{{/*
Create image name that is used in the deployment
*/}}
{{- define "coturn.image" -}}
{{- if .Values.image.tag -}}
{{- printf "%s:%s" .Values.image.repository .Values.image.tag -}}
{{- else -}}
{{- printf "%s:%s" .Values.image.repository .Chart.AppVersion -}}
{{- end -}}
{{- end -}}

{{/*
Helper function to get the coturn secret containing db credentials
*/}}
{{- define "database.secretName" -}}
{{- if .Values.externalDatabase.existingSecret -}}
{{ .Values.externalDatabase.existingSecret }}
{{- else if .Values.postgresql.global.postgresql.auth.existingSecret -}}
{{ .Values.postgresql.global.postgresql.auth.existingSecret }}
{{- else -}}
{{ .Release.Name }}-db-secret
{{- end -}}
{{- end -}}

{{/*
Helper function to get the coturn secret containing admin coturn credentials
*/}}
{{- define "coturn.auth.secretName" -}}
{{- if .Values.coturn.auth.existingSecret -}}
{{ .Values.coturn.auth.existingSecret }}
{{- else -}}
{{ .Release.Name }}-auth-secret
{{- end }}
{{- end }}

{{- define "db.isReady.image.repository" -}}
{{- if and .Values.externalDatabase.enabled (eq .Values.externalDatabase.type "postgresql") -}}
{{ .Values.externalDatabase.image.repository | default "postgres" }}
{{- else if and .Values.externalDatabase.enabled (eq .Values.externalDatabase.type "mysql") -}}
{{ .Values.externalDatabase.image.repository | default "mysql" }}
{{- else if .Values.postgresql.enabled -}}
{{ .Values.postgresql.image.repository }}
{{- else if .Values.mysql.enabled -}}
{{ .Values.mysql.image.repository }}
{{- end -}}
{{- end -}}

{{- define "db.isReady.image.tag" -}}
{{- if and .Values.externalDatabase.enabled (eq .Values.externalDatabase.type "postgresql") -}}
{{ .Values.externalDatabase.image.tag | default "15-alpine" }}
{{- else if and .Values.externalDatabase.enabled (eq .Values.externalDatabase.type "mysql") -}}
{{ .Values.externalDatabase.image.tag | default "8.0.35" }}
{{- else if .Values.postgresql.enabled -}}
{{ .Values.postgresql.image.tag }}
{{- else if .Values.mysql.enabled -}}
{{ .Values.mysql.image.tag }}
{{- end -}}
{{- end -}}
