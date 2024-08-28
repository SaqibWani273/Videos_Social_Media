// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:persist_ventures/domain/models/video_post.dart';

part 'main_posts_api_response.g.dart';

@JsonSerializable()
class MainPostsApiResponse {
  @JsonKey(name: "page")
  final int currentPage;
  @JsonKey(name: "max_page_size")
  final int maxPageSize;
  @JsonKey(name: "page_size")
  final int currentPageSize;
  final List<VideoPost> posts;
  MainPostsApiResponse({
    required this.currentPage,
    required this.maxPageSize,
    required this.currentPageSize,
    required this.posts,
  });
  factory MainPostsApiResponse.fromJson(json) =>
      _$MainPostsApiResponseFromJson(json);
}
