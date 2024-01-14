// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatImpl _$$ChatImplFromJson(Map<String, dynamic> json) => _$ChatImpl(
      json['isMyMessage'] as bool,
      sender: json['sender'] as String,
      message: json['message'] as String,
      timeStamp: json['timeStamp'] as int,
    );

Map<String, dynamic> _$$ChatImplToJson(_$ChatImpl instance) =>
    <String, dynamic>{
      'isMyMessage': instance.isMyMessage,
      'sender': instance.sender,
      'message': instance.message,
      'timeStamp': instance.timeStamp,
    };
