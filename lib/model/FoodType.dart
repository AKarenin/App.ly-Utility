import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Food.dart';

enum PlaceType {
  CAFE, CAFETERIA
}

class FoodType {
  late String documentId;
  String place;
  String type;
  int icon;
  List<Food> foodList;
  DateTime availableDate;

  FoodType(this.place, this.type, this.icon, this.foodList, this.availableDate);

  factory FoodType.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return FoodType(
      data?['place'],
      data?['type'],
      data?['icon'],
      data?['foodList'] is Iterable ? List.from(data?['foodList']).map((e)=>Food.fromJson(e)).toList() : [],
      DateTime.parse(data?['availableDate']),
    )..documentId = data?['documentId'];
  }

  Map<String, dynamic> toFirestore() {
    return {
      "documentId": documentId,
      "place": place,
      "type": type,
      "icon": icon,
      "foodList":  foodList.map((e)=>e.toFirestore()).toList(),
      "availableDate": DateUtils.dateOnly(availableDate).toIso8601String(),

    };
  }

}

