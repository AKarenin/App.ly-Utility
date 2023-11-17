
import 'package:flutter/material.dart';
import 'package:schoolappfinal/screens/layouts/MainLayout.dart';
import 'package:schoolappfinal/screens/pages/auth/LoginPage.dart';
import 'package:schoolappfinal/screens/pages/auth/SsoPage.dart';
import 'package:schoolappfinal/util/PageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/FirebaseAuthUtil.dart';

class SplashPage extends StatelessWidget {
  BuildContext? context;

  SplashPage({Key? key}) : super(key: key){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      afterBuild();
    });
  }

  void afterBuild() {
    if(context == null ) return;

    if(FirebaseAuthUtil.currentUser(context!)!=null){
      PageUtil.replace(context!, MainLayout());
    }
    else {
      PageUtil.replace(context!, SsoPage());
    }
  }


  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      body: SizedBox.expand(child: Image.asset("assets/images/SplashPage.jpg", fit: BoxFit.fill)),
    );
  }
}
