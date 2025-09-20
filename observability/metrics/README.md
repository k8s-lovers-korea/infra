# kustomize 기반 배포 

``` bash 
cd infra/observability/metrics 
kustomize build . --enable-helm > temp.yaml 
```  
kustomization.yaml내 선언된 helmCharts 하위 항목을 기준으로 k8s manifest file 생성 
repo/name 을 기본 chart로 하며, valuesFile으로 설정을 덮어쓰는 형태 
