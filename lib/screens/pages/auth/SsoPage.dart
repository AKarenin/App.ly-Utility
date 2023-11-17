import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:schoolappfinal/screens/layouts/MainLayout.dart';
import 'package:schoolappfinal/screens/pages/auth/RegisterPage.dart';
import 'package:schoolappfinal/screens/pages/auth/TestLoginPage.dart';
import 'package:schoolappfinal/screens/pages/main/AccountPage.dart';
import 'package:schoolappfinal/services/AuthService.dart';
import 'package:schoolappfinal/util/FirebaseAuthUtil.dart';
import 'package:schoolappfinal/util/PageUtil.dart';
import 'package:schoolappfinal/util/InteractionUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/WidgetUtil.dart';

class SsoPage extends StatelessWidget {
  SsoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
              child: Image.asset("assets/images/SplashPage.jpg",
                  fit: BoxFit.fill)),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Card(
                    child: Container(
                      width: 500,
                      padding: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Sign In With Your SFS Account",
                            style: TextStyle(
                              fontSize: 35,
                              color: Color(0xFF002F6D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 40),
                          SignInButton(
                            Buttons.Google,
                            text: "Sign up with Google",
                            onPressed: () async {
                              try {
                                await AuthService.signInWithGoogle(context, suffix:'@seoulforeign.org');
                                PageUtil.replace(context, MainLayout());
                              }
                              on String catch(value)  {
                                InteractionUtil.showSnackbar(context, value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
