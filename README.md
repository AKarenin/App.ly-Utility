# Command
패키지명(앱번들명) 변경 : flutter pub run change_app_package_name:main app.ly.schoolfinal
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

- freezed 파일 반영 명령어
# model 생성 명령어
flutter pub run build_runner watch --delete-conflicting-outputs

//TODO
// 유즈케이스 다이어그램.
- 유저의 종류 (+행위)
  - 어드민 (FirebaseUtil.isAdminUser) - 예약승인, 예약취소, 방닫기
  - 공동 유저 (FirebaseUtil.isPublicUser) - 예약요청, 공동유저만예약요청, 예약승인(일반 유저), 모니터안꺼짐
  - 일반 유저 - 예약요청, 내예약취소
- enum 변수 -> UserType userType;
