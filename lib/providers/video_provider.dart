// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:persist_ventures/domain/models/video_post.dart';
import 'package:persist_ventures/domain/repositories/api_repository.dart';

class VerticalVideos {
  final int id;
  final String? parentVideoTitle;
  List<VideoPost> videos;
  final int? grandParentId;
  VerticalVideos({
    required this.id,
    required this.parentVideoTitle,
    required this.videos,
    required this.grandParentId,
  });
}

class VideoProvider extends ChangeNotifier {
  final ApiRepository apiRepository;
  //a kind of grid where each column contains list of videos
  //
  List<VerticalVideos> _horizontalVideosList = [];

  List<VideoPost>? _mainVideos;
  List<VideoPost>? _repliesVideos;
  VideoProvider({
    required this.apiRepository,
  });
  List<VideoPost>? get mainVideos => _mainVideos;
  List<VideoPost>? get repliesVideos => _repliesVideos;
  List<VerticalVideos> get horizontalVideosList => _horizontalVideosList;
  // set mainVideos(List<VideoPost>? videos) {
  //   _mainVideos = videos;
  //   notifyListeners();
  // }
  void addPlaceHolderToHorizontalList(
      int? grandParentId, int parentId, String? parentVideoTitle) {
    _horizontalVideosList = _horizontalVideosList
      ..add(VerticalVideos(
          grandParentId: grandParentId,
          id: parentId,
          parentVideoTitle: parentVideoTitle,
          videos: []));
    notifyListeners();
  }

  void addPlaceHolderWithReplacementToHorizontalList(
      //As i'm adding the placeholder children
      //for current videopost(i.e having parentId)
      //grandparentid is needed to remove the existing placeholder
      //of current videoslist(or of siblings)
      int? grandParentId,
      int parentId,
      String? parentVideoTitle) {
    if (grandParentId == null) {
      if (_horizontalVideosList.length > 1) {
        //to remove the placeholder of first vertical videos list
        _horizontalVideosList.removeLast();
      }
    } else {
      _horizontalVideosList.removeWhere(
        (element) =>
            element.grandParentId != null &&
            element.grandParentId == grandParentId,
      );
    }
    _horizontalVideosList = _horizontalVideosList
      ..add(VerticalVideos(
          grandParentId: grandParentId,
          id: parentId,
          parentVideoTitle: parentVideoTitle,
          videos: []));
    notifyListeners();
  }

  void removePlaceHolderWithReplacementToHorizontalList(int? grandParentId) {
    if (grandParentId == null) {
      //to remove the placeholder of first vertical videos list
      if (_horizontalVideosList.length > 1) {
        _horizontalVideosList.removeLast();
      }
    } else {
      _horizontalVideosList.removeWhere(
        (element) => element.grandParentId == grandParentId,
      );
    }
    notifyListeners();
    // if (_horizontalVideosList.length > 1) {
    //   _horizontalVideosList.removeLast();
    //   notifyListeners();
    // }
  }

  Future<void> getMainVideoPosts() async {
    _mainVideos = await apiRepository.fetchMainVideoPosts();
    _horizontalVideosList = _horizontalVideosList
      ..addAll([
        //main posts
        VerticalVideos(
            grandParentId: null,
            id: _mainVideos!.first.id,
            parentVideoTitle: null,
            videos: _mainVideos!),
        //placeholder for children of ist video post
        VerticalVideos(
          grandParentId: null,
          id: _mainVideos!.first.id,
          parentVideoTitle: _mainVideos!.first.title,
          videos: [],
        )
      ]);

    // _repliesVideos =
    //     await apiRepository.fetchRepliesOfVideo(id: _mainVideos!.first.id);
    // _horizontalVideosList = _horizontalVideosList
    //   ..addAll([_mainVideos!, _repliesVideos!]);
    notifyListeners();
  }

  // void updateHorizontalVideosList(List<List<VideoPost>> list) {
  //   _horizontalVideosList = list;
  //   notifyListeners();
  // }

  Future<void> getReplies(
      int? grandParentId, int parentVideoId, String? parentVideoTitle) async {
    // _repliesVideos = null;
    // notifyListeners();
    _repliesVideos = await apiRepository.fetchRepliesOfVideo(id: parentVideoId);
    _horizontalVideosList.length > 1
        ? _horizontalVideosList.removeLast()
        : null;
    _horizontalVideosList = _horizontalVideosList
      ..add(VerticalVideos(
          grandParentId: grandParentId,
          id: parentVideoId,
          parentVideoTitle: parentVideoTitle,
          videos: _repliesVideos!));
    notifyListeners();
  }
}
