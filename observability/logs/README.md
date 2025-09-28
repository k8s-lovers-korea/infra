# loki 배포

loki single binary로 배포

최신 loki helm chart의 경우 grafana에서 [test와 관련된 spec을 enable](https://github.com/grafana/loki/blob/main/production/helm/loki/values.yaml)해놔서 뭔가 이상한듯...

official chart values를 참고해서 일단 single binary로 배포.

문서에는 없지만 auth_enabled 이 default가 true인데, auth 정보를 찾기 어려워서 일단 false로 진행


```bash
helm install loki grafana/loki -f values.yaml -n observability
```