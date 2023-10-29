import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schoolappfinal/screens/layouts/MainLayout.dart';
import 'package:schoolappfinal/screens/pages/auth/RegisterPage.dart';
import 'package:schoolappfinal/screens/pages/main/AccountPage.dart';
import 'package:schoolappfinal/util/FirebaseAuthUtil.dart';
import 'package:schoolappfinal/util/PageUtil.dart';
import 'package:schoolappfinal/util/InteractionUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/WidgetUtil.dart';

class TestLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        child: Text("Test Login"),
        onPressed: (){
          FirebaseAuthUtil.testLogin(context, "alexdhkil@gmail.com", "111111");
          PageUtil.replace(context, MainLayout());
        },
      ),
    );
  }
}
