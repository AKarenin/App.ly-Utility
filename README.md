# Command
패키지명 변경 : flutter pub run change_app_package_name:main app.ly.schoolfinal
앱이름 변경 : flutter pub run rename_app:main all="App.ly Utility"

안드로이드 빌드 명령어
- pubspec.yaml에 버전과 코드를 변경한다. 0.0.1+1 -> 0.0.2+2
- flutter build appbundle --release --no-tree-shake-icons
애플 아이오에스 빌드 명령어
- pubspec.yaml에 버전과 코드를 변경한다. 0.0.1+1 -> 0.0.2+2
- flutter build ios --release --no-tree-shake-icons
- Product-Archive로 build 
- Windows-Organizer에서 apple developer center upload
웹 빌드 명령어
- flutter build web
- firebase deploy

- 용어 사전
CocoaPods : 애플에서 라이브러리를 관리할 때 필요한 프로그램
Gradle : 안드로이드에서 라이브러리를 관리할 때 필요한 프로그램
Pub Dev : 다트에서 라이브러리를 관리할 때 필요한 프로그램# App.ly-Utility




//TODO
- 유저가 자기가 verify되었는지 모른다 -> 알림이 필요 (예약했을때, 관리자가 지금 예약이 되었습니다를 승인하기 전에 노란색같은걸로 표시하면 좋겠다)
- Period 5분전에만 예약할수 있게 해달라
- 한국어 좀 영어로 고쳐달라

예약 상태
1.예약안함(파랑)/ isReserved:false, isVerified:false
2.예약요청(노랑)/ isReserved: true, isVerified: false, reservedUser == currentUser
3-1.예약승인됨(초록)/ isReserved: true, isVerified: true, reservedUser == currentUser
3-2.이미예약됨(빨강)/ isReserved: true, isVerified: 상관없음, reservedUser != currentUser
4. ㅇㅖ

"isReserved": isReserved, //예약 요청
"isVerified": isVerified, //예약 승인

-----



