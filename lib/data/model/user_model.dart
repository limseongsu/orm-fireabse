import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

@freezed
class User with _$User {
  factory User({
    required String userId,
    required String password,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json).copyWith();
}
