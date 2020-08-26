# cms-grafana-jsonnet

Generate configMap for [cms-grafana-builder](https://github.com/sunny0826/cms-grafana-builder)


```text
$ cms -h
cms grafana jsonnet tool

Usage:
  cgt [command]

Available Commands:
  help        Help about any command
  run         generate json to configmap

Flags:
  -h, --help   help for cgt
$ cms run -h
generate json to configmap

Usage:
  cgt run [flags]

Flags:
  -c, --configmap string   name of configmap (default "cms-model")
  -d, --dashboard string   list of dashboard name
  -h, --help               help for run
  -l, --libs string        libs of jsonnet (default "libs")
  -n, --namespace string   namespace of configmap (default "monitor")

```