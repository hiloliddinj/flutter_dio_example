import 'package:json_annotation/json_annotation.dart';
import '../User/user.dart';

part 'single_user_response.g.dart';

@JsonSerializable()
class SingleUserResponse {

  @JsonKey(name: "data")
  User? user;

  SingleUserResponse({required this.user});

  factory SingleUserResponse.fromJson(Map<String, dynamic> json) => _$SingleUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SingleUserResponseToJson(this);
}