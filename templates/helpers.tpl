{{- define "sizeInBytes" -}}
{{- $val := regexFind "[0-9.]+" . -}}
{{- $unit := regexFind "[a-zA-Z]+" . | lower -}}
{{- $bytes := 0 -}}
{{- if eq $unit "ki" -}}
  {{- $bytes = mul $val 1024 -}}
{{- else if eq $unit "mi" -}}
  {{- $bytes = mul $val 1024 1024 -}}
{{- else if eq $unit "gi" -}}
  {{- $bytes = mul $val 1024 1024 1024 -}}
{{- else if eq $unit "ti" -}}
  {{- $bytes = mul $val 1024 1024 1024 1024 -}}
{{- else -}}
  {{- $bytes = $val -}}
{{- end -}}
{{- printf "%d" $bytes -}}
{{- end }}
