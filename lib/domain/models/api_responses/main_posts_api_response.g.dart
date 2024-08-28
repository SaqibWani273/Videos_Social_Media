// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_posts_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainPostsApiResponse _$MainPostsApiResponseFromJson(
        Map<String, dynamic> json) =>
    MainPostsApiResponse(
      currentPage: (json['page'] as num).toInt(),
      maxPageSize: (json['max_page_size'] as num).toInt(),
      currentPageSize: (json['page_size'] as num).toInt(),
      posts: (json['posts'] as List<dynamic>).map(VideoPost.fromJson).toList(),
    );

Map<String, dynamic> _$MainPostsApiResponseToJson(
        MainPostsApiResponse instance) =>
    <String, dynamic>{
      'page': instance.currentPage,
      'max_page_size': instance.maxPageSize,
      'page_size': instance.currentPageSize,
      'posts': instance.posts,
    };
