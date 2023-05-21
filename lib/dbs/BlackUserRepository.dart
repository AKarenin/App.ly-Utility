import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schoolappfinal/model/Period.dart';

import '../model/BlackUser.dart';
import '../model/ReserveInfo.dart';

class BlackUserRepository {
  static const collectionName = "BlackUser";

  //DB 접근하기
  static FirebaseFirestore _db() => FirebaseFirestore.instance;

  //BlackUser Collection 접근하기
  static CollectionReference<BlackUser> _cRef() =>
      _db().collection(collectionName).withConverter(
            fromFirestore: BlackUser.fromFirestore,
            toFirestore: (BlackUser blackUser, options) =>
                blackUser.toFirestore(),
          );

  static DocumentReference<BlackUser> _dRef([String? documentId]) =>
      _cRef().doc(documentId);

  static Future<void> create(BlackUser blackUser,
      {String? documentId, SetOptions? options}) async {
    DocumentReference<BlackUser> dRef = _dRef(documentId);
    final _documentId = dRef.id;
    blackUser.documentId = _documentId;
    await dRef.set(blackUser, options);
  }
  static Future<void> update(BlackUser blackUser, {SetOptions? options}) async {
    DocumentReference<BlackUser> dRef = _dRef(blackUser.documentId);
    await dRef.set(blackUser, options);
  }

  static Future<void> delete({required String documentId}) async {
    await _dRef(documentId).delete();
  }

  static Future<BlackUser?> get({String? documentId}) async {
    DocumentSnapshot<BlackUser> blackUserSnapshot =
        await _dRef(documentId).get();
    BlackUser? blackUser = blackUserSnapshot.data();
    return blackUser;
  }

  static Query<BlackUser> where(
    Object field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
  }) {
    return _cRef().where(
      field,
      isEqualTo: isEqualTo,
      isNotEqualTo: isNotEqualTo,
      isLessThan: isLessThan,
      isLessThanOrEqualTo: isLessThanOrEqualTo,
      isGreaterThan: isGreaterThan,
      isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
      arrayContains: arrayContains,
      arrayContainsAny: arrayContainsAny,
      whereIn: whereIn,
      whereNotIn: whereNotIn,
      isNull: isNull,
    );
  }

  static Future<List<BlackUser>> getList(
    Query<BlackUser> query,
  ) async {
    QuerySnapshot<BlackUser> querySnapshot = await query.get();

    //queryDocumentSnapshotList는 Query를 통해 얻은 QueryDocumentSnapshot의 List이다.
    List<QueryDocumentSnapshot<BlackUser>> queryDocumentSnapshotList =
        querySnapshot.docs;
    //queryDocumentSnapshotList -> blackUserList로 변환 필요
    List<BlackUser> blackUserList =
        queryDocumentSnapshotList.map((e) => e.data()).toList();

    return blackUserList;
  }
}
