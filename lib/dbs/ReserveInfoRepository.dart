import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schoolappfinal/model/Period.dart';

import '../model/ReserveInfo.dart';

class ReserveInfoRepository {
  static const collectionName = "ReserveInfo";

  //DB 접근하기
  static FirebaseFirestore _db() => FirebaseFirestore.instance;

  //ReserveInfo Collection 접근하기
  static CollectionReference<ReserveInfo> _cRef() =>
      _db().collection(collectionName).withConverter(
            fromFirestore: ReserveInfo.fromFirestore,
            toFirestore: (ReserveInfo reserveInfo, options) =>
                reserveInfo.toFirestore(),
          );

  static DocumentReference<ReserveInfo> _dRef([String? documentId]) =>
      _cRef().doc(documentId);

  static Future<void> create(ReserveInfo reserveInfo,
      {String? documentId, SetOptions? options}) async {
    DocumentReference<ReserveInfo> dRef = _dRef(documentId);
    final _documentId = dRef.id;
    reserveInfo.documentId = _documentId;
    await dRef.set(reserveInfo, options);
  }
  static Future<void> update(ReserveInfo reserveInfo, {SetOptions? options}) async {
    DocumentReference<ReserveInfo> dRef = _dRef(reserveInfo.documentId);
    await dRef.set(reserveInfo, options);
  }

  static Future<void> delete({required String documentId}) async {
    await _dRef(documentId).delete();
  }

  static Future<ReserveInfo?> get({String? documentId}) async {
    DocumentSnapshot<ReserveInfo> reserveInfoSnapshot =
        await _dRef(documentId).get();
    ReserveInfo? reserveInfo = reserveInfoSnapshot.data();
    return reserveInfo;
  }

  static Query<ReserveInfo> where(
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

  static Future<List<ReserveInfo>> getList(
    Query<ReserveInfo> query,
  ) async {
    QuerySnapshot<ReserveInfo> querySnapshot = await query.get();

    //queryDocumentSnapshotList는 Query를 통해 얻은 QueryDocumentSnapshot의 List이다.
    List<QueryDocumentSnapshot<ReserveInfo>> queryDocumentSnapshotList =
        querySnapshot.docs;
    //queryDocumentSnapshotList -> reserveInfoList로 변환 필요
    List<ReserveInfo> reserveInfoList =
        queryDocumentSnapshotList.map((e) => e.data()).toList();

    return reserveInfoList;
  }

  static Future<StreamSubscription<DocumentSnapshot<ReserveInfo>>> docListen(
      DocumentReference<ReserveInfo> doc,
      void Function(DocumentSnapshot<ReserveInfo> event) onListen) async {
    return doc.snapshots().listen(onListen); //1개(ReserveInfo)
  }

  static Future<StreamSubscription<QuerySnapshot<ReserveInfo>>> queryListen(
      Query<ReserveInfo> query,
      void Function(QuerySnapshot<ReserveInfo> event) onListen) async {
    return query.snapshots().listen(onListen); //n개(List(ReserveInfo))
  }
}
