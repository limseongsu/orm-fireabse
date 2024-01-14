import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model.freezed.dart';

part 'chat_model.g.dart';

@freezed
class Chat with _$Chat {
  factory Chat(
    // data 통신 안하기 위한 옵션
    @JsonKey(includeToJson: true, includeFromJson: true) bool isMyMessage, {
    required String sender,
    required String message,
    required int timeStamp,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json).copyWith();
}
