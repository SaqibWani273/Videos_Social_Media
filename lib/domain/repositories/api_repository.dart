import 'package:persist_ventures/domain/models/video_post.dart';

abstract class ApiRepository {
  // Future<List<VideoPost>> fetchMainVideoPosts();
  // Future<List<VideoPost>> fetchRepliesOfVideo({required int id});
  Future<List<VideoPost>> fetchVideoPosts({int? parentId});
}
