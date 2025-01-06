import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schoolappfinal/dbs/PeriodRepository.dart';
import 'package:schoolappfinal/dbs/ReservedInfoRepository.dart';
import 'package:schoolappfinal/model/Period.dart';
import 'package:schoolappfinal/model/ReservedInfo.dart';
import 'package:schoolappfinal/model/Room.dart';
import 'package:schoolappfinal/screens/widgets/ChoosePeriodWidget.dart';
import 'package:schoolappfinal/screens/widgets/MyAlertDialog.dart';
import 'package:schoolappfinal/services/ReservationService.dart';
import 'package:schoolappfinal/util/FirebaseAuthUtil.dart';
import 'package:schoolappfinal/util/InteractionUtil.dart';
import '../../../util/PublicMonitorUtil.dart';

//[O] 1. 방을 설계. (class)
//[O] 2. 방 인스턴스 리스트를 채워봄.
//3. ListView.builder를 활용해서 위 리스트를 통해 위젯 리스트 만든다.
class HSLibraryPage extends StatefulWidget {
  PublicMonitorUtil? monitorUtil;

  HSLibraryPage(this.monitorUtil);

  @override
  State<HSLibraryPage> createState() {
    return _HSLibraryPageState();
  }
}

class _HSLibraryPageState extends State<HSLibraryPage> {
  late List<Period> periodList;
  Map<String, ReservedInfo> reserveInfoByRoomId = {};
  Period? selectedPeriod;

  DateTime today = DateTime.now();

  bool canReserve = true;
  bool isLoaded = false;

  StreamSubscription<QuerySnapshot<ReservedInfo>>? subscription;

  //페이지 시작할때 실행하는 함수.
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadPeriodAndCurrentReservedInfo();
      selectedPeriod = periodList[0];
      try{
        setState(() {});
      }
      catch(ignored){

      }

      if (FirebaseAuthUtil.isPublic(context)) {
        widget.monitorUtil?.run(periodList, loadPeriodAndCurrentReservedInfo);
      }

      //구독할게(파이어스토어한테, 나 서버의 변경사항에 관심 있어.)
      final query = ReservedInfoRepository.where('roomDate', isEqualTo: DateUtils.dateOnly(DateTime.now()).toIso8601String());
      // final snapshot = await query.get();
      // final reserveInfoList = snapshot.docs.map((e) => e.data()).toList();
      // print('reserveInfoList : $reserveInfoList');
      subscription = await ReservedInfoRepository.queryListen(query, (event) {
        // for(final documentChange in event.docChanges) {
        //   final reserveInfo = documentChange.doc.data();
        //   if(reserveInfo == null) continue;
        //   if(selectedPeriod == null) continue;
        //   if(reserveInfo.periodIndex!=selectedPeriod!.index) continue;
        //
        //   print('query');
        //
        //   final changeType = documentChange.type;
        //   if(changeType==DocumentChangeType.added || changeType==DocumentChangeType.modified) {
        //     reserveInfoByRoomId[reserveInfo.roomId] = reserveInfo;
        //   }
        //   else if(changeType==DocumentChangeType.removed) {
        //     reserveInfoByRoomId.remove(reserveInfo.roomId);
        //   }
        // }
        // setState(() { });
        loadPeriodAndCurrentReservedInfo();
      });
    });
  }

  //페이지 끝날때 실행하는 함수
  @override
  void dispose() {
    super.dispose();
    //구독해제할게(나 서버에 관심 없어.)
    subscription?.cancel();
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

  ///ui
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
              await loadPeriodAndCurrentReservedInfo();
            }),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: myCard(context),
            ),
          ),
        ],
      ),
    );
  }
  Widget myCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(50),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: selectedPeriod?.roomList.length ?? 0,
          itemBuilder: (c, i) {
            Room room = selectedPeriod!.roomList[i]; //룸을 1개 갖고온다.

            final reserveInfo = reserveInfoByRoomId[room.id];

            final status = reserveInfo?.reserveStatus;

            var color = regularColorByReservedInfo(reserveInfo);
            if(FirebaseAuthUtil.isAdmin(context)){
              color = adminColorByReservedInfo(reserveInfo);
            }else if(FirebaseAuthUtil.isPublic(context)){
              color = publicColorByReservedInfo(reserveInfo);
            }

            return Card(
              elevation: 10,
              child: ListTile(
                onTap: () {
                  //예약정보를 파이어스토어에 저장해야함.
                  if (FirebaseAuthUtil.isAdmin(context)) {
                    showAdminDialog(reserveInfo, room);
                  } else if(FirebaseAuthUtil.isPublic(context)) {
                    showPublicDialog(reserveInfo, room);
                  }else {
                    showRegularUserDialog(context, reserveInfo, room);
                  }
                },
                onLongPress: () {
                  if (FirebaseAuthUtil.isAdmin(context)) {
                    showAdminLongDialog(reserveInfo, room);
                  }
                },
                //bool ? value(when true) : value(when false)
                leading: Text(
                  room.name,
                  style: TextStyle(
                      decoration: status == ReserveStatus.CLOSED
                          ? TextDecoration.lineThrough
                          : null),
                ),
                title: Text("${room.nOfSeat} Seats", style: TextStyle(
                    decoration: status == ReserveStatus.CLOSED
                        ? TextDecoration.lineThrough
                        : null),),
                trailing: Container(
                    height: 50,
                    width: 30,
                    color: color,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> loadPeriodAndCurrentReservedInfo() async {
    isLoaded = false;
    setState(() {});

    periodList = await PeriodRepository.getList('index', isNull: false);
    if (selectedPeriod == null && periodList.isNotEmpty) {
      selectedPeriod = periodList[0];
    }

    print('load');

    reserveInfoByRoomId =
    await ReservationService.me.getReserveInfosByPeriod(selectedPeriod);

    canReserve = true;
    for (final reserveInfo in reserveInfoByRoomId.values) {
      if (reserveInfo.reservedEmail ==
          FirebaseAuthUtil.currentUser(context)?.email) {
        canReserve = false;
      }
    }

    isLoaded = true;
    try{
      setState(() {});
    }
    catch(ignored){

    }
  }
  void setClosedByAdmin(ReservedInfo? reserveInfo) async {
    if (reserveInfo == null) return;

    isLoaded = false;
    setState(() {});

    reserveInfo.reserveStatus = ReserveStatus.CLOSED;
    await ReservedInfoRepository.update(reserveInfo);

    isLoaded = true;
    setState(() {});

    loadPeriodAndCurrentReservedInfo();
    //예약 상태 (색)
    //안했다. !room.isReserved
    //안했다. !room.isReserved
    //했다.room.isReserved && 누구누구가 했다, 내가 했다

    //일단 예약 이미 되었는지 확인

    //안되었으면,
  }
  void setVerified(ReservedInfo reserveInfo)async{

    isLoaded = false;
    setState(() {});

    reserveInfo.reserveStatus = ReserveStatus.VERIFIED;
    await ReservedInfoRepository.update(reserveInfo);

    isLoaded = true;
    setState(() {});

    loadPeriodAndCurrentReservedInfo();
    //예약 상태 (색)
    //안했다. !room.isReserved
    //안했다. !room.isReserved
    //했다.room.isReserved && 누구누구가 했다, 내가 했다

    //일단 예약 이미 되었는지 확인

    //안되었으면,
  }
  Future<ReservedInfo> setRequest(String email, Room room, ReservedInfo? reserveInfo) async{
    isLoaded = false;
    setState(() {});


    if(reserveInfo == null){
      reserveInfo = ReservedInfo(
        roomId:room.id,
        reservedEmail:email,
        periodIndex: selectedPeriod!.index,
        roomDate: DateUtils.dateOnly(DateTime.now()),
        reserveStatus: ReserveStatus.REQUEST,
        reservedTime: today,
      );
      await ReservedInfoRepository.create(reserveInfo);
    }
    else{
      reserveInfo.reserveStatus = ReserveStatus.REQUEST;
      reserveInfo.reservedEmail = email;
      reserveInfo.reservedTime = today;
      await ReservedInfoRepository.update(reserveInfo);
    }


    isLoaded = true;
    setState(() {});

    loadPeriodAndCurrentReservedInfo();
    return reserveInfo;

    //예약 상태 (색)
    //안했다. !room.isReserved
    //했다.room.isReserved && 누구누구가 했다, 내가 했다

    //일단 예약 이미 되었는지 확인

    //안되었으면,
  }
  Future<void> deleteReservation(ReservedInfo reserveInfo) async {
    await ReservedInfoRepository.delete(documentId: reserveInfo.documentId!);
    await loadPeriodAndCurrentReservedInfo();
  }

  ///color
  Color regularColorByReservedInfo(ReservedInfo? reserveInfo) {
    bool isMe = reserveInfo?.reservedEmail == FirebaseAuthUtil.currentUser(context)?.email;
    if(reserveInfo?.reserveStatus == ReserveStatus.VACANT){
      return Colors.blue;
    }
    if(reserveInfo?.reserveStatus == ReserveStatus.REQUEST){
      return isMe?Colors.yellow:Colors.red;
    }
    if(reserveInfo?.reserveStatus == ReserveStatus.VERIFIED){
      return isMe?Colors.green:Colors.red;
    }
    if(reserveInfo?.reserveStatus == ReserveStatus.ELAPSED){
      return isMe?Colors.yellow:Colors.pink;
    }
    if(reserveInfo?.reserveStatus == ReserveStatus.CLOSED){
      return Colors.white;
    }
    return Colors.blue;
  }
  Color publicColorByReservedInfo(ReservedInfo? reserveInfo) {
    if(reserveInfo?.reserveStatus == ReserveStatus.VACANT){
      return Colors.blue;
    }
    if(reserveInfo?.reserveStatus == ReserveStatus.REQUEST){
      return Colors.yellow;
    }
    if(reserveInfo?.reserveStatus == ReserveStatus.VERIFIED){
      return Colors.red;
    }

    if(reserveInfo?.reserveStatus == ReserveStatus.ELAPSED){
      return Colors.blue;
    }
    if(reserveInfo?.reserveStatus == ReserveStatus.CLOSED){
      return Colors.white;
    }
    return Colors.blue;
  }
  Color adminColorByReservedInfo(ReservedInfo? reserveInfo) {
    // if (reserveInfo == null) {
    //   return Colors.blue;
    // }
    //
    // if (reserveInfo.isClosed == true) {
    //   return Colors.white;
    // }
    //
    // if (reserveInfo.isReserved) {
    //   if (reserveInfo.isVerified) {
    //     return Colors.green;
    //   }
    //   return Colors.red;
    // }
    //
    // return Colors.blue;
    print('reserveInfo: ${reserveInfo}');
    print('reserveInfoByRoomId: ${reserveInfoByRoomId}');
    if(reserveInfo?.reserveStatus == ReserveStatus.VACANT){
      return Colors.blue;
    }
    if(reserveInfo?.reserveStatus == ReserveStatus.REQUEST){
      return Colors.red;
    }
    if(reserveInfo?.reserveStatus == ReserveStatus.VERIFIED){
      return Colors.green;
    }
    if(reserveInfo?.reserveStatus == ReserveStatus.ELAPSED){
      return Colors.red;
    }
    if(reserveInfo?.reserveStatus == ReserveStatus.CLOSED){
      return Colors.white;
    }
    return Colors.blue;
  }

  ///dialog
  void showAdminDialog(ReservedInfo? reserveInfo, Room room) {
    //이미 검증 |노 예약 | 예약 but no 검증
    if (reserveInfo?.reserveStatus == ReserveStatus.CLOSED) {
      MyAlertDialog.show(context,
          title: const Text("Do you want to unclose this room?"), okWork: () async {
            deleteReservation(reserveInfo!);
          });
    } else if (reserveInfo?.reserveStatus == ReserveStatus.REQUEST || reserveInfo?.reserveStatus == ReserveStatus.ELAPSED) {
      MyAlertDialog.show(context,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Reserver: ${reserveInfo!.reservedEmail}"),
              const Text("Is the reserver present?")
            ],
          ), okWork: () async {
            setVerified(reserveInfo);
          });
    } else if (reserveInfo?.reserveStatus == ReserveStatus.VERIFIED) {
      MyAlertDialog.show(context,
          title: const Text("Do you want to unreserve this room?"),
          okWork: () async {
            deleteReservation(reserveInfo!);
          });
    } else {
      InteractionUtil.showSnackbar(context, "There is no reserver");
    }
  }
  void showAdminLongDialog(ReservedInfo? reserveInfo, Room room) {
    MyAlertDialog.show(context, title: const Text("Close this room?"),
        okWork: () async {
          if (reserveInfo == null) {
            reserveInfo = ReservedInfo(
              roomId: room.id,
              reservedEmail: FirebaseAuthUtil.currentUser(context)?.email,
              periodIndex: selectedPeriod!.index,
              roomDate: DateUtils.dateOnly(today),
              reservedTime: DateTime.now(),
              reserveStatus: ReserveStatus.CLOSED,
            );
            await ReservedInfoRepository.create(reserveInfo!);
          }

          setClosedByAdmin(reserveInfo);
        });
  }
  void showPublicDialog(ReservedInfo? reserveInfo, Room room) {
    //ELAPSED, //예약요청됨+5분지남
    //CANCEL_TRY, //예약취소요청됨
    //이미 검증 |노 예약 | 예약 but no 검증
    if (reserveInfo?.reserveStatus == ReserveStatus.CLOSED) {
      InteractionUtil.showSnackbar(context, "This room is closed");
    } else if (reserveInfo?.reserveStatus == ReserveStatus.REQUEST) {
      MyAlertDialog.show(context,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Reserver: ${reserveInfo!.reservedEmail}"),
              const Text("Are you the reserver?")
            ],
          ), okWork: () async {
            setVerified(reserveInfo);
          });
    } else if (reserveInfo?.reserveStatus == ReserveStatus.VERIFIED) {
      MyAlertDialog.show(context,
          title: Text("Reserver: ${reserveInfo!.reservedEmail} Do you want to unbook this room?"),
          okWork: () async {
            deleteReservation(reserveInfo!);
          });
    } else if (reserveInfo == null || reserveInfo.reserveStatus == ReserveStatus.VACANT || reserveInfo.reserveStatus == ReserveStatus.ELAPSED){
      final emailController = TextEditingController();
      MyAlertDialog.show(context,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Name of Reserver"),
              Row(
                children: [
                  Expanded(child: TextField(controller: emailController,)),
                  const Text("@seoulforeign.org")
                ],
              ),
            ],
          ), okWork: () async {
            final localReserveInfo = await setRequest(emailController.text+"@seoulforeign.org", room, reserveInfo);
            setVerified(localReserveInfo);
          });
    }
  }
  void showRegularUserDialog(
      BuildContext context,
      ReservedInfo? reserveInfo,
      Room room,
      ) {
    ReserveStatus? status = reserveInfo?.reserveStatus;

    String currentEmail = FirebaseAuthUtil.currentUser(context)?.email??'';

    if (status == ReserveStatus.CLOSED) {
      InteractionUtil.showSnackbar(context, "This room is  closed");
    }
    else if(status == ReserveStatus.VERIFIED) {
      if(reserveInfo!.reservedEmail == currentEmail)
        MyAlertDialog.show(context,
            title: const Text("Do you want to unbook this room?"),
            okWork: () async {
              deleteReservation(reserveInfo);
            });
      else{
        InteractionUtil.showSnackbar(context, "This room is already booked");
      }
    }
    else if (status == null || status == ReserveStatus.VACANT) {
      if(!canReserve) {
        InteractionUtil.showSnackbar(context, "You can not perform this action");
        return;
      }

      final now = DateTime.now();
      //해당 방에 점유 시작 시간. - 5분. => 기준 시간
      //기준 시간을 현재시간이 넘었니?
      final timeOfDay = selectedPeriod!.startTime;
      final startDateTime = now.copyWith(
        hour: timeOfDay.hour,
        minute: timeOfDay.minute,
        second: 0,
      );
      final standardDateTime =
      startDateTime.subtract(const Duration(minutes: 5));
      if (!standardDateTime.isBefore(now)) {
        InteractionUtil.showSnackbar(
            context, "Please wait until 5 minutes before the period to book.");
        return;
      }

      MyAlertDialog.show(context,
          title: const Text("Do you want to book this room?"),
          okWork: () async {
            setRequest(currentEmail, room, reserveInfo);
          });
    } else if (status == ReserveStatus.REQUEST || status == ReserveStatus.ELAPSED) {
      if(reserveInfo!.reservedEmail == currentEmail) {
        MyAlertDialog.show(context,
            title: const Text("Do you want to unbook this room?"),
            okWork: () async {
              deleteReservation(reserveInfo);
            });
      }
      else{
        InteractionUtil.showSnackbar(context, "This room is already booked");
      }
    }
  }

}
