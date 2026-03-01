{{/*
Fork of t3n/helm-charts external-service. Multi-service support.
Call with (dict "root" $ "service" $svc) so .root.Release and .service are available.
*/}}
{{- define "external-services.fullname" -}}
{{- $ctx := . -}}
{{- if $ctx.service.fullnameOverride -}}
{{- $ctx.service.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default $ctx.service.name $ctx.service.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- printf "%s-%s" $ctx.root.Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "external-services.labels" -}}
{{- $ctx := . -}}
app.kubernetes.io/name: external-services
app.kubernetes.io/instance: {{ $ctx.root.Release.Name }}
app.kubernetes.io/managed-by: {{ $ctx.root.Release.Service }}
app.kubernetes.io/component: {{ $ctx.service.name | quote }}
{{- end -}}
