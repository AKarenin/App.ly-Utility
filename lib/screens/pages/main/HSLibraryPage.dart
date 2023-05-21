import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:schoolappfinal/dbs/PeriodRepository.dart';
import 'package:schoolappfinal/dbs/ReserveInfoRepository.dart';
import 'package:schoolappfinal/model/Period.dart';
import 'package:schoolappfinal/model/Room.dart';
import 'package:schoolappfinal/screens/widgets/ChoosePeriodWidget.dart';
import 'package:schoolappfinal/screens/widgets/MyAlertDialog.dart';
import 'package:schoolappfinal/services/ReservationService.dart';
import 'package:schoolappfinal/util/FirebaseAuthUtil.dart';
import 'package:schoolappfinal/util/InteractionUtil.dart';

import '../../../model/ReserveInfo.dart';
import '../../../util/MonitorUtil.dart';

//[O] 1. 방을 설계. (class)
//[O] 2. 방 인스턴스 리스트를 채워봄.
//3. ListView.builder를 활용해서 위 리스트를 통해 위젯 리스트 만든다.
class HSLibraryPage extends StatefulWidget {
  MonitorUtil? monitorUtil;
  HSLibraryPage(this.monitorUtil);

  @override
  State<HSLibraryPage> createState() {
    return _HSLibraryPageState();
  }
}

//색의 의미.
//하나의 리스트타일당 상태값(3개중 1개)을 갖어야함.
//파란: 비어있을때 (클리가능 -> 예약 -> 초록)
//초록: 내가 예약했을때 (클릭 가능 -> 취소 -> 파랑)
//빨강: 남이 예약했을때 (클릭 불가능)
class _HSLibraryPageState extends State<HSLibraryPage> {
  late List<Period> periodList;
  Map<String, ReserveInfo> reserveInfoByRoomId = {};
  Period? selectedPeriod;

  DateTime today = DateTime.now();

  bool canReserve = true;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    (() async {
      await loadPeriodAndCurrentReserveInfo();
      selectedPeriod = periodList[0];
      setState(() {});

      if(FirebaseAuthUtil.isAdmin(context)){
        widget.monitorUtil?.run(periodList, loadPeriodAndCurrentReserveInfo);
      }
    })();

  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF001B44),
      ),
      body: Container(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              backgroundWidget(),
              foregroundWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget backgroundWidget() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget foregroundWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Library Rooms",
            style: TextStyle(
              color: Color(0xFF002F6D),
              fontSize: 50,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          if (selectedPeriod != null)
            ChoosePeriodWidget(selectedPeriod!, periodList,
                onChangePeriod: (period) async {
              selectedPeriod = period;
              await loadPeriodAndCurrentReserveInfo();
            }),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: myCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget myCard() {
    return Card(
      margin: const EdgeInsets.all(50),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: selectedPeriod?.roomList.length??0,
          itemBuilder: (c, i) {
            Room room = selectedPeriod!.roomList[i]; //룸을 1개 갖고온다.

            return Card(
              elevation: 10,
              child: ListTile(
                onTap: () {
                  //예약정보를 파이어스토어에 저장해야함.
                  ReserveInfo? reserveInfo = reserveInfoByRoomId[room.id];

                  if (FirebaseAuthUtil.isAdmin(context)) {
                    adminDialog(reserveInfo, room);
                  } else {
                    regularUserDialog(reserveInfo, room);
                  }
                },
                leading: Text(room.name),
                title: Text("${room.nOfSeat} Seats"),
                trailing: Container(
                    height: 50,
                    width: 30,
                    color: FirebaseAuthUtil.isAdmin(context)
                        ? adminColorByReserveInfo(reserveInfoByRoomId[room.id])
                        : regularColorByReserveInfo(
                            reserveInfoByRoomId[room.id])),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> loadPeriodAndCurrentReserveInfo() async {
    isLoaded = false;
    setState(() {});

    periodList = await PeriodRepository.getList('index', isNull: false);
    if (selectedPeriod == null && periodList.isNotEmpty){
      selectedPeriod = periodList[0];
    }

    reserveInfoByRoomId = await ReservationService.me.getReserveInfosByPeriod(selectedPeriod);


    canReserve = true;
    for (final reserveInfo in reserveInfoByRoomId.values) {
      if (reserveInfo.reservedEmail ==
          FirebaseAuthUtil.currentUser(context)?.email) {
        canReserve = false;
      }
    }

    isLoaded = true;
    setState(() {});
  }

  Color regularColorByReserveInfo(ReserveInfo? reserveInfo) {
    if (reserveInfo == null) {
      return Colors.blue;
    }

    if (reserveInfo.isReserved) {
      if (reserveInfo.reservedEmail ==
          FirebaseAuthUtil.currentUser(context)?.email) {
        return Colors.green;
      }

      return Colors.red;
    }

    return Colors.blue;
  }

  Color adminColorByReserveInfo(ReserveInfo? reserveInfo) {
    if (reserveInfo == null) {
      return Colors.blue;
    }

    if (reserveInfo.isReserved) {
      if (reserveInfo.isVerified) {
        return Colors.green;
      }
      return Colors.red;
    }

    return Colors.blue;
  }

  void regularUserDialog(
    ReserveInfo? reserveInfo,
    Room room,
  ) {
    if (!(reserveInfo?.isReserved ?? false) && canReserve) {
      reserveInfoByRoomId;
      MyAlertDialog.show(context, title: Text("Do you want to book this room?"),
          okWork: () async {
        isLoaded = false;
        setState(() {});

        await ReserveInfoRepository.create(ReserveInfo(
            room.id,
            FirebaseAuthUtil.currentUser(context)?.email,
            selectedPeriod!.index,
            true,
            today,
            false,
            DateTime.now(),
        ));

        isLoaded = true;
        setState(() {});

        loadPeriodAndCurrentReserveInfo();

        //예약 상태 (색)
        //안했다. !room.isReserved
        //했다.room.isReserved && 누구누구가 했다, 내가 했다

        //일단 예약 이미 되었는지 확인

        //안되었으면,
      });
    } else if (reserveInfo?.reservedEmail ==
        FirebaseAuthUtil.currentUser(context)?.email) {
      MyAlertDialog.show(context,
          title: Text("Do you want to unbook this room?"), okWork: () async {
        await ReserveInfoRepository.delete(documentId: reserveInfo!.documentId);
        await loadPeriodAndCurrentReserveInfo();
      });
    } else {
      InteractionUtil.showSnackbar(context, "You can not perform this action");
    }
  }

  void adminDialog(ReserveInfo? reserveInfo, Room room) {
    //이미 검증 |노 예약 | 예약 but no 검증
    if ((reserveInfo?.isReserved ?? false) && !reserveInfo!.isVerified) {
      reserveInfoByRoomId;
      MyAlertDialog.show(context,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Reserver: ${reserveInfo!.reservedEmail}"),
              Text("Is the reserver present?")
            ],
          ), okWork: () async {
        isLoaded = false;
        setState(() {});

        reserveInfo.isVerified = true;
        await ReserveInfoRepository.update(reserveInfo);

        isLoaded = true;
        setState(() {});

        loadPeriodAndCurrentReserveInfo();
        //예약 상태 (색)
        //안했다. !room.isReserved
        //안했다. !room.isReserved
        //했다.room.isReserved && 누구누구가 했다, 내가 했다

        //일단 예약 이미 되었는지 확인

        //안되었으면,
      });
    } else if (reserveInfo?.isVerified ?? false) {
      InteractionUtil.showSnackbar(context, "The reserver is already verified");
    } else {
      InteractionUtil.showSnackbar(context, "There is no reserver");
    }
  }
}
