# 채용공고 서버 필터 버그 리포트

작성일: 2026-06-23

## 요약

듀잇 채용공고 API의 `workRegions`, `employmentTypes` 필터가 라이브 데이터와 서버 필터 조건의 문자열 형식 불일치로 실제 공고를 반환하지 않는다.

클라이언트는 임시 대응으로 두 필터를 서버에 전달하지 않고, 내려받은 고용24 원문 필드를 로컬에서 파싱해 필터링한다.

## 재현 환경

- 듀잇 API: `https://api.dutyit.net/api/v1/job-postings`
- 듀잇 Swagger: `https://api.dutyit.net/swagger-ui/index.html`
- 서버 소스: `klaus9267/duit_server` `main` `2ff35ea`
- 기준 시각: 2026-06-23 KST

## 재현 절차

### 지역 필터

1. 필터 없이 최신 채용공고를 조회한다.
   - `GET /api/v1/job-postings?bookmarked=false&size=5&field=CREATED_AT`
2. 응답에 서울 공고가 포함되는지 확인한다.
   - 예: `workRegion: "(07516)  서울특별시 강서구 양천로 31, ..."`
3. 같은 조건에 `workRegions=SEOUL`을 추가한다.
   - `GET /api/v1/job-postings?bookmarked=false&size=5&field=CREATED_AT&workRegions=SEOUL`

### 고용형태 필터

1. 필터 없이 최신 채용공고를 조회한다.
2. 응답에 정규직/계약직 원문이 포함되는지 확인한다.
   - 정규직성 데이터 예: `기간의 정함이 없는 근로계약/ 파견근로 비희망/...`
   - 계약직성 데이터 예: `기간의 정함이 있는 근로계약12 개월/...`
3. 같은 조건에 `employmentTypes=FULL_TIME` 또는 `employmentTypes=CONTRACT`를 추가한다.

## 실제 결과

- `workRegions=SEOUL` 응답:
  - HTTP 200
  - `content: []`
  - `pageInfo.pageSize: 0`
- `employmentTypes=FULL_TIME` 응답:
  - HTTP 200
  - `content: []`
  - `pageInfo.pageSize: 0`
- `employmentTypes=CONTRACT` 응답:
  - HTTP 200
  - `content: []`
  - `pageInfo.pageSize: 0`

## 기대 결과

- `workRegions=SEOUL`은 서울특별시 주소의 채용공고를 반환해야 한다.
- `employmentTypes=FULL_TIME`은 고용24 코드 `10`, `11` 또는 원문 `기간의 정함이 없는 근로계약`에 해당하는 채용공고를 반환해야 한다.
- `employmentTypes=CONTRACT`는 고용24 코드 `20`, `21` 또는 원문 `기간의 정함이 있는 근로계약`에 해당하는 채용공고를 반환해야 한다.

## 원인 분석

서버 필터 구현은 원문 저장 필드에 enum 표시명을 문자열 검색한다.

- `JobPostingRepositoryImpl`
  - 지역: `jobPosting.workRegion.startsWith(it.displayName)`
  - 고용형태: `jobPosting.empTpNm.containsIgnoreCase(it.displayName)`
- `WorkRegion`
  - `SEOUL("서울")`, `GYEONGBUK("경북")` 등
- `EmploymentType`
  - `FULL_TIME("정규직")`, `CONTRACT("계약직")` 등

그러나 라이브 저장/응답 데이터는 고용24 원문 형식이다.

- 지역:
  - `(07516) 서울특별시 ...`
  - `(37560) 경상북도 ...`
  - 우편번호 괄호 또는 5자리 우편번호로 시작하므로 `startsWith("서울")`, `startsWith("경북")`가 실패한다.
- 고용형태:
  - `기간의 정함이 없는 근로계약/...`
  - `기간의 정함이 있는 근로계약12 개월/...`
  - `정규직`, `계약직` 문자열이 포함되지 않아 `containsIgnoreCase("정규직")`, `containsIgnoreCase("계약직")`가 실패한다.

서버에는 `Work24CodeMapper.mapWorkRegion`, `Work24CodeMapper.mapEmploymentType`가 있지만 현재 조회 필터는 정규화된 enum/코드 컬럼을 사용하지 않고 원문 문자열 필드를 직접 검색한다.

## 영향 범위

- 앱의 채용 검색 필터에서 지역을 선택하면 결과가 비거나 매우 부족하게 보인다.
- 앱의 채용 검색 필터에서 정규직/계약직을 선택하면 결과가 비어 보인다.
- Swagger/API 소비자도 동일하게 필터 파라미터 사용 시 실제 데이터와 다른 빈 결과를 받는다.

## 서버 수정 제안

1. 수집 시 정규화된 필터 전용 컬럼을 저장한다.
   - 지역: `workRegionType` 또는 기존 의도대로 enum 컬럼
   - 고용형태: `employmentType`
2. 조회 조건은 원문 문자열이 아니라 정규화 컬럼 또는 고용24 코드 컬럼을 사용한다.
   - 지역: `regionCd` 앞 2자리 또는 정규화 enum
   - 고용형태: `empTpCd` (`10`, `11` = FULL_TIME, `20`, `21` = CONTRACT, `4` = DISPATCH)
3. 기존 데이터 마이그레이션/백필을 수행한다.
4. 회귀 테스트를 추가한다.
   - `(07516) 서울특별시...` + `workRegions=SEOUL`
   - `(37560) 경상북도...` + `workRegions=GYEONGBUK`
   - `기간의 정함이 없는 근로계약...` + `employmentTypes=FULL_TIME`
   - `기간의 정함이 있는 근로계약...` + `employmentTypes=CONTRACT`

## 클라이언트 임시 대응

- 서버 지역/고용형태 필터 파라미터 전송을 중단한다.
- `JobFilterMatcher`에서 고용24 원문 주소와 고용형태 문구를 파싱해 로컬 필터링한다.
- 서버 필터가 정규화 컬럼 기반으로 수정되면 클라이언트의 임시 우회 로직은 서버 필터 재사용 여부를 다시 검토할 수 있다.
