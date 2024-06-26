import 'package:flutter/material.dart';
import 'package:schoolappfinal/dbs/PeriodRepository.dart';
import 'package:schoolappfinal/dbs/ReservedInfoRepository.dart';
import 'package:schoolappfinal/model/Period.dart';
import 'package:schoolappfinal/model/ReservedInfo.dart';
class ReservationService {
  static final ReservationService me = ReservationService();

  Future<Map<String, ReservedInfo>> getReserveInfosByPeriod(Period? selectedPeriod) async {
    print('getReserve');

    DateTime today = DateTime.now();
    Map<String, ReservedInfo> reserveInfoByRoomId = {};
    for (final room in (selectedPeriod?.roomList ?? [])) {
      final reserveList = (await ReservedInfoRepository.getList(
        ReservedInfoRepository.where('roomId', isEqualTo: room.id).where(
            'roomDate',
            isEqualTo: DateUtils.dateOnly(today).toIso8601String()),
      ));
      final reserveInfo = reserveList.isNotEmpty ? reserveList[0] : null;
      if (reserveInfo != null) {
        print('reserveInfo exist');
        reserveInfoByRoomId[room.id] = reserveInfo;
      }
    }

    print('getReserve: reserveInfoByRoomId:${reserveInfoByRoomId}');
    return reserveInfoByRoomId;
  }


}
