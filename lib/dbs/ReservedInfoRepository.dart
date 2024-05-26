import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schoolappfinal/model/Period.dart';

import '../model/ReservedInfo.dart';

class ReservedInfoRepository {
  static const collectionName = "ReservedInfo";

  //DB 접근하기
  static FirebaseFirestore _db() => FirebaseFirestore.instance;

  //ReservedInfo Collection 접근하기
  static CollectionReference<ReservedInfo> _cRef() =>
      _db().collection(collectionName).withConverter(
            fromFirestore: (snapshot,snapshotOption)=>ReservedInfo.fromJson(snapshot.data()!),
            toFirestore: (ReservedInfo reserveInfo, options) =>
                reserveInfo.toJson(),
          );

  static DocumentReference<ReservedInfo> _dRef([String? documentId]) =>
      _cRef().doc(documentId);

  static Future<void> create(ReservedInfo reserveInfo,
      {String? documentId, SetOptions? options}) async {
    DocumentReference<ReservedInfo> dRef = _dRef(documentId);
    final _documentId = dRef.id;
    reserveInfo.documentId = _documentId;
    await dRef.set(reserveInfo, options);
  }
  static Future<void> update(ReservedInfo reserveInfo, {SetOptions? options}) async {
    DocumentReference<ReservedInfo> dRef = _dRef(reserveInfo.documentId);
    await dRef.set(reserveInfo, options);
  }

  static Future<void> delete({required String documentId}) async {
    await _dRef(documentId).delete();
  }

  static Future<ReservedInfo?> get({String? documentId}) async {
    DocumentSnapshot<ReservedInfo> reserveInfoSnapshot =
        await _dRef(documentId).get();
    ReservedInfo? reserveInfo = reserveInfoSnapshot.data();
    return reserveInfo;
  }

  static Query<ReservedInfo> where(
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

  static Future<List<ReservedInfo>> getList(
    Query<ReservedInfo> query,
  ) async {
    QuerySnapshot<ReservedInfo> querySnapshot = await query.get();

    //queryDocumentSnapshotList는 Query를 통해 얻은 QueryDocumentSnapshot의 List이다.
    List<QueryDocumentSnapshot<ReservedInfo>> queryDocumentSnapshotList =
        querySnapshot.docs;
    //queryDocumentSnapshotList -> reserveInfoList로 변환 필요
    List<ReservedInfo> reserveInfoList =
        queryDocumentSnapshotList.map((e) => e.data()).toList();

    return reserveInfoList;
  }

  static Future<StreamSubscription<DocumentSnapshot<ReservedInfo>>> docListen(
      DocumentReference<ReservedInfo> doc,
      void Function(DocumentSnapshot<ReservedInfo> event) onListen) async {
    return doc.snapshots().listen(onListen); //1개(ReservedInfo)
  }

  static Future<StreamSubscription<QuerySnapshot<ReservedInfo>>> queryListen(
      Query<ReservedInfo> query,
      void Function(QuerySnapshot<ReservedInfo> event) onListen) async {
    return query.snapshots().listen(onListen); //n개(List(ReservedInfo))
  }
}
