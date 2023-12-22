
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:schoolappfinal/screens/pages/SplashPage.dart';
import 'package:schoolappfinal/screens/pages/auth/LoginPage.dart';
import 'package:schoolappfinal/screens/pages/manage/SavePeriodPage.dart';

import 'firebase_options.dart';
import 'screens/layouts/MainLayout.dart';
import 'screens/pages/auth/RegisterPage.dart';
import 'screens/pages/main/HSLibraryPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}









































































