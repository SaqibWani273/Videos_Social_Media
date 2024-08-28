// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'replies_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RepliesApiResponse _$RepliesApiResponseFromJson(Map<String, dynamic> json) {
  // log("posts ->" + json['post'].toString());
  // (json['post'] as List<dynamic>).map(
  //   (e) {
  //     log("e ->${e.toString()}");
  //   },
  // );
  return RepliesApiResponse(
    status: json['status'] as String,
    posts: (json['post'] as List<dynamic>).map(VideoPost.fromJson).toList(),
  );
}

Map<String, dynamic> _$RepliesApiResponseToJson(RepliesApiResponse instance) =>
    <String, dynamic>{
      'post': instance.posts,
      'status': instance.status,
    };
