{{/* TODO : Enforce mutual exclusions. */}}

{{- define "controlPlaneHost" -}}
{{- if and (.Values.hcloud).enabled .Values.hcloud.controlPlane }}
{{ .Values.hcloud.controlPlane.endpoint.host }}
{{- else }}
{{ .Values.robot.controlPlane.endpoint.host }}
{{- end }}
{{- end }}
