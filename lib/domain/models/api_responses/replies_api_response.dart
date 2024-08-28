// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';

import 'package:persist_ventures/domain/models/video_post.dart';

part 'replies_api_response.g.dart';

@JsonSerializable()
class RepliesApiResponse {
  @JsonKey(name: 'post')
  final List<VideoPost> posts;
  final String status;
  RepliesApiResponse({
    required this.status,
    required this.posts,
  });
  factory RepliesApiResponse.fromJson(json) =>
      _$RepliesApiResponseFromJson(json);
}
