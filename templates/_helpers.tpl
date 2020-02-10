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
    {{- if .Values.ingress.enabled -}}
    {{- if .Values.ingress.tls -}}
        s
    {{- end -}}
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

