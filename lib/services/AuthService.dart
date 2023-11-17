import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:schoolappfinal/util/FirebaseAuthUtil.dart';
import 'package:schoolappfinal/util/InteractionUtil.dart';

class AuthService {
  static void signInWithEmail(BuildContext context) {}

  static Future<void> signInWithGoogle(BuildContext context,
      {required String suffix}) async {
    final googleUser = await GoogleSignIn().signIn(); //cancel -> null
    if (googleUser == null) {
      return;
    }

    if (!googleUser.email.endsWith(suffix)) {
      throw "Please use SFS domain";
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuthUtil.signInWithCredential(context, credential);
  }
}
