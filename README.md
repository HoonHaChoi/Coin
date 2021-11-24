# 코일

>  가상화폐 실시간 시세 조회, 하루 수익 일지 기록, 실시간 알림 확인 프로젝트 



<img src="https://img.shields.io/badge/Language-Swift-red?style=flat&logo=swift&logoColor=white/"><img src="https://img.shields.io/badge/Platform-iOS-blue?style=flat&logo=ios&logoColor=white/">

- 기간 : 2021.07.16 - 2021.10.7(출시) ~ing

- 사용 언어 : Swift

- 개발 인원 : iOS(1명), BackEnd(1명)

- 라이브러리 : 

  |    이름    |           목적           |  버전  |
  | :--------: | :----------------------: | :----: |
  |  SocketIO  | 실시간 가상화폐 소켓통신 | 16.0.1 |
  | SwiftyJSON |    JSON Data decoding     | 5.0.1  |
  |   Charts   |   월별 기록 바 그래프    | 4.0.0  |
  |   Lottie   |     Splash Animation     | 3.2.3  |
  |  FireBase  |  FCM Push Notification   | 8.5.0  |

- 프레임 워크: 

  |  이름   |            목적            | 버전 |
  | :-----: | :------------------------: | :--: |
  | Combine | 비동기 네트워크 요청, 응답 |  -   |

  

<br/>

## 앱 주요 기능 

	- 거래소(Upbit, bithumb, Coinone) 시세 조회
	- 관심 가상 화폐 조회
	- 하루 수익 일지 기록
	- 목표 금액 도달 시 실시간 알림

<img alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/142800567-91ae4fb3-4d98-4752-8d93-f6dbf4ce886f.png">

### AppStore: [코일 앱스토어](https://apps.apple.com/kr/app/코일/id1586982814)

---



## 화면 & 특징

#### 스플래시 화면

| <img width="240" height="360" alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/142802823-06565c94-fa8f-420f-b08c-5824a27a1ee6.PNG"> | <img width="240" height="360" alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/142580948-c316cfcc-016b-44ad-bb63-71d5d57c10ec.gif"> |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|                        Splash Screen                         |                      Splash Screen(Gif)                      |
|                         앱 시작 화면                         |                         앱 시작 화면                         |



#### 시세 화면

| <img width="240" height="360" alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/142583154-496a372c-007a-426a-ad87-4b85bc16c0b2.PNG"> | <img width="240" height="360" alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/142581756-febf5576-189c-470c-985d-3eb583ebab35.PNG"> | <img width="240" height="360" alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/142802812-12dbf306-ff68-4600-bda3-ea2342163a75.PNG"> |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|                     시세 화면(관심 코인)                     |                      시세 화면(거래소)                       |                        시세 상세 화면                        |
|                실시간 관심 가상화폐 시세 조회                |               실시간 거래소 가상화폐 시세 조회               |        실시간 가상화폐 시세 그래프 및 이전 기록 표시         |



#### 검색 화면

| <img width="240" height="360" alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/142794583-2843eeb5-e78a-44ee-abac-0c2f9f29db5b.PNG"> | <img width="240" height="360" alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/142794585-276135fe-9f7c-4a10-834f-ef9324042f51.PNG"> | <img width="240" height="360" alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/142794587-4d6dadc6-2db5-4b4e-a897-c00284dbb26a.PNG"> |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|                         검색 화면 1                          |                         검색 화면 2                          |                         검색 화면 3                          |
|                     관심 등록 유무 표시                      |                       검색 거래소 선택                       |                          심볼 검색                           |



#### 일지 화면

| <img width="240" height="360" alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/142796654-3c8d6119-690f-481b-b006-9222d182f45e.PNG"> | <img width="240" height="360" alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/142796660-9c232ac6-9f17-4cf5-a7ef-3212fefd8a48.PNG"> | <img width="240" height="360" alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/142796659-a0247663-38fd-4b55-b071-c1fa6ec249d9.PNG"> | <img width="240" height="360" alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/142803690-f88f6614-87b2-481b-b56b-18fbaa71e325.PNG"> |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|                          일지 화면                           |                        일지 상세 화면                        |                         기간별 화면                          |                    일지 작성 및 수정 화면                    |
| 일자별 기록 표시 <br />오름,내림 차순 정렬<br />스와이프 일지 삭제 수정 기능<br />일지 추가 |              일별 기록 표시<br />메모 전체 표시              |                     기간별 총 기록 표시                      | 일지 날짜, 시작 및 최종 금액, 기록한 메모 작성, <br />시작 및 최종 금액, 기록한 메모 수정 |



#### 알림 화면

| <img width="240" height="360" alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/142801506-edd7bddd-1982-46ff-9d55-97458b283970.PNG"> | <img width="240" height="360" alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/142801516-8d374781-a725-4a8d-9ff6-9283f876d8cf.PNG"> | <img width="240" height="360" alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/142801517-27d5eac2-1afb-4461-9b77-25463187e238.PNG"> |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|                        알림 목록 화면                        |                     알림 생성, 수정 화면                     |                        알림 검색 화면                        |
| 알림 받는 가상화폐 표시<br />알림 스위치 On/Off 제공<br />스와이프 수정, 삭제 기능 |                알림 기준 금액,알림 주기 입력                 |              현재 코인 리스트 표시 및 검색 기능              |




---



## 프로젝트 구조

### [App Architecture Patterns](https://github.com/HoonHaChoi/Coin/wiki/Architecture-Patterns#architecture-patterns)



---

## 진행 과정에서의 이슈

> ### [앱 제작시 작성한 트러블 슈팅 및 고민,간단 회고](https://adorable-jar-904.notion.site/c33d5911400c41ec8fd3e0af7b0d17b6)

위의 링크를 통해 앱을 제작하면서 경험한 이슈 목록을 보실 수 있습니다.



#### 이미지 캐시처리 

- 많은 가상화폐의 이미지를 앱 실행 시, 스크롤 시 마다 다운받는 건 비효율적, 이미지 캐시 처리 필수
- memory Cache과 Disk Cache 방식 중 **Disk Cache** 방식을 이용, 앱 종료 후 다시 실행 해도 데이터가 소멸 되지 않음
- Cache폴더에 이미지 저장,  존재 유무에 따른 네트워크 요청,  요청 성공유무에 따른 이미지 전달

<img width="1089" alt="스크린샷 2021-11-23 오전 12 08 39" src="https://user-images.githubusercontent.com/33626693/142886020-af09f195-c4b7-4522-a548-37f1e33ad07b.png">

---



#### App, Notification Extension 이미지 공유

- 문제  
  - 푸시 알림에 이미지 추가 구현 중 Extension환경에서 App에 저장 된 가상화폐 이미지를 가져올 수 없음

- 원인 
  -  Extension과 App은 별개. 두개는 각각 다른 container로 존재하며, 기본적으로 둘 사이 데이터 공유되지 않음

- 개선 
  -  Extension과 App 모두 App Group 활성화, 이미지 저장 경로를 shared container에 이미지를 저장

- 결과
  -  Extension에서도 App에서 저장 되었던 가상화폐의 이미지를 사용 가능  

<img width="687" alt="스크린샷 2021-11-05 오후 10 25 16" src="https://user-images.githubusercontent.com/33626693/140517278-30a910db-d96e-4c68-b259-7b542debed17.png">

---
### 개발 후기

- 소켓으로 들어오는 데이터 수신 용량을 줄이기 위해 백엔드와 함께 의논하며 클라이언트에서 최소한 데이터 소비를 목표로 진행 했던 것이 기억에 남습니다.
- 제네릭 Mapping 객체를 만들고 거래소 추가,삭제에 대해 다형성을 줌으로 확장성이 좋은 코드를 만들 수 있었습니다.
- Composition Root 패턴을 적용시켜 의존성 주입을 한 곳에서 처리 할수 있었고, 적절한 protocol 사용과 의존성 주입이 유연한 코드 작성에 효과적인지 직접 느낄 수 있었습니다.

