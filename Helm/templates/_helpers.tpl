{{/*
Return the full name of the chart release (e.g., java-health-check-app)
*/}}
{{- define "java-health-check-app.fullname" -}}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end }}

{{/*
Return just the chart name
*/}}
{{- define "java-health-check-app.name" -}}
{{ .Chart.Name }}
{{- end }}