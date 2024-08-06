// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
      objectChallenge: json['objectChallenge'] as String?,
      videoUrl: json['videoUrl'] as String?,
      creatorUser: json['creatorUser'],
      roleSeeked: json['roleSeeked'] as String?,
      description: json['description'] as String?,
      label: json['label'] as String?,
    );

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'objectChallenge': instance.objectChallenge,
      'videoUrl': instance.videoUrl,
      'creatorUser': instance.creatorUser,
      'roleSeeked': instance.roleSeeked,
      'description': instance.description,
      'label': instance.label,
    };
