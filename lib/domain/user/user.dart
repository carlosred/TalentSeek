import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  final List<dynamic>? videos;
  final String? registeredEmail;
  final String? name;
  final List<dynamic>? challenges;

  const User({
    this.videos,
    this.registeredEmail,
    this.name,
    this.challenges,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      videos,
      registeredEmail,
      name,
      challenges,
    ];
  }

  User copyWith({
    List<dynamic>? videos,
    String? registeredEmail,
    String? name,
    List<dynamic>? challenges,
  }) {
    return User(
      videos: videos ?? this.videos,
      registeredEmail: registeredEmail ?? this.registeredEmail,
      name: name ?? this.name,
      challenges: challenges ?? this.challenges,
    );
  }
}
