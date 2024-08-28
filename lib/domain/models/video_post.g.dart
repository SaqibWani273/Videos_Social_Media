// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoPost _$VideoPostFromJson(Map<String, dynamic> json) => VideoPost(
      videoLink: json['video_link'] as String,
      parentVideoId: (json['parent_video_id'] as num?)?.toInt(),
      thumbnailUrl: json['thumbnail_url'] as String,
      username: json['username'] as String,
      id: (json['id'] as num).toInt(),
      childVideoCount: (json['child_video_count'] as num).toInt(),
      upvoteCount: (json['upvote_count'] as num).toInt(),
      commentCount: (json['comment_count'] as num).toInt(),
      viewCount: (json['view_count'] as num).toInt(),
      shareCount: (json['share_count'] as num).toInt(),
      title: json['title'] as String,
    );

Map<String, dynamic> _$VideoPostToJson(VideoPost instance) => <String, dynamic>{
      'video_link': instance.videoLink,
      'parent_video_id': instance.parentVideoId,
      'thumbnail_url': instance.thumbnailUrl,
      'username': instance.username,
      'id': instance.id,
      'child_video_count': instance.childVideoCount,
      'upvote_count': instance.upvoteCount,
      'comment_count': instance.commentCount,
      'view_count': instance.viewCount,
      'share_count': instance.shareCount,
      'title': instance.title,
    };
