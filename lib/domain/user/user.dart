import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  final List<dynamic>? videosUrls;
  final String? password;
  final String? email;
  final String? name;
  final List<dynamic>? challengesUrl;

  const User({
    this.videosUrls,
    this.password,
    this.email,
    this.name,
    this.challengesUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      videosUrls,
      password,
      email,
      name,
      challengesUrl,
    ];
  }
}
