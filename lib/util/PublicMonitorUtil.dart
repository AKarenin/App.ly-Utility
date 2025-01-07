import 'package:cron/cron.dart';
import 'package:schoolappfinal/dbs/BlackUserRepository.dart';
import 'package:schoolappfinal/dbs/ReservedInfoRepository.dart';
import 'package:schoolappfinal/model/Period.dart';
import 'package:schoolappfinal/model/ReservedInfo.dart';
import 'package:schoolappfinal/services/ReservationService.dart';

import '../model/BlackUser.dart';

class PublicMonitorUtil {
  late List<ScheduledTask> scheduleList;
  bool isInitialized = false;

  void run(List<Period> periodList, Function setState) {
    if (isInitialized) {
      return;
    }
    isInitialized = true;

    scheduleList = [];
    final cron = Cron();
    for (var period in periodList) {
      //Period 의 시작시간에 감시를 시작해서, 1분마다 아래 내용을 확인해라.
      //분 시 일 월 요일
      final schedule = cron.schedule(
        Schedule.parse(
            '*/1 ${period.startTime.hour}-${period.startTime.hour + 1} * * 1-5'),
        () async {
          print("Monitor");

          Map<String, ReservedInfo> reserveInfoByRoomId =
              await ReservationService.me.getReserveInfosByPeriod(period);

          for (final entry in reserveInfoByRoomId.entries) {
            String roomId = entry.key;
            final reserveInfo = entry.value;
            final reserveStatus = reserveInfo.reserveStatus;

            DateTime now = DateTime.now();
            //예약한지 5분이 지났는지, verify가 안됬는지
            if (reserveInfo.reservedTime
                .add(const Duration(minutes: 5))
                .isBefore(now) && reserveStatus == ReserveStatus.REQUEST) {
              reserveInfo.reserveStatus = ReserveStatus.ELAPSED;
              await ReservedInfoRepository.update(reserveInfo);

              //update
              try {
                setState();
              } catch (ignored) {}

              // blacklist 저장소에 넣음.
              String blackEmail = reserveInfo.reservedEmail!;
              BlackUser blackUser = BlackUser(blackEmail, DateTime.now());
              BlackUserRepository.create(blackUser);
            }
          }
        },
      );
      scheduleList.add(schedule);
    }
  }

  Future<void> cancel() async {
    for (var schedule in scheduleList) {
      await schedule.cancel();
    }
  }
}
