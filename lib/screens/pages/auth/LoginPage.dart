import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schoolappfinal/screens/layouts/MainLayout.dart';
import 'package:schoolappfinal/screens/pages/auth/RegisterPage.dart';
import 'package:schoolappfinal/screens/pages/auth/TestLoginPage.dart';
import 'package:schoolappfinal/screens/pages/main/AccountPage.dart';
import 'package:schoolappfinal/util/FirebaseAuthUtil.dart';
import 'package:schoolappfinal/util/PageUtil.dart';
import 'package:schoolappfinal/util/InteractionUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/WidgetUtil.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  String inputKeyword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF001B44),
      ),
      body: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (KeyEvent keyEvent) {
          inputKeyword += keyEvent.character ?? '';
          print('inputKeyword: $inputKeyword');
          if (inputKeyword.contains('!qwerty!')) {
            //TestLoginPage로 변경.
            PageUtil.replace(context, TestLoginPage());
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 45,
                  color: Color(0xFF002F6D),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 30),
              Card(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: WidgetUtil.myTextField("SFS Email",
                                controller: idController),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "@seoulforeign.org",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      WidgetUtil.myTextField("Password",
                          obscure: true, controller: pwController),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              //ElevatedButton, TextButton, OutlinedButton
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        PageUtil.push(context, RegisterPage());
                      },
                      child: Text("Don't have an account?",
                          style: TextStyle(fontSize: 18))),
                  Spacer(),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        login(context);
                      },
                      icon: Icon(Icons.add_box_outlined,
                          color: Color(0xFF002F6D)),
                      label: Text("SIGN IN",
                          style: TextStyle(
                              color: Color(0xFF002F6D),
                              fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    if (idController.text == "") {
      InteractionUtil.showSnackbar(context, "Insert your id");
      return;
    } else if (pwController.text == "") {
      InteractionUtil.showSnackbar(context, "Insert your password");
      //InteractionUtil.showBottomSheet(context, Container(height: 200, color: Colors.amber, child: Text("Insert your password"),));
      return;
    }

    //로그인 프로레스
    //1. 로그인을 시도. 2. 로그인이 안되었다, 로그인 실패, 3. 로그인이 되었다, 해당 유저의 이메일 인증여부를 확인. 3. 이메일 인증이 안되었따면, 인증하라고 함. 4. 이메일 인증이 되었따면, 로그인시킴.
    await FirebaseAuthUtil.login(context, idController.text, pwController.text);
    User? user = FirebaseAuthUtil.currentUser(context);
    if (user != null) {
      if (FirebaseAuthUtil.ifEmailInUse(context, user)) {
        PageUtil.replace(context, MainLayout());
      } else {
        InteractionUtil.showSnackbar(
            context, "Your email has not been verified");
        FirebaseAuthUtil.logout();
      }
    }
  }

  void loginByDB(BuildContext context) async {
    //SnackBarUtil.show(context, "id:${idController.text}, pw:${pwController.text}");

    //[유효성을 검사]
    //아이디가 비었느니.. 비밀번호가 비었느니..
    //유효하지 않으면, 알림을 줘야함. (다이어로그, 스낵바)
    if (idController.text == "") {
      InteractionUtil.showSnackbar(context, "Insert your id");
      return;
    } else if (pwController.text == "") {
      InteractionUtil.showSnackbar(context, "Insert your password");
      //InteractionUtil.showBottomSheet(context, Container(height: 200, color: Colors.amber, child: Text("Insert your password"),));
      return;
    }

    //데이터베이스에 이 아이디와 비밀번호를 갖은 유저가 있느냐?
    //유효하지 않으면, 알림을 줘야함. (다이어로그, 토스트)
    final local_database = await SharedPreferences.getInstance();
    String? userJsonString = local_database.getString(idController.text);
    if (userJsonString != null) {
      SfsUser user = SfsUser.fromJson(jsonDecode(userJsonString));
      if (user.pw == pwController.text) {
        PageUtil.push(context, MainLayout());
        return;
      }
    }

    InteractionUtil.showSnackbar(context, "Your username or password is wrong");
  }
}
