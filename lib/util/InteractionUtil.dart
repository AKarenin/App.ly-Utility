import 'package:flutter/material.dart';
class InteractionUtil {
  //인스턴스 필드, 인스턴스 메소드 -> 인스턴스 갖고 있는..

  static void showSnackbar(BuildContext context, String text){ //클래스 메소드 만들기. 클래스 필드 만들기. (클래스가 갖고 있는 )
    var messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(SnackBar(content: Text(text)));
  }

  static void showBottomSheet(BuildContext context, Widget displayWidget){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return displayWidget;
      },
    );
  }
}