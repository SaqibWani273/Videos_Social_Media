// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'video_post.g.dart';

@JsonSerializable()
class VideoPost {
  @JsonKey(name: "video_link")
  final String videoLink;
  @JsonKey(name: "parent_video_id")
  final int? parentVideoId;
  @JsonKey(name: "thumbnail_url")
  final String thumbnailUrl;
  final String username;
  final int id;
  @JsonKey(name: "child_video_count")
  final int childVideoCount;
  @JsonKey(name: "upvote_count")
  final int upvoteCount;
  @JsonKey(name: "comment_count")
  final int commentCount;
  @JsonKey(name: "view_count")
  final int viewCount;
  @JsonKey(name: "share_count")
  final int shareCount;
  final String title;
  VideoPost({
    required this.videoLink,
    required this.parentVideoId,
    required this.thumbnailUrl,
    required this.username,
    required this.id,
    required this.childVideoCount,
    required this.upvoteCount,
    required this.commentCount,
    required this.viewCount,
    required this.shareCount,
    required this.title,
  });

  factory VideoPost.fromJson(json) => _$VideoPostFromJson(json);
}
