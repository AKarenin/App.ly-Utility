import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schoolappfinal/model/Period.dart';

class PeriodRepository {
  static const collectionName = "Period";

  //DB 접근하기
  static FirebaseFirestore _db() => FirebaseFirestore.instance;

  //Period Collection 접근하기
  static CollectionReference<Period> _cRef() =>
      _db().collection(collectionName).withConverter(
        fromFirestore: Period.fromFirestore,
        toFirestore: (Period period, options) => period.toFirestore(),
      );

  static DocumentReference<Period> _dRef([String? documentId]) =>
      _cRef().doc(documentId);


  static Future<void> save(Period period,
      {String? documentId, SetOptions? options}) async {
    DocumentReference<Period> dRef = _dRef(documentId);
    final _documentId = dRef.id;
    period.documentId = _documentId;
    await dRef.set(period, options);
  }

  static Future<void> delete({required String documentId}) async {
    await _dRef(documentId).delete();
  }

  static Future<Period?> get({String? documentId}) async {
    DocumentSnapshot<Period> periodSnapshot = await _dRef(documentId).get();
    Period? period = periodSnapshot.data();
    return period;
  }

  static Future<List<Period>> getList(
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
      }) async {
    Query<Period> query = _cRef().where(
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
    QuerySnapshot<Period> querySnapshot = await query.get();

    //queryDocumentSnapshotList는 Query를 통해 얻은 QueryDocumentSnapshot의 List이다.
    List<QueryDocumentSnapshot<Period>> queryDocumentSnapshotList =
        querySnapshot.docs;
    //queryDocumentSnapshotList -> periodList로 변환 필요
    List<Period> periodList =
    queryDocumentSnapshotList.map((e) => e.data()).toList();

    return periodList;
  }
}