# Tempo - 분산 트레이싱 백엔드

## 📌 개요
Grafana Tempo를 사용한 분산 트레이싱 시스템 구축  
OpenTelemetry Collector에서 수집된 트레이스 데이터를 저장하고 쿼리할 수 있는 백엔드 서비스

## 🚀 Kustomize 기반 배포

### 📁 필요한 파일들
- `kustomization.yaml` - Helm 차트 정의 및 네임스페이스 설정
- `values.yaml` - Tempo 커스텀 설정 (Helm 차트 기본값 오버라이드)

### 1. Manifest 생성
```bash
cd infra/observability/tracing/tempo
kustomize build . --enable-helm > tempo-manifest.yaml
```
> **참고**: `tempo-manifest.yaml` 파일이 미리 존재하지 않아도 됩니다. Kustomize가 Helm 차트와 `values.yaml`을 기반으로 자동 생성합니다.

### 2. 배포 실행
```bash
kubectl apply -f tempo-manifest.yaml
```

### 또는 직접 배포 (manifest 파일 생성 없이)
```bash
cd infra/observability/tracing/tempo
kustomize build . --enable-helm | kubectl apply -f -
```

### 3. 배포 확인
```bash
# Tempo 파드 상태 확인
kubectl get pods -n observability | grep tempo

# Tempo 서비스 확인
kubectl get svc -n observability | grep tempo

# Tempo 로그 확인
kubectl logs -n observability deployment/cloudgoose-tempo
```

## 📋 구성 요소
- **Chart**: `tempo` (Grafana 공식 Helm 차트)
- **Release Name**: `cloudgoose-tempo`
- **Namespace**: `observability`
- **Repository**: `https://grafana.github.io/helm-charts`
- **Version**: `1.10.1`

### 생성되는 Kubernetes 리소스
- **StatefulSet**: Tempo 파드 관리
- **Service**: `cloudgoose-tempo` 서비스 (ClusterIP)
- **ConfigMap**: Tempo 설정 파일
- **ServiceAccount**: 권한 관리

## 🔗 연동 정보
- **OpenTelemetry Collector**: `cloudgoose-tempo.observability:4317` (OTLP gRPC)
- **Grafana 데이터소스**: `http://cloudgoose-tempo.observability:3200`

## 🔧 작동 원리
1. **Kustomize**가 `kustomization.yaml`에서 Helm 차트 정보를 읽음
2. **Grafana Helm 저장소**에서 `tempo` 차트 (v1.10.1) 다운로드
3. **`values.yaml`**의 커스텀 설정으로 기본값 오버라이드
4. **최종 Kubernetes manifest** 생성 및 `observability` 네임스페이스에 배포

> **💡 팁**: `values.yaml` 파일만 수정하면 Tempo의 모든 설정을 커스터마이징할 수 있습니다. 
