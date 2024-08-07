// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      videos: json['videos'] as List<dynamic>?,
      registeredEmail: json['registeredEmail'] as String?,
      name: json['name'] as String?,
      challenges: json['challenges'] as List<dynamic>?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'videos': instance.videos,
      'registeredEmail': instance.registeredEmail,
      'name': instance.name,
      'challenges': instance.challenges,
    };
