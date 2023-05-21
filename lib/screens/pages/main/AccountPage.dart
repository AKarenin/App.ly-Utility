import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schoolappfinal/screens/pages/auth/LoginPage.dart';
import 'package:schoolappfinal/screens/widgets/GradationColorWidget.dart';
import 'package:schoolappfinal/util/FirebaseAuthUtil.dart';
import 'package:schoolappfinal/util/InteractionUtil.dart';
import 'package:schoolappfinal/util/MonitorUtil.dart';
import 'package:schoolappfinal/util/PageUtil.dart';

import '../../widgets/ProfileImage.dart';

//3월 말까지만들어야함 (사용자앱(크레이브 2개, 계쩡 페이지 2개), 관리자 앱(페이지가 3개)) -> 출시(1주일 안쪽)

class AccountPage extends StatelessWidget {
  MonitorUtil? monitorUtil;
  AccountPage(this.monitorUtil, {Key? key}) : super(key: key);

  //DateTime selectedDateTime = DateTime.now();
  //TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    //크기 지정 바법
    //비율 크기 지정 (Expanded, Spacer)
    //고정 크기 지정 (SizedBox, Container)

    //Expanded 2가지 특성
    //1. 1개일때, 최대한 커지려고 노력.
    //2. 여러개일때, Expanded(flex:1), Expanded(flex:2)

    return Column(
      children: [
        Expanded(child: topArea(FirebaseAuthUtil.currentUser(context))),
        Expanded(child: bottomArea(context)),
      ],
    );
  }

  Widget bodyVer1(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF001B44)),
      body: Column(
        children: [
          const Text(
            "My Account",
            style: TextStyle(
              color: Color(0xFF002F6D),
              fontSize: 50,
              fontWeight: FontWeight.w500,
            ),
          ),
          /*ElevatedButton(onPressed: () async {
            DateTime? nullableDateTime = await showDatePicker(
              context: context,
              initialDate: selectedDateTime,
              firstDate: DateTime(2023,1,6),
              lastDate:  DateTime(2023,1,9),
            );
            if(nullableDateTime != null){
              selectedDateTime = nullableDateTime;
            }

          }, child: Text("showDateSelector")),
          ElevatedButton(onPressed: (){
            showTimePicker(context: context, initialTime: selectedTime).then((value){
              if(value!=null){
                selectedTime = value;
              }

            });
          }, child: Text("showTimeSelector")),*/
          ProfileImage(),
          Card(
            color: Color(0xFF002F6D),
            elevation: 10,
            child: ListTile(
              splashColor: Color(0xFF002F6D),
              onTap: () {
                User? user = FirebaseAuthUtil.currentUser(context);
                if (user?.email != null) {
                  FirebaseAuthUtil.sendPasswordResetEmail(
                      context, user!.email!);
                }
              },
              title: Text("Change Password"),
              trailing: Icon(
                Icons.change_circle,
              ),
            ),
          ),
          Card(
            color: Color(0xFF002F6D),
            elevation: 10,
            child: ListTile(
              onTap: () async {
                FirebaseAuthUtil.logout();
                await monitorUtil?.cancel();
                PageUtil.replace(context, LoginPage());
              },
              leading: Icon(
                Icons.change_circle,
              ),
              title: Text(
                "Sign Out",
                style: TextStyle(),
              ),
              trailing: Icon(
                Icons.arrow_right_sharp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget topArea(User? user) {
    return Container(
      width: double.infinity,
      color: Color(0xFF002F6D),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: ProfileImage(),
            width: 200,
            height: 200,
          ),
          SizedBox(
            height: 50,
            width: 50,
          ),
          Text(
            "${(user?.email ?? '').split('@').first}",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ],
      ),
    );
  }

  Widget bottomArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
      child: Column(
        children: [
          GradationColorWidget(
            child: Card(
              elevation: 10,
              child: ListTile(
                splashColor: Color(0xFF002F6D),
                onTap: () {
                  User? user = FirebaseAuthUtil.currentUser(context);
                  if (user?.email != null) {
                    FirebaseAuthUtil.sendPasswordResetEmail(context, user!.email!);
                  }
                },
                title: Text("Change Password"),
                trailing: Icon(
                  Icons.change_circle,
                ),
              ),
            ),
          ),
          GradationColorWidget(
            child: Card(
              elevation: 10,
              child: ListTile(
                onTap: () {
                  FirebaseAuthUtil.logout();
                  PageUtil.replace(context, LoginPage());
                },
                leading: Icon(
                  Icons.change_circle,
                ),
                title: Text(
                  "Sign Out",
                  style: TextStyle(),
                ),
                trailing: Icon(
                  Icons.arrow_right_sharp,
                ),
              ),
            ),
          ),
          GradationColorWidget(
            child: Card(
              elevation: 10,
              child: ListTile(
                onTap: () {
                  FirebaseAuthUtil.delete(context);
                  PageUtil.replace(context, LoginPage());
                },
                leading: Icon(
                  Icons.delete,
                ),
                title: Text(
                  "Delete Account",
                  style: TextStyle(),
                ),
                trailing: Icon(
                  Icons.arrow_right_sharp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
// Widget backgroundWidget(){
//   return Expanded(
//     child: Column(
//       children: [
//         Container(
//           width: double.infinity,
//           color: Color(0xFF002F6D),
//         ),
//         Container(
//           width: double.infinity,
//           color: Colors.white,
//
//         ),
//       ],
//
//     ),
//   );
// }
}
