
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schoolappfinal/util/InteractionUtil.dart';

class FirebaseAuthUtil{
  static Future<void> login(BuildContext context, String emailID, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "${emailID}@seoulforeign.org", password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        InteractionUtil.showSnackbar(context, "No user found.");
      } else if (e.code == 'invalid-email') {
        InteractionUtil.showSnackbar(context, "Please use the correct email format.");
      } else if (e.code == 'wrong-password') {
        InteractionUtil.showSnackbar(context, "Wrong password");
      } else if (e.code == 'too-many-requests') {
        InteractionUtil.showSnackbar(context, "Too many request. Try again later");
      } else if (e.code == 'network-request-failed') {
        InteractionUtil.showSnackbar(context, "Network request failed.");
      } else if (e.code == 'internal-error') {
        InteractionUtil.showSnackbar(context, "Internal error found.");
      } else {
        InteractionUtil.showSnackbar(context, "Unknown error");
      }
    }
  }
  static Future<void> testLogin(BuildContext context, String emailID, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "${emailID}", password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        InteractionUtil.showSnackbar(context, "해당 유저가 없습니다.");
      } else if (e.code == 'invalid-email') {
        InteractionUtil.showSnackbar(context, "이메일이 형식이 잘못되었습니다");
      } else if (e.code == 'wrong-password') {
        InteractionUtil.showSnackbar(context, "비밀번호가 틀렸습니다");
      } else if (e.code == 'too-many-requests') {
        InteractionUtil.showSnackbar(context, "잠시 후에 다시 시도해주세요");
      } else if (e.code == 'network-request-failed') {
        InteractionUtil.showSnackbar(context, "네트워크 요청이 실패하였습니다");
      } else if (e.code == 'internal-error') {
        InteractionUtil.showSnackbar(context, "내부 에러가 발생하였습니다");
      } else {
        InteractionUtil.showSnackbar(context, "알수 없는 에러가 발생하였습니다");
      }
    }
  }
  static Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }
  static Future<void> delete(BuildContext context) async{
    final user = currentUser(context);
    await user?.delete();
  }
  static Future<void> register(BuildContext context, String emailID, String password) async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "${emailID}@seoulforeign.org", password: password);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        InteractionUtil.showSnackbar(context, "비밀번호 형식이 안전하지 않습니다");
      } else if (e.code == 'email-already-in-use') {
        InteractionUtil.showSnackbar(context, "이미 ID가 있습니다");
      } else if (e.code == 'invalid-email') {
        InteractionUtil.showSnackbar(context, "이메일이 형식이 잘못되었습니다");
      } else if (e.code == 'too-many-requests') {
        InteractionUtil.showSnackbar(context, "잠시 후에 다시 시도해주세요");
      } else if (e.code == 'network-request-failed') {
        InteractionUtil.showSnackbar(context, "네트워크 요청이 실패하였습니다");
      } else if (e.code == 'internal-error') {
        InteractionUtil.showSnackbar(context, "내부 에러가 발생하였습니다");
      } else {
        InteractionUtil.showSnackbar(context, "알수 없는 에러가 발생하였습니다");
      }
    }
  }
  static Future<void> registerForTest(BuildContext context) async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "alexdhkil@gmail.com", password: "111111");

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        InteractionUtil.showSnackbar(context, "비밀번호 형식이 안전하지 않습니다");
      } else if (e.code == 'email-already-in-use') {
        InteractionUtil.showSnackbar(context, "이미 ID가 있습니다");
      } else if (e.code == 'invalid-email') {
        InteractionUtil.showSnackbar(context, "이메일이 형식이 잘못되었습니다");
      } else if (e.code == 'too-many-requests') {
        InteractionUtil.showSnackbar(context, "잠시 후에 다시 시도해주세요");
      } else if (e.code == 'network-request-failed') {
        InteractionUtil.showSnackbar(context, "네트워크 요청이 실패하였습니다");
      } else if (e.code == 'internal-error') {
        InteractionUtil.showSnackbar(context, "내부 에러가 발생하였습니다");
      } else {
        InteractionUtil.showSnackbar(context, "알수 없는 에러가 발생하였습니다");
      }
    }
  }

  static Future<UserCredential?> signInWithCredential(BuildContext context, AuthCredential credential) async {
    try {
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-account-exists-with-different-credential') {
        InteractionUtil.showSnackbar(context, "No user found.");
      } else if (e.code == 'invalid-credential') {
        InteractionUtil.showSnackbar(context, '잘못된 인증 정보입니다.');
      } else if (e.code == 'operation-not-allowed') {
        InteractionUtil.showSnackbar(context, '지원하지 않는 인증 방법입니다.');
      } else if (e.code == 'user-disabled') {
        InteractionUtil.showSnackbar(context, '중지된 사용자입니다.');
      } else if (e.code ==  'user-not-found') {
        InteractionUtil.showSnackbar(context, '사용자를 찾을 수 없습니다.');
      } else if (e.code == 'wrong-password') {
        InteractionUtil.showSnackbar(context, '비밀번호가 틀렸습니다.');
      } else if (e.code == 'we have blocked all requests') {
        InteractionUtil.showSnackbar(context, '요청이 너무 많아 잠시 후 다시 시도해주세요.');
      } else {
        InteractionUtil.showSnackbar(context, '서버에서 알 수 없는 에러가 발생하였습니다.');
      }
    } catch (e) {
      InteractionUtil.showSnackbar(context, '알 수 없는 에러가 발생하였습니다.');
    }
  }

  //이메일 전송 메소드
  static Future<void> sendEmail(BuildContext context, User user) async{
    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      InteractionUtil.showSnackbar(context, "FireauthUtil.sendEmail ${e.code}");
    }
  }

  //이메일 읹증 여부를 알고 싶음.
  static bool ifEmailInUse(BuildContext context, User user) {
    try{
      return user.emailVerified;
    } on FirebaseAuthException catch (e) {
      InteractionUtil.showSnackbar(context, "FireauthUtil.ifEmailinUse ${e.code}");
      return false;
    }
  }

  static void sendPasswordResetEmail(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      InteractionUtil.showSnackbar(context, "비밀번호 재설정 이메일이 전송되었습니다.");
    } catch (error) {
      InteractionUtil.showSnackbar(context, "비밀번호 재설정 이메일 전송 실패: $error");
    }
  }
  static User? currentUser(BuildContext context) {
    try{
      return FirebaseAuth.instance.currentUser;
    } on FirebaseAuthException catch (e) {
      InteractionUtil.showSnackbar(context, "FireauthUtil.currentUser ${e.code}");
      return null;
    }
  }
  static String? getImageUrl(BuildContext context) {
    final user = currentUser(context);
    return user?.photoURL;
  }
  static Future<void> setImageUrl(BuildContext context, String? photoURL) async {
    final user = currentUser(context);
    await user?.updatePhotoURL(photoURL);
  }
  static bool isAdmin(BuildContext context) {
    return FirebaseAuthUtil.currentUser(context)?.email ==
        "alex.kil.25@seoulforeign.org"||FirebaseAuthUtil.currentUser(context)?.email ==
        "lauren.elliott@seoulforeign.org"||FirebaseAuthUtil.currentUser(context)?.email == "angie.won@seoulforeign.org";
  }
}