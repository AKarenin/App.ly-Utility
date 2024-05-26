import 'package:freezed_annotation/freezed_annotation.dart';
part 'ReservedInfo.freezed.dart';
part 'ReservedInfo.g.dart';

enum ReserveStatus{
  VACANT, //예약가능함
  REQUEST, //예약요청됨
  VERIFIED, //예약승인됨
  ELAPSED, //예약요청됨+5분지남
  CLOSED, //방닫음
}

@unfreezed
class ReservedInfo with _$ReservedInfo {
  factory ReservedInfo({
    String? documentId,
    required String roomId,
    required int periodIndex,
    required  DateTime roomDate,
    String? reservedEmail,
    required DateTime reservedTime,
    required ReserveStatus reserveStatus,
  }) = _ReservedInfo;

  factory ReservedInfo.fromJson(Map<String, Object?> json)
  => _$ReservedInfoFromJson(json);

  //fromJson, toJson
}