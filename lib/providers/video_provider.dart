import 'package:flutter/material.dart';
import 'package:persist_ventures/domain/models/video_post.dart';
import 'package:persist_ventures/domain/repositories/api_repository.dart';

class VerticalVideos {
  //details of the parent_video + videos
  final int? parentId;
  final String? parentVideoTitle;
  List<VideoPost> videos;
  final int? grandParentId;
//  required int parentVideoIndex; //current index in the vertical list(column)
  VerticalVideos({
    required this.parentId,
    required this.parentVideoTitle,
    required this.videos,
    required this.grandParentId,
    // this.parentVideoIndex ,
  });
  @override
  String toString() {
    return "parentId: $parentId," +
        " videos : ${videos.length} parenTitle :$parentVideoTitle grandParentId : $grandParentId";
  }
}

class VideoProvider extends ChangeNotifier {
  final ApiRepository apiRepository;

  //a kind of matrix where each column contains list of videos
  List<VerticalVideos> _videosMatrix = [];
  //stores the index of each video in the column
  //whose replies got played,need it in back-traversal
  List<int> videosIndexRow = [0];
  VideoProvider({
    required this.apiRepository,
  });

  List<VerticalVideos> get videosMatrix => _videosMatrix;

//fetch main video post and reply videos
  Future<void> fetchVideos({
    required int? id, //id is needed for fetching replies
    int? parentId,
    // int? parentVideoIndex,
    String? parentVideoTitle,
  }) async {
    final videos = await apiRepository.fetchVideoPosts(parentId: id);
    if (_videosMatrix.isNotEmpty &&
        _videosMatrix.last.grandParentId == parentId) {
      //remove that
      _videosMatrix.removeLast();
    }
    _videosMatrix.addAll([
      VerticalVideos(
        parentId: id ?? -1, //can be null for ist column
        parentVideoTitle: parentVideoTitle, //can be null for ist column
        videos: videos,
        grandParentId: parentId, //can be null for first column
      ),
      //add empty next column
      if (videos.first.childVideoCount > 0)
        VerticalVideos(
          parentId: videos.first.id,
          parentVideoTitle: videos.first.title,
          videos: [],
          grandParentId: videos.first.parentVideoId ?? -1,
        ),
    ]);
    notifyListeners();
  }

//need to keep track of parent videos index for back-traversal
  void updateVideosIndex(int index) {
    //called on vertical-swipe
    videosIndexRow[videosIndexRow.indexOf(videosIndexRow.last)] = index;
    notifyListeners();
  }

  void addNewVideosIndex() {
    // right-horizontal-swipe
    videosIndexRow.add(0);
    notifyListeners();
  }

  void removeVideosIndex() {
    //called on left-horizontal-swipe
    videosIndexRow.removeLast();
    notifyListeners();
  }
  // Future<void> getMainVideoPosts() async {
  //   _mainVideos = await apiRepository.fetchMainVideoPosts();
  //   _videosMatrix = _videosMatrix
  //     ..addAll([
  //       //main posts
  //       VerticalVideos(
  //           grandParentId: null,
  //           id: _mainVideos!.first.id,
  //           parentVideoTitle: null,
  //           videos: _mainVideos!),
  //       //placeholder for children of ist video post
  //       VerticalVideos(
  //         grandParentId: null,
  //         id: _mainVideos!.first.id,
  //         parentVideoTitle: _mainVideos!.first.title,
  //         videos: [],
  //       )
  //     ]);

  //   notifyListeners();
  // }

  // Future<void> getReplies(
  //     int? grandParentId, int parentVideoId, String? parentVideoTitle) async {
  //   // _repliesVideos = null;
  //   // notifyListeners();
  //   _repliesVideos = await apiRepository.fetchRepliesOfVideo(id: parentVideoId);
  //   _videosMatrix.length > 1 ? _videosMatrix.removeLast() : null;
  //   _videosMatrix = _videosMatrix
  //     ..add(VerticalVideos(
  //         currentIndex: videoIndexInColumn,
  //         grandParentId: grandParentId,
  //         id: parentVideoId,
  //         parentVideoTitle: parentVideoTitle,
  //         videos: _repliesVideos!));
  //   notifyListeners();
  // }
//temporarily add the empty replies column
//on vertical-scroll for the video with following details
  void addEmptyVideosColumn({
    required int? parentId,
    required int id,
    required String? videoTitle,
  }) {
/*different cases of adding empty column

case 1:To add empty column for first video of the column,
for this we donot need to remove any previous empty column

case 2: Add empty column for non-first videos of the column
So, We've to remove previous empty column(if any) and add new empty
column with current video details
      case 2.1: There exists empty-column for the sibling video(i.e
      video of current column).
          // case 2.1.1: Current video's child count>0
          // case 2.1.2: Current videos's child count=0
      case 2.2: There is no empty-column for the sibling video
          // case 2.2.1: Current video's child count>0
          // case 2.1.2: Current videos's child count=0

*/
//simple solution:Check if there exists any
// empty_column for current column
    if (_videosMatrix.last.grandParentId == parentId) {
      //remove that
      _videosMatrix.removeLast();
    }

    _videosMatrix.add(VerticalVideos(
      parentId: id,
      parentVideoTitle: videoTitle,
      videos: [],
      grandParentId: parentId,
    ));
    notifyListeners();
  }

  void removeEmptyColumn(int parentId) {
    if (_videosMatrix.last.grandParentId == parentId) {
      //remove that
      _videosMatrix.removeLast();
    }
    notifyListeners();
  }
//  //swipe horizontally
//   void addPlaceHolderToHorizontalList(
//       int? grandParentId, int parentId, String? parentVideoTitle) {
//     _videosMatrix = _videosMatrix
//       ..add(VerticalVideos(
//           currentIndex: videoIndexInColumn,
//           grandParentId: grandParentId,
//           id: parentId,
//           parentVideoTitle: parentVideoTitle,
//           videos: []));
//     notifyListeners();
//   }

// //vertical swipe
//   void addPlaceHolderWithReplacementToHorizontalList(
//       //As i'm adding the placeholder children
//       //for current videopost(i.e having parentId)
//       //grandparentid is needed to remove the existing placeholder
//       //of current videoslist(or of siblings)
//       int? grandParentId,
//       int parentId,
//       String? parentVideoTitle) {
//     if (grandParentId == null) {
//       if (_videosMatrix.length > 1) {
//         //to remove the placeholder of first vertical videos list
//         _videosMatrix.removeLast();
//       }
//     } else {
//       _videosMatrix.removeWhere(
//         (element) =>
//             element.grandParentId != null &&
//             element.grandParentId == grandParentId,
//       );
//     }
//     _videosMatrix = _videosMatrix
//       ..add(VerticalVideos(
//           grandParentId: grandParentId,
//           id: parentId,
//           parentVideoTitle: parentVideoTitle,
//           videos: []));
//     notifyListeners();
//   }

  void removePlaceHolderWithReplacementToHorizontalList(int? grandParentId) {
    if (grandParentId == null) {
      //to remove the placeholder of first vertical videos list
      if (_videosMatrix.length > 1) {
        _videosMatrix.removeLast();
      }
    } else {
      _videosMatrix.removeWhere(
        (element) => element.grandParentId == grandParentId,
      );
    }
    notifyListeners();
  }
}
