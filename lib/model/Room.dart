import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Room {
  late String documentId;
  String id = Uuid().v4();
  String name;
  int nOfSeat;



  Room(this.name, this.nOfSeat);
  factory Room.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Room.fromJson(data);
  }

  factory Room.fromJson(Map<String, dynamic>? data) {
    final room = Room(
        data?['name'],
        data?['nOfSeat']
    )..id = data?['id'];

    if(data?['documentId'] != null ) {
      room.documentId=data?['documentId'];
    }

    return room;

  }


  Map<String, dynamic> toFirestore() {
    return {
      if (documentId != null) "documentId": documentId,
      if (id != null) "id": id,
      if (name != null) "name": name,
      if (nOfSeat != null) "nOfSeat": nOfSeat
    };
  }
}
