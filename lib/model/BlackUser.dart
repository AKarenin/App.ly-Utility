import 'package:cloud_firestore/cloud_firestore.dart';

class BlackUser{
  late String documentId;
  String blackedUserEmail;
  DateTime blackedTime;

  BlackUser(this.blackedUserEmail, this.blackedTime);

  factory BlackUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();

    final blackUser = BlackUser(
      data?['blackedUserEmail'],
      DateTime.parse(data?['blackedTime']),
    );

    if(data?['documentId'] != null ) {
      blackUser.documentId=data?['documentId'];
    }

    return blackUser;
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (documentId != null) "documentId": documentId,
      if (blackedUserEmail != null) "blackedUserEmail": blackedUserEmail,
      if (blackedTime != null) "blackedTime": blackedTime.toIso8601String(),
    };
  }
}