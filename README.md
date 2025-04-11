# 메더빽 (Medaebbaek)

**메더빽**은 메가커피(Mega Coffee), 더벤티(The Venti), 빽다방(Paik's Coffee) 세 커피 브랜드의 특징을 통합하여 만든 **통합 키오스크 앱**입니다.  
사용자가 각 브랜드의 다양한 음료와 디저트를 편리하게 주문할 수 있도록 구성된 올인원 키오스크 시스템입니다.

## 🗓 프로젝트 기간

2025년 4월 7일 ~ 2025년 4월 11일 (총 5일간 진행)

## 🎯 프로젝트 목표

- 사용자가 직관적으로 이용할 수 있는 키오스크 UI 제공
- 실제 매장에서 사용할 수 있을 정도로 기능을 갖춘 주문 흐름 구현
- UIKit과 SnapKit을 활용한 커스텀 UI
- MVVM + Delegate 구조 기반 아키텍처 설계

## 📱 주요 기능

| 기능 구분 | 설명 |
|----------|------|
| 메인 화면 | 브랜드 선택 및 카테고리 진입 |
| 상품 리스트 | 브랜드별 음료/디저트/티켓 등을 목록으로 보여줌 |
| 상품 상세 | 상품 이미지, 설명, 장바구니 담기 기능 |
| 장바구니 | 수량 조절, 총 가격 확인, 주문/취소 기능 |
| 키오스크 UI | 사용자 중심의 버튼 구성, 큰 폰트와 명확한 정보 전달 |
| 다크모드 대응 | 시스템 테마에 따라 자동 전환 (선택 가능) |

## ✅ 구현 기능 체크리스트

- [x] **브랜드 이동 버튼**
  - [x] 브랜드 이동 이벤트 (배경화면, 글자색, 버튼색, 브랜드 이미지 변경)
  - [x] 브랜드 변경 시 해당 브랜드 상품 표시

- [x] **상단 메뉴 카테고리 바**
  - [x] 브랜드마다 카테고리 셀 배경색 구분
  - [x] 브랜드 변경 시 자동으로 첫 번째 셀 선택
  - [x] 카테고리 선택 시 해당 상품 표시
  - [x] 카테고리 가로 스크롤 지원

- [x] **상품 리스트 화면**
  - [x] 상품 터치 시 장바구니에 추가
  - [x] 상품 리스트 페이징 처리
  - [x] 상품 리스트 가로 스크롤

- [x] **장바구니 화면**
  - [x] 주문취소 / 주문하기 버튼 구현
  - [x] 장바구니 내 총 금액 표시
  - [x] 삭제 버튼, 수량 증감 버튼 구현
  - [x] 주문 취소 / 확인 시 Alert 처리

- [x] **네트워크 작업**
  - [x] GitHub Repo에 저장된 이미지 URL 로드
  - [x] 이미지 URL → UIImage 로 비동기 로딩

- [x] **메뉴 노출 디테일**
  - [x] 메뉴 40개 이상 표시
  - [x] 일부 메뉴를 추천 메뉴로 지정하여 별도 필터 제공


## 📝 와이어 프레임
[와이어 프레임 Figma]([https://github.com/sheep1sik](https://www.figma.com/design/3reNwWId0LUP5qATU26P6V/%ED%82%A4%EC%98%A4%EC%8A%A4%ED%81%AC?node-id=0-1&t=wFAL96i2NgHtHyw5-1))

![image](https://github.com/user-attachments/assets/bcba3510-00a1-4136-9581-cdd626a8a131)

## 🧩 기술 스택

- **언어:** Swift
- **프레임워크:** UIKit
- **레이아웃:** SnapKit
- **디자인 패턴:** MVVM, Delegate Pattern
- **버전 관리:** Git / GitHub

## 📸 주요 화면

- 브랜드 선택 화면

https://github.com/user-attachments/assets/f2513585-0506-4414-8dea-36bcabea013d

- 상품 선택 화면 (카페 메뉴 선택)

https://github.com/user-attachments/assets/8e2b7f91-16e7-400a-9391-7febafc8f085

- 장바구니 화면

https://github.com/user-attachments/assets/e1136264-816e-406f-9e7c-e73d88a015d5

- 주문 완료/취소 플로우
  - 주문 완료

https://github.com/user-attachments/assets/290f9334-3ece-45d6-8965-3b8e690f35f3

  - 주문 취소

https://github.com/user-attachments/assets/4f49035a-cfe4-4156-aea5-a924bdf28326


## 📋 요구사항 기반

- 여러 브랜드의 통합 화면 구현
- 각 브랜드별 상품 및 카테고리 구현
- 장바구니 시스템
- 수량 조절, 가격 계산 등 상세 로직 처리
- UIKit 기반의 키오스크 스타일 구성

## 🔎 협업 규칙

- 식사 - 점심(12:00 ~ 13:00), 저녁(18:00 ~ 19:00)
- 외출 시 구두로 전파하고, ZEP 상태변경
- 데일리 스크럼 오전(10:00 ~ 10:30), 오후(17:30 ~ 18:00)
- PR후 팀원에게 알리고, 코드리뷰 후 approve 꼭 해주기
- PR에서 reviewer, assignees 꼭 등록하기
- PR이나 Issue templates,labels  적극 활용하기
- 인사이트 공유는 과제와 연관된 트러블 슈팅이나 새롭게 알게 된 내용을 공유하기
- 주석을 활용하여 코드 가독성 높이기

## ✏️ 코딩 컨벤션

https://github.com/StyleShare/swift-style-guide

## 📍커밋 컨벤션

### 커밋 태그
feat: 새로운 기능 추가
fix: 버그 수정
comment: 주석 추가
chore: 빌드 업무 수정, 패키지 매니저 수정
refactor: 코드 리팩토링
docs: 문서 수정
ci: CI 관련 설정 수정에 대한 커밋
style: 코드 포맷팅, 세미콜론 누락, 코드 변경이 없는 경우, 키워드 변경
build: 빌드 관련 파일 수정, 패키지 매니저 수정
test: 테스트 코드 수정, 리팩토리 테스트 코드 추가
rename: 파일 혹은 폴더명을 수정하거나 옮기는 작업만 한 경우  
remove: 파일을 삭제하는 작업만 수행한 경우  

### 이슈 태그
feat: 기능 명세서
bug: 트러블 슈팅
Labels 추가

## 💡브랜치 룰 & 전략

- `main` : 서비스를 직접 배포하는 역할
- `dev` : feat 브랜치로부터 merge된 브랜치(main으로 merge하기 전 가장 최신의 릴리즈 버전)
- `feat` : 기능 개발 ex) feat/#1
- `fix` : main브랜치로 배포 하고 난 이후, 버그가 생겼을때 고치기 위한 브랜치 ex) fix/#2

## 🚀 실행 방법

1. 이 프로젝트를 클론합니다:
    ```bash
    git clone https://github.com/your-team/medaebbaek-kiosk.git
    ```

2. Xcode에서 `KioskApp.xcodeproj` 열기

3. 시뮬레이터에서 실행 or 실제 디바이스에서 테스트
[ 제한사항 ]
시간 당 10회 데이터 불러오는 제한이 있습니다.  

## 🤝 팀원 소개

| 이름 | 역할 | GitHub |
|------|------|--------|
| [이민재](깃허브 링크) | 역할 | @깃사용자이름 ||
| [양원식](https://github.com/sheep1sik) | 주문 목록 UI 및 기능 구현, ViewModel 구성 | @sheep1sik |
| [박주성](깃허브 링크) | 상품 목록 UI 구현, ViewController 구성, ViewModel 마무리 | @깃사용자이름 |
| [조선우](깃허브 링크) | 브랜드 버튼 UI, 카테고리 셀 UI | @깃사용자이름 |


> 협업 도구: Notion, GitHub, Slack, Figma
> 버전관리 전략: Feature Branch → PR → Main Merge
