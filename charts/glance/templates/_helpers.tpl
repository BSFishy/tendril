{{/* Returns the chart name */}}
{{- define "glance.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Returns the full name */}}
{{- define "glance.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "glance.name" .) | trunc 63 | trimSuffix "-" }}
{{- end -}}
{{- end -}}
