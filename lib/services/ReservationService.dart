import 'package:flutter/material.dart';
import 'package:schoolappfinal/dbs/PeriodRepository.dart';
import 'package:schoolappfinal/dbs/ReserveInfoRepository.dart';
import 'package:schoolappfinal/model/Period.dart';
import 'package:schoolappfinal/model/ReserveInfo.dart';
class ReservationService {
  static final ReservationService me = ReservationService();

  Future<Map<String, ReserveInfo>> getReserveInfosByPeriod(Period? selectedPeriod) async {

    DateTime today = DateTime.now();
    Map<String, ReserveInfo> reserveInfoByRoomId = {};
    for (final room in (selectedPeriod?.roomList ?? [])) {
      final reserveList = (await ReserveInfoRepository.getList(
        ReserveInfoRepository.where('roomId', isEqualTo: room.id).where(
            'roomDate',
            isEqualTo: DateUtils.dateOnly(today).toIso8601String()),
      ));
      final reserveInfo = reserveList.isNotEmpty ? reserveList[0] : null;
      if (reserveInfo != null) {
        reserveInfoByRoomId[room.id] = reserveInfo;
      }
    }

    return reserveInfoByRoomId;
  }
}
