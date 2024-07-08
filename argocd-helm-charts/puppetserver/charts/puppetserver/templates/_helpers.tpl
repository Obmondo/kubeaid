{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "puppetserver.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 29 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "puppetserver.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 52 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "puppetserver.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 29 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf .Release.Name | trunc 29 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 29 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the args array for "r10k_code_cronjob.sh"
*/}}
{{- define "r10k.code.args" -}}
{{- join " " .Values.r10k.code.extraArgs }}
{{- end -}}

{{/*
Create the base URL for custom CA repo configuration
*/}}
{{- define "r10k.code.viaHttps.customCa.repoUrl" -}}
{{- $parsedRepo := urlParse .Values.puppetserver.puppeturl -}}
{{- printf "%s://%s" $parsedRepo.scheme $parsedRepo.host }}
{{- end -}}

{{/*
Create the args array for "r10k_hiera_cronjob.sh"
*/}}
{{- define "r10k.hiera.args" -}}
{{- join " " .Values.r10k.hiera.extraArgs }}
{{- end -}}

{{/*
Create unified labels for Puppetserver components
*/}}
{{- define "puppetserver.common.metaLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ template "puppetserver.chart" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end -}}

{{- define "puppetserver.common.matchLabels" -}}
app.kubernetes.io/name: {{ template "puppetserver.name" . }}
{{- end -}}

{{- define "puppetserver.puppet.labels" -}}
{{ include "puppetserver.common.matchLabels" . }}
{{ include "puppetserver.common.metaLabels" . }}
{{- end -}}

{{- define "puppetserver.hiera.labels" -}}
{{ include "puppetserver.hiera.matchLabels" . }}
{{ include "puppetserver.common.metaLabels" . }}
{{- end -}}

{{- define "puppetserver.hiera.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.hiera.name }}
{{ include "puppetserver.common.matchLabels" . }}
{{- end -}}

{{- define "puppetserver.r10k.labels" -}}
{{ include "puppetserver.r10k.matchLabels" . }}
{{ include "puppetserver.common.metaLabels" . }}
{{- end -}}

{{- define "puppetserver.r10k.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.r10k.name }}
{{ include "puppetserver.common.matchLabels" . }}
{{- end -}}

{{- define "puppetserver.postgresql.labels" -}}
{{ include "puppetserver.postgresql.matchLabels" . }}
{{ include "puppetserver.common.metaLabels" . }}
{{- end -}}

{{- define "puppetserver.postgresql.matchLabels" -}}
app.kubernetes.io/component: postgresql
{{ include "puppetserver.common.matchLabels" . }}
{{- end -}}

{{- define "puppetserver.puppetdb.labels" -}}
{{ include "puppetserver.puppetdb.matchLabels" . }}
{{ include "puppetserver.common.metaLabels" . }}
{{- end -}}

{{- define "puppetserver.puppetdb.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.puppetdb.name }}
{{ include "puppetserver.common.matchLabels" . }}
{{- end -}}

{{- define "puppetserver.puppetboard.labels" -}}
{{ include "puppetserver.puppetboard.matchLabels" . }}
{{ include "puppetserver.common.metaLabels" . }}
{{- end -}}

{{- define "puppetserver.puppetboard.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.puppetboard.name }}
{{ include "puppetserver.common.matchLabels" . }}
{{- end -}}

{{- define "puppetserver.puppetserver.labels" -}}
{{ include "puppetserver.puppetserver.matchLabels" . }}
{{ include "puppetserver.common.metaLabels" . }}
{{- end -}}

{{- define "puppetserver.puppetserver.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.puppetserver.name }}
{{ include "puppetserver.common.matchLabels" . }}
{{- end -}}

{{- define "puppetserver.puppetserver-compilers.labels" -}}
{{ include "puppetserver.puppetserver-compilers.matchLabels" . }}
{{ include "puppetserver.common.metaLabels" . }}
{{- end -}}

{{- define "puppetserver.puppetserver-compilers.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.puppetserver.name }}-compilers
{{ include "puppetserver.common.matchLabels" . }}
{{- end -}}

{{- define "puppetserver.puppetserver-data.labels" -}}
{{ include "puppetserver.puppetserver-data.matchLabels" . }}
{{ include "puppetserver.common.metaLabels" . }}
{{- end -}}

{{- define "puppetserver.puppetserver-data.matchLabels" -}}
app.kubernetes.io/component: {{ .Values.puppetserver.name }}-serverdata
{{ include "puppetserver.common.matchLabels" . }}
{{- end -}}

{{/*
Create the name for the Puppet Server Puppet Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.puppet.claimName" -}}
{{- if .Values.puppetserver.persistence.puppet.existingClaim -}}
  {{- .Values.puppetserver.persistence.puppet.existingClaim -}}
{{- else -}}
  {{ template "puppetserver.fullname" . }}-puppet-claim
{{- end -}}
{{- end -}}

{{/*
Create the annotations for the Puppet Server Puppet Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.puppet.annotations" -}}
{{- if .Values.puppetserver.persistence.puppet.annotations -}}
  {{- .Values.puppetserver.persistence.puppet.annotations | toYaml -}}
{{- else -}}
{{- if .Values.storage.annotations -}}
  {{- .Values.storage.annotations | toYaml -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the storageClassName for the Puppet Server Puppet Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.puppet.storageClass" -}}
{{- if .Values.puppetserver.persistence.puppet.storageClass -}}
  {{- .Values.puppetserver.persistence.puppet.storageClass -}}
{{- else -}}
  {{- .Values.storage.storageClass -}}
{{- end -}}
{{- end -}}

{{/*
Create the name for the Puppet Server Code Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.code.claimName" -}}
{{- if .Values.puppetserver.persistence.code.existingClaim -}}
  {{- .Values.puppetserver.persistence.code.existingClaim -}}
{{- else -}}
  {{ template "puppetserver.fullname" . }}-code-claim
{{- end -}}
{{- end -}}

{{/*
Create a readinessProbe
*/}}
{{- define "r10k.code.readinessProbe" -}}
{{- if .Values.r10k.code.readinessProbe -}}
  {{- .Values.r10k.code.readinessProbe | toYaml  -}}
{{- else -}}
  {{- $list := list "/bin/sh" "-ec" ( printf "test -f %s" .Values.r10k.code.cronJob.successFile ) }}
  {{- $list | toYaml -}}
{{- end -}}
{{- end -}}

{{/*
Create the annotations for the Puppet Server Code Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.code.annotations" -}}
{{- if .Values.puppetserver.persistence.code.annotations -}}
  {{- .Values.puppetserver.persistence.code.annotations | toYaml -}}
{{- else -}}
{{- if .Values.storage.annotations -}}
  {{- .Values.storage.annotations | toYaml -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the storageClassName for the Puppet Server Code Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.code.storageClass" -}}
{{- if .Values.puppetserver.persistence.code.storageClass -}}
  {{- .Values.puppetserver.persistence.code.storageClass -}}
{{- else -}}
  {{- .Values.storage.storageClass -}}
{{- end -}}
{{- end -}}

{{/*
Create the name for the Puppet Server Server Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.server.claimName" -}}
{{- if .Values.puppetserver.persistence.server.existingClaim -}}
  {{- .Values.puppetserver.persistence.server.existingClaim -}}
{{- else -}}
  {{ template "puppetserver.fullname" . }}-puppetserver-claim
{{- end -}}
{{- end -}}

{{/*
Create the annotations for the Puppet Server Server Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.server.annotations" -}}
{{- if .Values.puppetserver.persistence.server.annotations -}}
  {{- .Values.puppetserver.persistence.server.annotations | toYaml -}}
{{- else -}}
{{- if .Values.storage.annotations -}}
  {{- .Values.storage.annotations | toYaml -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the storageClassName for the Puppet Server Server Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.server.storageClass" -}}
{{- if .Values.puppetserver.persistence.server.storageClass -}}
  {{- .Values.puppetserver.persistence.server.storageClass -}}
{{- else -}}
  {{- .Values.storage.storageClass -}}
{{- end -}}
{{- end -}}

{{/*
Create the name for the Puppet Server Data Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.data.claimName" -}}
{{- if .Values.puppetserver.persistence.data.existingClaim -}}
  {{- .Values.puppetserver.persistence.data.existingClaim -}}
{{- else -}}
  {{ template "puppetserver.fullname" . }}-serverdata-claim
{{- end -}}
{{- end -}}

{{/*
Create the annotations for the Puppet Server Data Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.data.annotations" -}}
{{- if .Values.puppetserver.persistence.data.annotations -}}
  {{- .Values.puppetserver.persistence.data.annotations | toYaml -}}
{{- else -}}
{{- if .Values.storage.annotations -}}
  {{- .Values.storage.annotations | toYaml -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the storageClassName for the Puppet Server Data Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.data.storageClass" -}}
{{- if .Values.puppetserver.persistence.data.storageClass -}}
  {{- .Values.puppetserver.persistence.data.storageClass -}}
{{- else -}}
  {{- .Values.storage.storageClass -}}
{{- end -}}
{{- end -}}

{{/*
Create the name for the Puppet Server CA Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.ca.claimName" -}}
{{- if .Values.puppetserver.persistence.ca.existingClaim -}}
  {{- .Values.puppetserver.persistence.ca.existingClaim -}}
{{- else -}}
  {{ template "puppetserver.fullname" . }}-ca-claim
{{- end -}}
{{- end -}}

{{/*
Create the annotations for the Puppet Server CA Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.ca.annotations" -}}
{{- if .Values.puppetserver.persistence.ca.annotations -}}
  {{- .Values.puppetserver.persistence.ca.annotations | toYaml -}}
{{- else -}}
{{- if .Values.storage.annotations -}}
  {{- .Values.storage.annotations | toYaml -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the storageClassName for the Puppet Server CA Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.ca.storageClass" -}}
{{- if .Values.puppetserver.persistence.ca.storageClass -}}
  {{- .Values.puppetserver.persistence.ca.storageClass -}}
{{- else -}}
  {{- .Values.storage.storageClass -}}
{{- end -}}
{{- end -}}

{{/*
Create the name for the Puppet Server conf.d Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.confd.claimName" -}}
{{- if .Values.puppetserver.persistence.confd.existingClaim -}}
  {{- .Values.puppetserver.persistence.confd.existingClaim -}}
{{- else -}}
  {{ template "puppetserver.fullname" . }}-confd-claim
{{- end -}}
{{- end -}}

{{/*
Create the annotations for the Puppet Server conf.d Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.confd.annotations" -}}
{{- if .Values.puppetserver.persistence.confd.annotations -}}
  {{- .Values.puppetserver.persistence.confd.annotations | toYaml -}}
{{- else -}}
{{- if .Values.storage.annotations -}}
  {{- .Values.storage.annotations | toYaml -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the storageClassName for the Puppet Server conf.d Persistent Volume Claim.
*/}}
{{- define "puppetserver.persistence.confd.storageClass" -}}
{{- if .Values.puppetserver.persistence.confd.storageClass -}}
  {{- .Values.puppetserver.persistence.confd.storageClass -}}
{{- else -}}
  {{- .Values.storage.storageClass -}}
{{- end -}}
{{- end -}}


{{/*
Set mandatory Puppet Server Masters' Service name.
*/}}
{{- define "puppetserver.puppetserver-masters.serviceName" -}}
{{ template "puppetserver.fullname" . }}-puppet
{{- end -}}

{{/*
Set secondary Puppet Server Masters' Service name for Puppet Agents.
*/}}
{{- define "puppetserver.puppetserver.agents-to-masters.serviceName" -}}
{{ template "puppetserver.fullname" . }}-agents-to-puppet
{{- end -}}

{{/*
Set mandatory Puppet Server Compilers' Service name.
*/}}
{{- define "puppetserver.puppetserver-compilers.serviceName" -}}
{{ template "puppetserver.fullname" . }}-puppet-compilers
{{- end -}}

{{/*
Puppet Masters' port.
*/}}
{{- define "puppetserver.puppetserver-masters.port" -}}
{{- if .Values.puppetserver.masters.service.ports.puppetserver.port -}}
{{- .Values.puppetserver.masters.service.ports.puppetserver.port -}}
{{- else -}}
8140
{{- end -}}
{{- end -}}

{{/*
Puppet Compilers' port.
*/}}
{{- define "puppetserver.puppetserver-compilers.port" -}}
{{- if .Values.puppetserver.compilers.service.ports.puppetserver.port -}}
{{- .Values.puppetserver.compilers.service.ports.puppetserver.port -}}
{{- else -}}
8140
{{- end -}}
{{- end -}}

{{/* Allow KubeVersion to be overridden. */}}
{{- define "puppetserver.kubeVersion" -}}
  {{- default .Capabilities.KubeVersion.Version .Values.kubeVersionOverride -}}
{{- end -}}

{{/* Get Ingress API Version */}}
{{- define "puppetserver.ingress.apiVersion" -}}
  {{- if and (.Capabilities.APIVersions.Has "networking.k8s.io/v1") (semverCompare ">= 1.19-0" (include "puppetserver.kubeVersion" .)) -}}
      {{- print "networking.k8s.io/v1" -}}
  {{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1" -}}
    {{- print "networking.k8s.io/v1beta1" -}}
  {{- else -}}
    {{- print "extensions/v1beta1" -}}
  {{- end -}}
{{- end -}}

{{/* Check Ingress stability */}}
{{- define "puppetserver.ingress.isStable" -}}
  {{- eq (include "puppetserver.ingress.apiVersion" .) "networking.k8s.io/v1" -}}
{{- end -}}

{{/* Check Ingress supports pathType */}}
{{/* pathType was added to networking.k8s.io/v1beta1 in Kubernetes 1.18 */}}
{{- define "puppetserver.ingress.supportsPathType" -}}
  {{- or (eq (include "puppetserver.ingress.isStable" .) "true") (and (eq (include "puppetserver.ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18-0" (include "puppetserver.kubeVersion" .))) -}}
{{- end -}}

{{/* Get autoscaling API Version */}}
{{- define "puppetserver.autoscaling.apiVersion" -}}
  {{- if and (semverCompare ">= 1.23-0" (include "puppetserver.kubeVersion" .)) -}}
      {{- print "autoscaling/v2" -}}
  {{- else -}}
    {{- print "autoscaling/v2beta2" -}}
  {{- end -}}
{{- end -}}

{{/*
Set's the affinity for pod placement
when running with multiple Puppet compilers.
*/}}
{{- define "puppetserver.compilers.affinity" -}}
    {{- if (or (.Values.affinity) (and (.Values.puppetserver.compilers.enabled) (.Values.puppetserver.compilers.podAntiAffinity))) }}
      affinity:
      {{- if (.Values.affinity) }}
        {{- toYaml .Values.affinity | nindent 8 }}
      {{- end }}
      {{- if (.Values.puppetserver.compilers.podAntiAffinity) }}
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchLabels:
                  {{- include "puppetserver.puppetserver-compilers.matchLabels" . | nindent 18 }}
              topologyKey: kubernetes.io/hostname
      {{- end }}
    {{- end }}
{{- end -}}

{{/*
Set's the affinity for pod placement
when running with multiple Puppet masters.
*/}}
{{- define "puppetserver.masters.affinity" -}}
    {{- if (or .Values.affinity .Values.puppetserver.masters.podAntiAffinity) }}
      affinity:
      {{- if (.Values.affinity) }}
        {{- toYaml .Values.affinity | nindent 8 }}
      {{- end }}
      {{- if (.Values.puppetserver.masters.podAntiAffinity) }}
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchLabels:
                  {{- include "puppetserver.puppetserver.matchLabels" . | nindent 18 }}
              topologyKey: kubernetes.io/hostname
      {{- end }}
    {{- end }}
{{- end -}}

{{/*
Calculates the max. number of compilers
*/}}
{{- define "puppetserver.compilers.maxNo" -}}
{{- if not (.Values.puppetserver.compilers.autoScaling.enabled) -}}
{{- .Values.puppetserver.compilers.manualScaling.compilers -}}
{{- else -}}
{{- .Values.puppetserver.compilers.autoScaling.maxCompilers -}}
{{- end -}}
{{- end -}}

{{- define "puppetserver.compilers.hostnames" -}}
  {{- $dot := . -}}
  {{- range $compilersLoopCount, $e := until ((include "puppetserver.compilers.maxNo" $dot) | int) -}}
    {{- printf "%s-puppetserver-compiler-%d" (include "puppetserver.fullname" $dot) $compilersLoopCount -}}
    {{- if lt $compilersLoopCount  ( sub ((include "puppetserver.compilers.maxNo" $dot) | int) 1 ) -}}
      {{- printf "," -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Create the name for the PuppetDB password secret.
*/}}
{{- define "puppetdb.secret" -}}
{{- if .Values.global.postgresql.auth.existingSecret -}}
  {{- .Values.global.postgresql.auth.existingSecret -}}
{{- else -}}
  {{ template "puppetdb.fullname" . }}-postgresql
{{- end -}}
{{- end -}}

{{/*
Create the name for the PuppetDB Persistent Volume Claim.
*/}}
{{- define "puppetdb.persistence.claimName" -}}
{{- if .Values.puppetdb.persistence.existingClaim -}}
  {{- .Values.puppetdb.persistence.existingClaim -}}
{{- else -}}
  {{ template "puppetdb.fullname" . }}-claim
{{- end -}}
{{- end -}}

{{/*
Create the annotations for the PuppetDB Persistent Volume Claim.
*/}}
{{- define "puppetdb.persistence.annotations" -}}
{{- if .Values.puppetdb.persistence.annotations -}}
  {{- .Values.puppetdb.persistence.annotations | toYaml -}}
{{- else -}}
  {{- if .Values.storage.annotations -}}
    {{- .Values.storage.annotations | toYaml -}}
  {{- end }}
{{- end -}}
{{- end -}}

{{/*
Create the storageClassName for the PuppetDB Persistent Volume Claim.
*/}}
{{- define "puppetdb.persistence.storageClass" -}}
{{- if .Values.puppetdb.persistence.storageClass -}}
  {{- .Values.puppetdb.persistence.storageClass -}}
{{- else -}}
  {{- .Values.storage.storageClass -}}
{{- end -}}
{{- end -}}

{{/*
Create the name for the r10k.code.viaSsh secret.
*/}}
{{- define "r10k.code.viaSsh.secret" -}}
{{- if .Values.r10k.code.viaSsh.credentials.existingSecret -}}
  {{- .Values.r10k.code.viaSsh.credentials.existingSecret -}}
{{- else -}}
  {{ template "puppetserver.fullname" . }}-r10k-code-creds
{{- end -}}
{{- end -}}

{{/*
Create the name for the r10k.code.viaHttps secret.
*/}}
{{- define "r10k.code.viaHttps.secret" -}}
{{- if .Values.r10k.code.viaHttps.credentials.existingSecret -}}
  {{- .Values.r10k.code.viaHttps.credentials.existingSecret -}}
{{- else -}}
  {{ template "puppetserver.fullname" . }}-r10k-code-creds
{{- end -}}
{{- end -}}

{{/*
Create the name for the r10k.code.viaHttps.customCa secret.
 Defaults to "r10k.code.viaHttps.secret"
*/}}
{{- define "r10k.code.viaHttps.customCa.secret" -}}
{{- if .Values.r10k.code.viaHttps.customCa.existingSecret -}}
  {{- .Values.r10k.code.viaHttps.customCa.existingSecret -}}
{{- else -}}
  {{ template "r10k.code.viaHttps.secret" . }}
{{- end -}}
{{- end -}}

{{/*
Create the name for the r10k.hiera.viaSsh secret.
*/}}
{{- define "r10k.hiera.viaSsh.secret" -}}
{{- if .Values.r10k.hiera.viaSsh.credentials.existingSecret -}}
  {{- .Values.r10k.hiera.viaSsh.credentials.existingSecret -}}
{{- else -}}
  {{ template "puppetserver.fullname" . }}-r10k-hiera-creds
{{- end -}}
{{- end -}}

{{/*
Create the name for the r10k.hiera.viaHttps secret.
*/}}
{{- define "r10k.hiera.viaHttps.secret" -}}
{{- if .Values.r10k.hiera.viaHttps.credentials.existingSecret -}}
  {{- .Values.r10k.hiera.viaHttps.credentials.existingSecret -}}
{{- else -}}
  {{ template "puppetserver.fullname" . }}-r10k-hiera-creds
{{- end -}}
{{- end -}}

{{/*
check if hiera is define
*/}}
{{- define "hiera.enable" -}}
{{- if or .Values.hiera.hieradataurl .Values.r10k.hiera.extraRepository }}
  {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Create the name for the hiera eyaml private key Secrets.
*/}}
{{- define "puppetserver.hiera.privateSecret" -}}
  {{ template "puppetserver.fullname" . }}-eyamlpriv-secret
{{- end -}}

{{/*
Create the name for the hiera eyaml public cert Secrets.
*/}}
{{- define "puppetserver.hiera.publicSecret" -}}
  {{ template "puppetserver.fullname" . }}-eyamlpub-secret
{{- end -}}

{{/*
Return the appropriate apiVersion for podsecuritypolicy.
*/}}
{{- define "podsecuritypolicy.apiVersion" -}}
{{- if semverCompare "<1.10-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "policy/v1beta1" -}}
{{- end -}}
{{- end -}}

{{/*
Define puppetserver service Account name
*/}}
{{- define "puppetserver.serviceAccountName" -}}
{{ default ( include "puppetserver.fullname" . ) .Values.puppetserver.serviceAccount.accountName }}
{{- end -}}




{{/*
Define puppetserver alternate SAN
*/}}
{{- define "puppetserver.master.san" -}}
{{- $san := printf "puppet,%s,%s" ( include "puppetserver.puppetserver.agents-to-masters.serviceName" . ) ( include "puppetserver.puppetserver-masters.serviceName" . ) -}}
{{- if and .Values.puppetserver.compilers.enabled (not .Values.singleCA.enabled) -}}
{{- $san = print $san "," ( include "puppetserver.puppetserver-compilers.serviceName" . ) -}}
{{- end -}}
{{- if .Values.puppetserver.masters.fqdns.alternateServerNames -}}
{{- $san = print $san "," .Values.puppetserver.masters.fqdns.alternateServerNames -}}
{{- end -}}
{{- if .Values.puppetserver.compilers.fqdns.alternateServerNames -}}
{{- $san = print $san "," .Values.puppetserver.compilers.fqdns.alternateServerNames -}}
{{- end -}}
{{- printf "%s" $san -}}
{{- end -}}

{{/*
Create a default puppetdb fully qualified app name.
We truncate at 52 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "puppetdb.fullname" -}}
{{ template "puppetserver.fullname" . }}-puppetdb
{{- end -}}

{{/*
Define puppetdb alternate SAN
*/}}
{{- define "puppetdb.san" -}}
{{- $san := printf "puppetdb,%s" ( include "puppetdb.fullname" . ) -}}
{{- if .Values.puppetdb.fqdns.alternateServerNames -}}
{{- $san = print $san "," .Values.puppetdb.fqdns.alternateServerNames -}}
{{- end -}}
{{- printf "%s" $san -}}
{{- end -}}

{{/*
Define puppetdb service Account name
*/}}
{{- define "puppetdb.serviceAccountName" -}}
{{ default ( include "puppetdb.fullname" . ) .Values.puppetdb.serviceAccount.accountName }}
{{- end -}}

{{/*
Return PostgreSQL host name
*/}}
{{- define "postgresql.hostname" -}}
{{- if .Values.postgresql.enabled }}
{{- if eq .Values.postgresql.architecture "standalone" -}}
{{- printf "%s-%s" .Release.Name "postgresql-hl" | trimSuffix "-" -}}
{{- else }}
{{- printf "%s-%s" .Release.Name "postgresql-primary-hl" | trimSuffix "-" -}}
{{- end -}}
{{- else if .Values.puppetdb.extraEnv.PUPPETDB_POSTGRES_HOSTNAME }}
{{- printf "%s" .Values.puppetdb.extraEnv.PUPPETDB_POSTGRES_HOSTNAME -}}
{{- end -}}
{{- end -}}

{{/*
Return puppetserver certificate name without extension
*/}}
{{- define "singleCA.puppetserver.certname" -}}
{{- if .Values.singleCA.enabled }}
{{- printf "%s" .Values.singleCA.certificates.secretKeys.puppetCert | trimSuffix ".pem" -}}
{{- end -}}
{{- end -}}

{{/*
Return puppetdb certificate name without extension
*/}}
{{- define "singleCA.puppetdb.certname" -}}
{{- if .Values.singleCA.enabled }}
{{- printf "%s" .Values.singleCA.certificates.secretKeys.puppetdbCert | trimSuffix ".pem" -}}

{{- end -}}
{{- end -}}

{{/* *************************************************************************************
The following definitions were more complex and necessary during part of this development.
Now they are essentially just stubs but left here in case they might be needed again soon.
************************************************************************************* */}}

{{/*
Create the name for the hiera eyaml key configMap (private/public keys combined).
*/}}
{{- define "puppetserver.hiera.existingMap" -}}
{{- if .Values.hiera.eyaml.existingMap -}}
  {{- .Values.hiera.eyaml.existingMap -}}
{{- end -}}
{{- end -}}

{{/*
Create the name for the hiera eyaml key secret (private/public keys combined).
*/}}
{{- define "puppetserver.hiera.existingSecret" -}}
{{- if .Values.hiera.eyaml.existingSecret -}}
  {{- .Values.hiera.eyaml.existingSecret -}}
{{- end -}}
{{- end -}}
