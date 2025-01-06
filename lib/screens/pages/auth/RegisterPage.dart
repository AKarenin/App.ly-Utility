import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schoolappfinal/screens/layouts/MainLayout.dart';
import 'package:schoolappfinal/util/FirebaseAuthUtil.dart';
import 'package:schoolappfinal/util/PageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/InteractionUtil.dart';
import '../../../util/WidgetUtil.dart';

class SfsUser {
  //--field
  String id;
  String pw;
  String confirm_pw;

  //--method
  SfsUser(
      {required this.id, required this.pw, required this.confirm_pw});

  String getInvalidMessage() {
    if (id.isEmpty) {
      return "Please fill in the id";
    }

    if (pw.isEmpty) {
      return "Please fill in the password";
    }

    if (confirm_pw != pw) {
      return "The password has to match";
    }

    return "";
  }

  SfsUser.fromJson(Map<String, dynamic> json)
      : this(id:json["id"],pw:json["pw"],confirm_pw:json["confirm_pw"]);

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'pw' : pw,
      'confirm_pw': confirm_pw,
    };
  }

}

class RegisterPage extends StatelessWidget {
  final pwController = TextEditingController();
  final idController = TextEditingController();
  final pwConfirmController = TextEditingController();

  RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF001B44),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Register",
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
                          child: WidgetUtil.myTextField("SFS ID (Email)",
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
                        controller: pwController, obscure: true),
                    SizedBox(height: 20),
                    WidgetUtil.myTextField("Confirm Password",
                        controller: pwConfirmController, obscure: true),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            //ElevatedButton, TextButton, OutlinedButton
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (){
                  signUp(context);
                },
                child: Text("SIGN UP"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF001B44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  void signUpByDB(BuildContext context)async {
    final user = SfsUser(
        id: idController.text,
        pw: pwController.text,
        confirm_pw: pwConfirmController.text);

    //유효성 검사
    var invalidMessage = user.getInvalidMessage();
    if(invalidMessage.isNotEmpty) {
      InteractionUtil.showSnackbar(context, invalidMessage);
      return;
    }

    //비밀번호 암호화는 서버에서 진행.
    //로컬 -> 네트워크(프로토콜,약속, HTTP, HTTPS) -> 서버

    //회원가입
    //(Local)데이터베이스에 해당 아이디가 있는지 체크
                        //없으면,
                        //이메일로 인증번호를 받아서, 해당 인증번호로 앱에서 인증
                        //인증번호가 틀리다면? 3번의 기회를 줬음. 다시 처음부터.
                        //인증번호가 맞다면, 데이터베이스 작업
    print("1");
    final local_database = await SharedPreferences.getInstance();
    print("1-1");
    //key:"아이디",value:"비밀번호";;
    //아이디(키)를 통해서, 유저(밸류)를 갖고와야함.
    String? userJsonString = local_database.getString(user.id);
    print("1-2");
    if(userJsonString == null) {
      print("2");
      local_database.setString(user.id, jsonEncode(user.toJson()));
      local_database.setBool("isLogin", true);

      //페이지 이동
      //메인 페이지로 이동
      PageUtil.push(context, MainLayout());
    }
    else {
      print("3");
      InteractionUtil.showSnackbar(context, "There is already an account with that name");
    }
  }
  void signUp(BuildContext context)async {
    final sfsUser = SfsUser(
        id: idController.text,
        pw: pwController.text,
        confirm_pw: pwConfirmController.text);

    //유효성 검사
    var invalidMessage = sfsUser.getInvalidMessage();
    if(invalidMessage.isNotEmpty) {
      InteractionUtil.showSnackbar(context, invalidMessage);
      return;
    }

    //이메일 전송 과정
    //회원가입 프로세스
    //1. 회우너가입을 완료시켜야함. 2. 이메일을 전송함.
    await FirebaseAuthUtil.register(context, idController.text, pwController.text);

    User? user = FirebaseAuthUtil.currentUser(context);
    if(user != null){
      await FirebaseAuthUtil.sendEmail(context, user);
      await FirebaseAuthUtil.logout();

      PageUtil.pop(context);
      InteractionUtil.showSnackbar(context, "An Email has been sent to verify your account");
    }
  }


}
