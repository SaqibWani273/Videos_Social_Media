import 'package:dio/dio.dart';
import 'package:persist_ventures/domain/models/api_responses/main_posts_api_response.dart';
import 'package:persist_ventures/domain/models/api_responses/replies_api_response.dart';
import 'package:persist_ventures/domain/models/video_post.dart';
import 'package:persist_ventures/utils/app_logger.dart';
import 'package:persist_ventures/utils/constants/string_constants.dart';
import 'package:persist_ventures/utils/error/exceptions.dart';
import 'package:persist_ventures/utils/error/handle_dio_exception.dart';

class ApiService {
  final Dio dio;

  ApiService({required this.dio});

  Future<List<VideoPost>> getMainVideoPosts() async {
    try {
      final response = await dio.get(StringConstants.mainVideosApiUrl);
      if (response.data == null) {
        throw ServerException(
            message: "Unknown Server Error", statusCode: response.statusCode);
      }
      final apiResponse = MainPostsApiResponse.fromJson(response.data);
      if (apiResponse.currentPageSize == 0) return [];
      AppLogger.logMessage("posts -> ${apiResponse.posts.length}");
      return apiResponse.posts;
    } on DioException catch (e) {
      throw ServerException(
          message: handleDioException(e.type),
          statusCode: e.response?.statusCode);
    } catch (e) {
      AppLogger.logMessage("error in fetching videos ${e.toString()}");
      throw ServerException(message: "Unknown Error From Serve");
    }
  }

  Future<List<VideoPost>> getRepliesOfVideo({required int id}) async {
    try {
      final response = await dio.get(StringConstants.repliesApiUrl(id));
      if (response.data == null) {
        throw ServerException(
            message: "Unknown Server Error", statusCode: response.statusCode);
      }
      AppLogger.logMessage("Replies - > ${response.data}");
      final apiResponse = RepliesApiResponse.fromJson(response.data);
      if (apiResponse.status != "success" || apiResponse.posts.isEmpty) {
        return [];
      }
      AppLogger.logMessage("posts -> ${apiResponse.posts.length}");
      return apiResponse.posts;
    } on DioException catch (e) {
      throw ServerException(
          message: handleDioException(e.type),
          statusCode: e.response?.statusCode);
    } catch (e) {
      AppLogger.logMessage(
          "error fetching replies for video id ${id}, error -> ${e.toString()}");
      throw ServerException(message: "Unknown Error From Serve");
    }
  }
}
