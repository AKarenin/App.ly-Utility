import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../util/FirebaseAuthUtil.dart';
import 'Room.dart';

enum ReserveStatus{
  /*
예약 상태
1.예약안함(파랑)/ isReserved:false, isVerified:false
2.예약요청(노랑)/ isReserved: true, isVerified: false, reservedUser == currentUser
3-1.예약승인됨(초록)/ isReserved: true, isVerified: true, reservedUser == currentUser
3-2.이미예약됨(빨강)/ isReserved: true, isVerified: 상관없음, reservedUser != currentUser
   */
  REQUEST,
  VERIFIED,
  TAKEN,
}

//reservedEmail(String): 누가 예약했는지
//periodIndex(int): 언제
//room(Room): 어떤 방
//isReserved(bool),
class ReserveInfo {
  late String documentId;
  String roomId;
  String? reservedEmail;
  int periodIndex;
  bool isReserved;
  DateTime roomDate;
  bool isVerified;
  DateTime reservedTime;

  ReserveInfo(this.roomId, this.reservedEmail, this.periodIndex,
      this.isReserved, this.roomDate, this.isVerified, this.reservedTime);

  factory ReserveInfo.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ReserveInfo(
      data?['roomId'],
      data?['reservedEmail'],
      data?['periodIndex'],
      data?['isReserved'],
      DateTime.parse(data?['roomDate']),
      data?['isVerified'],
      DateTime.parse(data?['reservedTime']),
    )..documentId = data?['documentId'];
  }

  Map<String, dynamic> toFirestore() {
    return {
      "documentId": documentId,
      "roomId": roomId,
      "periodIndex": periodIndex,
      "reservedEmail": reservedEmail,
      "isReserved": isReserved, //예약 요청
      "isVerified": isVerified, //예약 승인
      "roomDate": DateUtils.dateOnly(roomDate).toIso8601String(), //시간 개념은 없애야함.
      "reservedTime": reservedTime.toIso8601String(),
    };
  }

  ReserveStatus? returnStatus(BuildContext context){
    if(!isReserved){
      return null;
    }

    if(reservedEmail==FirebaseAuthUtil.currentUser(context)!.email)  {
      if(isVerified) {
        return ReserveStatus.VERIFIED;
      } else {
        return ReserveStatus.REQUEST;
      }
    }

    return ReserveStatus.TAKEN;
  }


  //인스턴스 메소드?/ 클래스 메소드?
}
