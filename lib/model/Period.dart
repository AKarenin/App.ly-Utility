
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Room.dart';

class Period {
  late String documentId;
  int index;
  TimeOfDay startTime;
  TimeOfDay endTime;
  List<Room> roomList;
  Period(this.index, this.startTime, this.endTime, this.roomList);

  factory Period.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    final period = Period(
      data?['index'],
      TimeOfDay(hour:int.parse(data?['startTime'].split(":")[0].split("(").last),minute: int.parse(data?['startTime'].split(":")[1].split(")").first)),
      TimeOfDay(hour:int.parse(data?['endTime'].split(":")[0].split("(").last),minute: int.parse(data?['endTime'].split(":")[1].split(")").first)),
      data?['roomList'] is Iterable ? List.from(data?['roomList']).map((roomMap)=>Room.fromJson(roomMap)).toList() : [],
    );

    if(data?['documentId'] != null ) {
      period.documentId=data?['documentId'];
    }

    return period;
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (documentId != null) "documentId": documentId,
      if (index != null) "index": index,
      if (startTime != null) "startTime": "${startTime.hour}:${startTime.minute}",
      if (endTime != null) "endTime": "${endTime.hour}:${endTime.minute}",
      if (roomList != null) "roomList": roomList.map((room)=>room.toFirestore()).toList(),
    };
  }
}
