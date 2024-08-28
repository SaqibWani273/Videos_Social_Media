// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:persist_ventures/domain/models/video_post.dart';
import 'package:persist_ventures/domain/repositories/api_repository.dart';

class VideoProvider extends ChangeNotifier {
  final ApiRepository apiRepository;

  List<VideoPost>? _mainVideos;
  List<VideoPost>? _repliesVideos;
  VideoProvider({
    required this.apiRepository,
  });
  List<VideoPost>? get mainVideos => _mainVideos;
  List<VideoPost>? get repliesVideos => _repliesVideos;
  set mainVideos(List<VideoPost>? videos) {
    _mainVideos = videos;
    notifyListeners();
  }

  Future<void> getMainVideoPosts() async {
    _mainVideos = await apiRepository.fetchMainVideoPosts();
    notifyListeners();
  }

  Future<void> getReplies(int parentVideoId) async {
    _repliesVideos = await apiRepository.fetchRepliesOfVideo(id: parentVideoId);
    notifyListeners();
  }
}
