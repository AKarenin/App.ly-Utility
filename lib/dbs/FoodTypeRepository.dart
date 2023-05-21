import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schoolappfinal/model/Period.dart';

import '../model/FoodType.dart';

class FoodTypeRepository {
  static const collectionName = "FoodType";

  //DB 접근하기
  static FirebaseFirestore _db() => FirebaseFirestore.instance;

  //FoodType Collection 접근하기
  static CollectionReference<FoodType> _cRef() =>
      _db().collection(collectionName).withConverter(
            fromFirestore: FoodType.fromFirestore,
            toFirestore: (FoodType foodType, options) =>
                foodType.toFirestore(),
          );

  static DocumentReference<FoodType> _dRef([String? documentId]) =>
      _cRef().doc(documentId);

  static Future<void> create(FoodType foodType,
      {String? documentId, SetOptions? options}) async {
    DocumentReference<FoodType> dRef = _dRef(documentId);
    final _documentId = dRef.id;
    foodType.documentId = _documentId;
    await dRef.set(foodType, options);
  }
  static Future<void> update(FoodType foodType, {SetOptions? options}) async {
    DocumentReference<FoodType> dRef = _dRef(foodType.documentId);
    await dRef.set(foodType, options);
  }

  static Future<void> delete({required String documentId}) async {
    await _dRef(documentId).delete();
  }

  static Future<FoodType?> get({String? documentId}) async {
    DocumentSnapshot<FoodType> foodTypeSnapshot =
        await _dRef(documentId).get();
    FoodType? foodType = foodTypeSnapshot.data();
    return foodType;
  }

  static Query<FoodType> orderBy(Object field, {bool descending = false}) {
    return _cRef().orderBy(
      field,
      descending: descending,
    );
  }

  static Query<FoodType> where(
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

  static Future<List<FoodType>> getList(
    Query<FoodType> query,
  ) async {
    QuerySnapshot<FoodType> querySnapshot = await query.get();

    //queryDocumentSnapshotList는 Query를 통해 얻은 QueryDocumentSnapshot의 List이다.
    List<QueryDocumentSnapshot<FoodType>> queryDocumentSnapshotList =
        querySnapshot.docs;
    //queryDocumentSnapshotList -> foodTypeList로 변환 필요
    List<FoodType> foodTypeList =
        queryDocumentSnapshotList.map((e) => e.data()).toList();

    return foodTypeList;
  }
}
