````markdown
# Loki 스택 로그 모니터링 예시

이 파일은 `observability` 네임스페이스에서 Loki 스택(Loki + Promtail + Grafana)을 사용하여 로그를 조회할 수 있는 LogQL 예시를 제공합니다.

---

## 1. Promtail 로그 모니터링

Promtail 파드에서 성공, 시작, 파일 감시 관련 로그를 필터링합니다.

```
{namespace="observability", pod=~"cloudgoose-promtail.*"} 
|~ "(?i)success|started|watching|added"
```

* **설명**: Promtail이 정상적으로 로그를 수집하고 있는지 확인
* **사용 예시**:
  - Pod마다 로그가 정상적으로 tail 되고 있는지 확인
  - 새로운 디렉토리 또는 파일 감시 시작 여부 확인

---

## 2. Grafana 에러 로그 확인

Grafana 파드에서 오류, 실패, 예외, 경고 로그를 필터링합니다.

```
{namespace="observability", pod=~"cloudgoose-grafana.*"} 
|~ "(?i)error|failed|exception|warning"
```

* **설명**: Grafana의 데이터 소스 및 기타 서비스에서 발생하는 문제를 확인
* **사용 예시**:
  - Grafana가 datasource를 로드하지 못할 때
  - 경고나 예외 발생 모니터링

---

## 3. Loki 내부 로그 확인

Loki 파드의 info, warning, error 로그를 확인합니다.

```
{namespace="observability", pod="cloudgoose-loki-0"} 
|~ "(?i)level=info|level=warn|level=error"
```

* **설명**: Loki 자체의 상태 및 경고 메시지 확인
* **사용 예시**:
  - Loki에서 로그 수집, 인덱싱, 쿼리 요청 처리 상태 확인
  - warning이나 error 발생 시 문제 조사

---

## 참고 사항

* `|~` 는 정규식 기반 필터링입니다.
* `(?i)` 는 대소문자 구분 없이 검색하도록 하는 옵션입니다.
* 필요에 따라 pod 라벨을 구체적인 파드 이름으로 변경할 수 있음.

---

### 예시 사용 방법

1. Grafana → Explore 메뉴 이동
2. Data source 선택 → Loki
3. LogQL 쿼리 입력란에 위 예시 쿼리 복사
4. 실행 → 로그 확인

```

