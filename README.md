# 코일

>  가상화폐 실시간 시세 조회, 일지 작성, 실시간 알림 확인하는 어플

<img src="https://img.shields.io/badge/Language-Swift-red?style=flat&logo=swift&logoColor=white/"><img src="https://img.shields.io/badge/Platform-iOS-blue?style=flat&logo=ios&logoColor=white/"><img src="https://img.shields.io/badge/Database-CoreData-green?style=flat&logo=coredata&logoColor=white/">

- 기간 : 2021.07.11 - 2021.10.7(출시) ~ing

- 사용 언어 : Swift, Combine

- 오픈 소스 : SocketIO, SwiftyJSON, Charts, Lottie, FireBase

<br/>

## 앱 주요 기능 

	- 거래소(Upbit, bithumb, Coinone) 시세 조회
	- 관심 가상 화폐 조회
	- 하루 수익 일지 기록
	- 목표 금액 도달 시 실시간 알림

![Apple iPhone 11 Pro Max Presentation (4)-2](https://user-images.githubusercontent.com/33626693/140525158-9b258640-906a-43e4-a00d-0e215aa2a561.png)

> ### [코일 앱스토어](https://apps.apple.com/kr/app/코일/id1586982814)

<br/>

## 진행 과정에서의 대표 이슈

> [앱 제작시 작성한 트러블 슈팅 및 고민,간단 회고](https://adorable-jar-904.notion.site/c33d5911400c41ec8fd3e0af7b0d17b6)

- #### 소켓 데이터 수신

  - 초기 소켓 로직 socket.on("Event") 이벤트 요청 후 connect 소켓 연결,  disconnect 연결 해제로 구현



- 문제 
  - 소켓만 연결 된 상태 또는 이벤트 수신을 모두 종료 하더라도 데이터가 지속적으로 기기에 수신

- 개선 
  - 백엔드 : Room 채널 구현, Room에 접속 된 클라이언트에게 이벤트 발신 하도록 변경 
  - 클라이언트 :  서버의 Room에 emit(Join or leave) 참여 또는 탈퇴 추가, 해당 룸의 이벤트를 수신 받도록 변경

- 결과 
  -  지속적으로 불 필요하게 들어오던 데이터 해결 

<img width="1184" alt="스크린샷 2021-11-05 오후 9 26 31" src="https://user-images.githubusercontent.com/33626693/140510012-ccf2ea2f-6180-4a3b-a635-9be9ec567759.png">

---

### TradingLog(일지 작성) Redux 단방향 데이터 흐름 구조 적용

<img width="886" alt="스크린샷 2021-11-05 오후 4 53 12" src="https://user-images.githubusercontent.com/33626693/140478104-b37748f0-28a3-4311-bba3-33729e6b6a37.png">

- #### 장점

  - delegate을 사용 대신 상태를 알리는 `Action` 을 사용해 상태가 어떻게 변화할지 예측하기 쉬움
  - 순수함수 사용하여 테스트에 용이하다

- #### 단점 

  - 러닝 커브 높다 개념을 이해하는데 시간이 소요 
  - Redux 철학이 강제하는 방식으로 인해 코드가 복잡해지거나 어려워 질 수 있다

---

### App, Notification Extension 이미지 공유



- 문제  
  - 푸시 알림에 이미지 추가 구현 중 Extension환경에서 App에 저장 된 가상화폐 이미지를 가져올 수 없음



- 원인 
  -  Extension과 App은 별개. 두개는 각각 다른 container로 존재하며, 기본적으로 둘 사이 데이터 공유되지 않음



- 개선 
  -  Extension과 App 모두 App Group 활성화, 이미지 저장 경로를 shared container에 이미지를 저장

- 결과
  -  Extension에서도 App에서 저장 되었던 가상화폐의 이미지를 사용 가능  

<img width="687" alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/140517278-30a910db-d96e-4c68-b259-7b542debed17.png">





