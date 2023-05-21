
import 'package:flutter/material.dart';

import '../../util/PageUtil.dart';


class MyAlertDialog extends StatelessWidget {
  Widget title;
  Widget? content;
  void Function() okWork;
  MyAlertDialog(this.title,this.content, this.okWork, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
          height: 200,
          width: 100,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              Spacer(),
              (content??Text("")),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: (){
                    okWork();
                    PageUtil.pop(context);
                  },  child: Text("Ok")),
                  TextButton(onPressed: (){
                    PageUtil.pop(context);
                  },  child: Text("cancel")),
                ],
              )

            ],
          ),
        )
    );
  }

  static void show(BuildContext context,
      {required Widget title, Widget? content, required void Function() okWork}){
    showDialog(context: context, builder: (context){
      return MyAlertDialog(title,content,okWork);
    });
  }
}