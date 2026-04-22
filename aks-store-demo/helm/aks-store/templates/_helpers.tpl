{{/*
Expand the name of the chart.
*/}}
{{- define "aks-store.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "aks-store.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "aks-store.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "aks-store.labels" -}}
app.kubernetes.io/name: {{ include "aks-store.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: {{ .Values.global.environment }}
{{- end -}}

{{/*
Common labels for all components
*/}}
{{- define "aks-store.commonLabels" -}}
{{ include "aks-store.labels" . }}
{{- end -}}

{{/*
Image full path
*/}}
{{- define "aks-store.image" -}}
{{- printf "%s/%s:%s" .Values.global.imageRegistry .Values.storeFront.image.repository .Values.storeFront.image.tag -}}
{{- end -}}