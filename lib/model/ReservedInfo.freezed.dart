// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ReservedInfo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReservedInfo _$ReservedInfoFromJson(Map<String, dynamic> json) {
  return _ReservedInfo.fromJson(json);
}

/// @nodoc
mixin _$ReservedInfo {
  String? get documentId => throw _privateConstructorUsedError;
  set documentId(String? value) => throw _privateConstructorUsedError;
  String get roomId => throw _privateConstructorUsedError;
  set roomId(String value) => throw _privateConstructorUsedError;
  int get periodIndex => throw _privateConstructorUsedError;
  set periodIndex(int value) => throw _privateConstructorUsedError;
  DateTime get roomDate => throw _privateConstructorUsedError;
  set roomDate(DateTime value) => throw _privateConstructorUsedError;
  String? get reservedEmail => throw _privateConstructorUsedError;
  set reservedEmail(String? value) => throw _privateConstructorUsedError;
  DateTime get reservedTime => throw _privateConstructorUsedError;
  set reservedTime(DateTime value) => throw _privateConstructorUsedError;
  ReserveStatus get reserveStatus => throw _privateConstructorUsedError;
  set reserveStatus(ReserveStatus value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReservedInfoCopyWith<ReservedInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservedInfoCopyWith<$Res> {
  factory $ReservedInfoCopyWith(
          ReservedInfo value, $Res Function(ReservedInfo) then) =
      _$ReservedInfoCopyWithImpl<$Res, ReservedInfo>;
  @useResult
  $Res call(
      {String? documentId,
      String roomId,
      int periodIndex,
      DateTime roomDate,
      String? reservedEmail,
      DateTime reservedTime,
      ReserveStatus reserveStatus});
}

/// @nodoc
class _$ReservedInfoCopyWithImpl<$Res, $Val extends ReservedInfo>
    implements $ReservedInfoCopyWith<$Res> {
  _$ReservedInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentId = freezed,
    Object? roomId = null,
    Object? periodIndex = null,
    Object? roomDate = null,
    Object? reservedEmail = freezed,
    Object? reservedTime = null,
    Object? reserveStatus = null,
  }) {
    return _then(_value.copyWith(
      documentId: freezed == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String?,
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      periodIndex: null == periodIndex
          ? _value.periodIndex
          : periodIndex // ignore: cast_nullable_to_non_nullable
              as int,
      roomDate: null == roomDate
          ? _value.roomDate
          : roomDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reservedEmail: freezed == reservedEmail
          ? _value.reservedEmail
          : reservedEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      reservedTime: null == reservedTime
          ? _value.reservedTime
          : reservedTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reserveStatus: null == reserveStatus
          ? _value.reserveStatus
          : reserveStatus // ignore: cast_nullable_to_non_nullable
              as ReserveStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReservedInfoImplCopyWith<$Res>
    implements $ReservedInfoCopyWith<$Res> {
  factory _$$ReservedInfoImplCopyWith(
          _$ReservedInfoImpl value, $Res Function(_$ReservedInfoImpl) then) =
      __$$ReservedInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? documentId,
      String roomId,
      int periodIndex,
      DateTime roomDate,
      String? reservedEmail,
      DateTime reservedTime,
      ReserveStatus reserveStatus});
}

/// @nodoc
class __$$ReservedInfoImplCopyWithImpl<$Res>
    extends _$ReservedInfoCopyWithImpl<$Res, _$ReservedInfoImpl>
    implements _$$ReservedInfoImplCopyWith<$Res> {
  __$$ReservedInfoImplCopyWithImpl(
      _$ReservedInfoImpl _value, $Res Function(_$ReservedInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentId = freezed,
    Object? roomId = null,
    Object? periodIndex = null,
    Object? roomDate = null,
    Object? reservedEmail = freezed,
    Object? reservedTime = null,
    Object? reserveStatus = null,
  }) {
    return _then(_$ReservedInfoImpl(
      documentId: freezed == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String?,
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      periodIndex: null == periodIndex
          ? _value.periodIndex
          : periodIndex // ignore: cast_nullable_to_non_nullable
              as int,
      roomDate: null == roomDate
          ? _value.roomDate
          : roomDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reservedEmail: freezed == reservedEmail
          ? _value.reservedEmail
          : reservedEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      reservedTime: null == reservedTime
          ? _value.reservedTime
          : reservedTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reserveStatus: null == reserveStatus
          ? _value.reserveStatus
          : reserveStatus // ignore: cast_nullable_to_non_nullable
              as ReserveStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReservedInfoImpl implements _ReservedInfo {
  _$ReservedInfoImpl(
      {this.documentId,
      required this.roomId,
      required this.periodIndex,
      required this.roomDate,
      this.reservedEmail,
      required this.reservedTime,
      required this.reserveStatus});

  factory _$ReservedInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReservedInfoImplFromJson(json);

  @override
  String? documentId;
  @override
  String roomId;
  @override
  int periodIndex;
  @override
  DateTime roomDate;
  @override
  String? reservedEmail;
  @override
  DateTime reservedTime;
  @override
  ReserveStatus reserveStatus;

  @override
  String toString() {
    return 'ReservedInfo(documentId: $documentId, roomId: $roomId, periodIndex: $periodIndex, roomDate: $roomDate, reservedEmail: $reservedEmail, reservedTime: $reservedTime, reserveStatus: $reserveStatus)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservedInfoImplCopyWith<_$ReservedInfoImpl> get copyWith =>
      __$$ReservedInfoImplCopyWithImpl<_$ReservedInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReservedInfoImplToJson(
      this,
    );
  }
}

abstract class _ReservedInfo implements ReservedInfo {
  factory _ReservedInfo(
      {String? documentId,
      required String roomId,
      required int periodIndex,
      required DateTime roomDate,
      String? reservedEmail,
      required DateTime reservedTime,
      required ReserveStatus reserveStatus}) = _$ReservedInfoImpl;

  factory _ReservedInfo.fromJson(Map<String, dynamic> json) =
      _$ReservedInfoImpl.fromJson;

  @override
  String? get documentId;
  set documentId(String? value);
  @override
  String get roomId;
  set roomId(String value);
  @override
  int get periodIndex;
  set periodIndex(int value);
  @override
  DateTime get roomDate;
  set roomDate(DateTime value);
  @override
  String? get reservedEmail;
  set reservedEmail(String? value);
  @override
  DateTime get reservedTime;
  set reservedTime(DateTime value);
  @override
  ReserveStatus get reserveStatus;
  set reserveStatus(ReserveStatus value);
  @override
  @JsonKey(ignore: true)
  _$$ReservedInfoImplCopyWith<_$ReservedInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
