{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "nlweb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nlweb.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Build the name of the secrets-key secret.
*/}}
{{- define "nlweb.secrets.key.name" -}}
{{- printf "%s-%s" (include "nlweb.fullname" .) "key-secret" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nlweb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "nlweb.labels" -}}
helm.sh/chart: {{ include "nlweb.chart" . }}
{{ include "nlweb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "nlweb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nlweb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ .Release.Name }}
{{- end -}}

{{/*
Frontend Selector labels
*/}}
{{- define "nlweb.frontend.selectorLabels" -}}
{{ include "nlweb.selectorLabels" . }}
app.kubernetes.io/component: frontend
{{- end -}}

{{/*
Backend Selector labels
*/}}
{{- define "nlweb.backend.selectorLabels" -}}
{{ include "nlweb.selectorLabels" . }}
app.kubernetes.io/component: backend
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "nlweb.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "nlweb.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
MongoDB host
*/}}
{{- define "nlweb.mongodb.host" -}}
{{- if .Values.mongodb.enabled -}}
    {{ template "mongodb.serviceName" . }}.{{ .Release.Namespace }}.svc.{{ .Values.mongodb.clusterDomain }}
{{- else -}}
    {{ .Values.neoload.configuration.backend.mongo.host }}
{{- end -}}
{{- end -}}

{{/*
Helper - stringToStrings
*/}}
{{- define "nlweb.helpers.stringToStrings" -}}

    {{ $array := regexSplit "\\." . -1 }}
    {{- range $array }}
        "{{ . }}" 
    {{ end -}}

{{- end -}}

{{/*
Helper - getScheme
*/}}
{{- define "nlweb.helpers.getScheme" -}}
    http
    {{- if or (and .Values.ingress.enabled .Values.ingress.tls) (eq (.Values.neoload.configuration.externalTlsTermination | toString) "true") -}}
        s
    {{- end -}}
    ://
{{- end -}}

{{/*
Helper - minLength (name, min, context)
*/}}
{{- define "nlweb.helpers.minLength" -}}

    {{ $name := index . "name" }}
    {{ $min := int (index . "min") }}
    {{ $context := index . "context" }}

    {{ $indexableName := (include "nlweb.helpers.stringToStrings" $name) }}

    {{ $val := default "" (index $context $indexableName) }}
    {{ $length := len $val }}

    {{- if ge $length $min -}}
        {{ $val }}
    {{- else -}}
        {{- if eq $length 0 -}}
            {{ "" | required (printf "The value %s is required" $name) }}
        {{- else -}}
            {{ "" | required (printf "The value %s should be at least %d character(s)" $name $min) }}
        {{- end -}}
    {{- end -}}

{{- end -}}

{{/*
Get frontend image tag
*/}}
{{- define "nlweb.frontend.imageTag" -}}
    {{ default .Chart.AppVersion .Values.image.frontend.tag }}
{{- end -}}

{{/*
Get backend image tag
*/}}
{{- define "nlweb.backend.imageTag" -}}
    {{ default .Chart.AppVersion .Values.image.backend.tag }}
{{- end -}}

{{/*
High Availability (HA) Mode
*/}}
{{- define "nlweb.ha.mode" -}}
    {{- $availableHaModes := list "API" "DNS" -}}
    {{- $haMode := default "API" .Values.neoload.configuration.ha.mode -}}
    {{- if (has $haMode $availableHaModes) -}}
        {{ $haMode }}
    {{- else -}}
        {{- $error := printf "The HA mode must be API or DNS. Got : %s" $haMode -}}
        {{ required $error "" }}
    {{- end -}}
{{- end -}}

{{- define "nlweb.service-hazelcast-name" -}}
    {{ include "nlweb.fullname" . }}-svc-hazelcast-{{ include "nlweb.ha.mode" . | lower }}
{{- end -}}