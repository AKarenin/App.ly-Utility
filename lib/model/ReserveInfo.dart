import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Room.dart';

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
      "reservedEmail": reservedEmail,
      "periodIndex": periodIndex,
      "isReserved": isReserved,
      "roomDate": DateUtils.dateOnly(roomDate).toIso8601String(), //시간 개념은 없애야함.
      "isVerified": isVerified,
      "reservedTime": reservedTime.toIso8601String(),
    };
  }
}
