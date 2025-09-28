# kustomize 기반 배포 

``` bash 
cd infra/observability/metrics 
kustomize build . --enable-helm > temp.yaml 
```  
kustomization.yaml내 선언된 helmCharts 하위 항목을 기준으로 k8s manifest file 생성 
repo/name 을 기본 chart로 하며, valuesFile으로 설정을 덮어쓰는 형태 


---

## helm chart기반 배포

prometheus-stack helm chart의 경우 operator 설치 & crd 기준 배포 컨셉으로 kustomization으로 설치했을 때 crd가 없어 fail

helm chart로 배포 시 성공

```bash
helm install prom prometheus-community/kube-prometheus-stack -f values.yaml -n observability
```