{{/* Define the name of the release */}}
{{- define "nginx.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{/* Define the full name, including release name */}}
{{- define "nginx.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
