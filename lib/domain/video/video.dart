import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talent_seek/domain/user/user.dart';

part 'video.g.dart';

@JsonSerializable()
class Video extends Equatable {
  final String? objectChallenge;
  final String? videoUrl;
  final dynamic creatorUser;
  final String? roleSeeked;
  final String? description;
  final String? label;

  const Video({
    this.objectChallenge,
    this.videoUrl,
    this.creatorUser,
    this.roleSeeked,
    this.description,
    this.label,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return _$VideoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$VideoToJson(this);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      objectChallenge,
      videoUrl,
      creatorUser,
      roleSeeked,
      description,
      label,
    ];
  }

  Video copyWith({
    String? objectChallenge,
    String? videoUrl,
    dynamic creatorUser,
    String? roleSeeked,
    String? description,
    String? label,
  }) {
    return Video(
      objectChallenge: objectChallenge ?? this.objectChallenge,
      videoUrl: videoUrl ?? this.videoUrl,
      creatorUser: creatorUser ?? this.creatorUser,
      roleSeeked: roleSeeked ?? this.roleSeeked,
      description: description ?? this.description,
      label: label ?? this.label,
    );
  }
}
