# cms-grafana-jsonnet

Grafana Template of [cms-grafana-builder](https://github.com/sunny0826/cms-grafana-builder)

```shell
# generate dashboard.json 
jsonnet -J grafonnet-lib dashboard.jsonnet > dashboard.json
# generate ecs.json
jsonnet -J grafonnet-lib ecs.jsonnet > ecs.json
# generate rds.json
jsonnet -J grafonnet-lib rds.jsonnet > rds.json
# generate eip.json
jsonnet -J grafonnet-lib eip.jsonnet > eip.json
```