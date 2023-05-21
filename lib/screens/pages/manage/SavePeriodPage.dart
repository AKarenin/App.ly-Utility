/*

  List<Period> periodList = [
    Period(4, const TimeOfDay(hour: 11, minute: 55),
        const TimeOfDay(hour: 12, minute: 30), [
      Room("001A", 7),
      Room("001B", 4),
      Room("001C", 4),
      Room("001D", 4),
      Room("001E", 4, isReserved: true),
      Room("001F", 4),
      Room("001G", 7, isReserved: true),
    ]),
    Period(5, const TimeOfDay(hour: 12, minute: 35),
        const TimeOfDay(hour: 1, minute: 10), [
      Room("001A", 7),
      Room("001B", 4),
      Room("001C", 4),
      Room("001D", 4),
      Room("001E", 4),
      Room("001F", 4),
      Room("001G", 7, isReserved: true),
    ]),
    Period(6, const TimeOfDay(hour: 11, minute: 15),
        const TimeOfDay(hour: 12, minute: 50), [
      Room("001A", 7),
      Room("001B", 4),
      Room("001C", 4),
      Room("001D", 4),
      Room("001E", 4, isReserved: true),
      Room("001F", 4),
      Room("001G", 7),
    ]),
  ];
 */

//방이무엇이있는가? 방리스트가 있어야함. 7개
//예약가능한기간이 무엇이 있는가? 3개

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schoolappfinal/dbs/PeriodRepository.dart';
import 'package:schoolappfinal/model/Period.dart';
import 'package:schoolappfinal/model/Room.dart';
/*
[4, "12:00", "12:35", [["001A", 7],["001B", 4],["001C", 4], ["001D", 4],["001E", 4],["001F", 4],["001G", 7]]]
 */
class SavePeriodPage extends StatelessWidget {
  final controller = TextEditingController();

  SavePeriodPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
                hintText: '[6, "11:15", "12:15", [["001A", 7],["001B", 4]]]'),
          ),
          ElevatedButton(
              onPressed: () async {
                //json Str -> json -> period instance
                final jsonStr = controller.text;
                List<dynamic> json = jsonDecode(jsonStr);
                final period = Period(
                    json[0],
                    TimeOfDay(
                        hour: int.parse(json[1].split(":")[0]),
                        minute: int.parse(json[1].split(":")[1])),
                    TimeOfDay(
                        hour: int.parse(json[2].split(":")[0]),
                        minute: int.parse(json[2].split(":")[1])),
                    [
                      for (final roomContentList in json[3])
                        Room(roomContentList[0], roomContentList[1]),
                    ]);

                //파이어스토어에 저장 (period)
                await PeriodRepository.save(period);
              },
              child: Text("Add"))
        ],
      ),
    );
  }
}
