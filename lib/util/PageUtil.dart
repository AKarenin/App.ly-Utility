import 'package:flutter/material.dart';
import 'package:schoolappfinal/screens/layouts/MainLayout.dart';

class PageUtil{
  static void push(BuildContext context, Widget nextPage){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => nextPage)
    );
  }
  static void pop(BuildContext context){
    Navigator.of(context).pop();
  }

  static void replace(BuildContext context, Widget nextPage) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => nextPage)
    );

  }
}