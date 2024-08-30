import 'package:persist_ventures/data/datasource/remote/api_service.dart';
import 'package:persist_ventures/domain/models/video_post.dart';
import 'package:persist_ventures/domain/repositories/api_repository.dart';

class ApiRepositoryImpl implements ApiRepository {
  final ApiService apiService;

  ApiRepositoryImpl({required this.apiService});

  // @override
  // Future<List<VideoPost>> fetchMainVideoPosts() {
  //   return apiService.getMainVideoPosts();
  // }

  // @override
  // Future<List<VideoPost>> fetchRepliesOfVideo({required int id}) {
  //   return apiService.getRepliesOfVideo(id: id);
  // }

  @override
  Future<List<VideoPost>> fetchVideoPosts({int? parentId}) {
    if (parentId == null) {
      return apiService.getMainVideoPosts();
    }
    return apiService.getRepliesOfVideo(id: parentId);
  }
}
