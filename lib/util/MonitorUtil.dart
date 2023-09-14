import 'package:cron/cron.dart';
import 'package:schoolappfinal/dbs/BlackUserRepository.dart';
import 'package:schoolappfinal/dbs/PeriodRepository.dart';
import 'package:schoolappfinal/dbs/ReserveInfoRepository.dart';
import 'package:schoolappfinal/model/Period.dart';
import 'package:schoolappfinal/model/ReserveInfo.dart';
import 'package:schoolappfinal/services/ReservationService.dart';

import '../model/BlackUser.dart';

class MonitorUtil {
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
      //Peroid 의 시작시간에 감시를 시작해서, 1분마다 아래 내용을 확인해라.
      final schedule = cron.schedule(
        Schedule.parse(
            '0 */1 ${period.startTime.hour}-${period.startTime.hour + 1} * * 1-5'),
        () async {
          print("Monitor");

          Map<String, ReserveInfo> reserveInfoByRoomId =
              await ReservationService.me.getReserveInfosByPeriod(period);

          for (final entry in reserveInfoByRoomId.entries) {
            String roomId = entry.key;
            final reserveInfo = entry.value;

            DateTime now = DateTime.now();
            //예약한지 5분이 지났는지, 베리파이가 됬는지
            if (reserveInfo.reservedTime
                .add(Duration(minutes: 5))
                .isBefore(now) && !reserveInfo.isVerified) {
              print('cancel reserveInfo: ${reserveInfo.toFirestore()}');
              String blackEmail = reserveInfo.reservedEmail!;

              //예약여부를 캔슬(리저브인포를 삭제)
              await ReserveInfoRepository.delete(
                  documentId: reserveInfo.documentId);
              try {
                setState();
              } catch (ignored) {}

              // 블랙리스트 저장소에 넣음.
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
