{{/*
Expand the name of the chart.
*/}}
{{- define "tor-snowflake-proxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tor-snowflake-proxy.fullname" -}}
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
{{- define "tor-snowflake-proxy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tor-snowflake-proxy.labels" -}}
helm.sh/chart: {{ include "tor-snowflake-proxy.chart" . }}
{{ include "tor-snowflake-proxy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tor-snowflake-proxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tor-snowflake-proxy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "tor-snowflake-proxy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tor-snowflake-proxy.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Build the args list for the tor-snowflake-proxy container
*/}}
{{- define "tor-snowflake-proxy.args" -}}
{{- $args := list }}
{{- if .Values.snowflake.brokerURL }}
{{- $args = append $args "-broker" }}
{{- $args = append $args .Values.snowflake.brokerURL }}
{{- end }}
{{- if .Values.snowflake.relayURL }}
{{- $args = append $args "-relay" }}
{{- $args = append $args .Values.snowflake.relayURL }}
{{- end }}
{{- if .Values.snowflake.stunServers }}
{{- $args = append $args "-stun" }}
{{- $args = append $args (join "," .Values.snowflake.stunServers) }}
{{- end }}
{{- if .Values.snowflake.ephemeralPortsRange }}
{{- $args = append $args "-ephemeral-ports-range" }}
{{- $args = append $args .Values.snowflake.ephemeralPortsRange }}
{{- end }}
{{- if .Values.snowflake.verbose }}
{{- $args = append $args "-verbose" }}
{{- end }}
{{- if .Values.snowflake.keepLocalAddresses }}
{{- $args = append $args "-keep-local-addresses" }}
{{- end }}
{{- if .Values.snowflake.unsafeLogging }}
{{- $args = append $args "-unsafe-logging" }}
{{- end }}
{{- if .Values.snowflake.capacity }}
{{- $args = append $args "-capacity" }}
{{- $args = append $args (printf "%d" (int .Values.snowflake.capacity)) }}
{{- end }}
{{- if .Values.snowflake.summaryInterval }}
{{- $args = append $args "-summary-interval" }}
{{- $args = append $args (printf "%ds" (int .Values.snowflake.summaryInterval)) }}
{{- end }}
{{- range .Values.extraArgs }}
{{- $args = append $args . }}
{{- end }}
{{- toJson $args }}
{{- end }}
