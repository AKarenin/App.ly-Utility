import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:schoolappfinal/util/FirebaseAuthUtil.dart';

class AuthService {
  static void signInWithEmail(BuildContext context){

  }

  static Future<void> signInWithGoogle(BuildContext context) async{
    final googleUser = await GoogleSignIn().signIn();

    final googleAuth = await googleUser?.authentication;
    if (googleAuth != null) {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuthUtil.signInWithCredential(context, credential);
    }
  }
}