// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReservedInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReservedInfoImpl _$$ReservedInfoImplFromJson(Map<String, dynamic> json) =>
    _$ReservedInfoImpl(
      documentId: json['documentId'] as String?,
      roomId: json['roomId'] as String,
      periodIndex: (json['periodIndex'] as num).toInt(),
      roomDate: DateTime.parse(json['roomDate'] as String),
      reservedEmail: json['reservedEmail'] as String?,
      reservedTime: DateTime.parse(json['reservedTime'] as String),
      reserveStatus: $enumDecode(_$ReserveStatusEnumMap, json['reserveStatus']),
    );

Map<String, dynamic> _$$ReservedInfoImplToJson(_$ReservedInfoImpl instance) =>
    <String, dynamic>{
      'documentId': instance.documentId,
      'roomId': instance.roomId,
      'periodIndex': instance.periodIndex,
      'roomDate': instance.roomDate.toIso8601String(),
      'reservedEmail': instance.reservedEmail,
      'reservedTime': instance.reservedTime.toIso8601String(),
      'reserveStatus': _$ReserveStatusEnumMap[instance.reserveStatus]!,
    };

const _$ReserveStatusEnumMap = {
  ReserveStatus.VACANT: 'VACANT',
  ReserveStatus.REQUEST: 'REQUEST',
  ReserveStatus.VERIFIED: 'VERIFIED',
  ReserveStatus.ELAPSED: 'ELAPSED',
  ReserveStatus.CLOSED: 'CLOSED',
};
