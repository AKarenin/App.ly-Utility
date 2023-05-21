
import 'package:flutter/material.dart';

class WidgetUtil {
  static List<Widget> repeatWidget(int number, Function makeWidget){
    List<Widget> widgetList = [];
    for(int i=0;i<number;i++){
      widgetList.add(makeWidget());
    }
    return widgetList;
  }

  static Widget myTextField(
      String label, {
        bool obscure = false,
        required TextEditingController controller,
      }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFF002F6D)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Color(0xFF002F6D),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Color(0xFF002F6D),
          ),
        ),
      ),
    );
  }

}
