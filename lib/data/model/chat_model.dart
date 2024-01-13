import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model.freezed.dart';

part 'chat_model.g.dart';

@freezed
class Chat with _$Chat {
  factory Chat({
    required String sender,
    required String message,
    required int timeStamp,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json).copyWith();
}
