import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:persist_ventures/presentation/widgets/loading_video_widget.dart';
import 'package:persist_ventures/presentation/widgets/video_tracker.dart';
import 'package:persist_ventures/utils/app_logger.dart';
import 'package:provider/provider.dart';

import 'package:persist_ventures/providers/video_provider.dart';

import 'widgets/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int i = 2;
  // late PageController? _verticalPageController;
  int previousHorizontalPage = 0;
  int initialPage = 0;
  // int verticalPage = 0;
  List<int> previousVerticalPages = [0];
  // var isLeftSwipe = false;
  @override
  Widget build(BuildContext context) {
    final videosMatrix = context.watch<VideoProvider>().videosMatrix;
    return Scaffold(
        body: videosMatrix.isEmpty
            ? const LoadingVideoWidget()
            :
            //Row of the videoMatrix
            PageView.builder(
                dragStartBehavior: DragStartBehavior.down,
                onPageChanged: (page) {
                  //right swipe
                  if (page > previousHorizontalPage) {
                    // context.read<VideoProvider>().addNewVideosIndex();
                    previousVerticalPages.add(0);

                    //fetch videos if current column is empty
                    if (videosMatrix[page].videos.isEmpty) {
                      context.read<VideoProvider>().fetchVideos(
                            id: videosMatrix[page].parentId,
                            parentId: videosMatrix[page].grandParentId,
                            parentVideoTitle:
                                videosMatrix[page].parentVideoTitle,
                          );
                    }
                    //need it after back traversal
                    else if (videosMatrix[page].videos.first.childVideoCount >
                            0 &&
                        videosMatrix.last.parentId !=
                            videosMatrix[page].videos.first.id) {
                      //add empty column
                      context.read<VideoProvider>().addEmptyVideosColumn(
                          parentId:
                              videosMatrix[page].videos.first.parentVideoId,
                          id: videosMatrix[page].videos.first.id,
                          videoTitle: videosMatrix[page].videos.first.title);
                    }
                  } else {
                    //left swipe
                    //delete grandchild(if any)
                    context
                        .read<VideoProvider>()
                        .removeEmptyGrandChild(previousVerticalPages.length);
                    previousVerticalPages.removeLast();
                  }
                  previousHorizontalPage = page;
                },
                //   controller: _verticalPageController,
                itemCount: videosMatrix.length, // currentVideos.length,
                itemBuilder: (context, horizontalIndex) {
                  return videosMatrix[horizontalIndex].videos.isEmpty
                      ? const LoadingVideoWidget()
                      :
                      //column of the videosMatrix
                      ColumnVideos(
                          horizontalIndex: horizontalIndex,
                          updateVerticalIndex: (index) {
                            setState(() {
                              previousVerticalPages.last = index;
                            });
                          },
                          initialPage:
                              previousVerticalPages.length == horizontalIndex
                                  ? 0
                                  : previousVerticalPages[horizontalIndex],
                          verticalVideos: videosMatrix[horizontalIndex],
                        );
                }));
  }
}

class ColumnVideos extends StatefulWidget {
  const ColumnVideos({
    super.key,
    required this.initialPage,
    required this.verticalVideos,
    required this.updateVerticalIndex,
    required this.horizontalIndex,
  });
  final Function(int) updateVerticalIndex;
  final int initialPage;
  final VerticalVideos verticalVideos;
  final int horizontalIndex;

  @override
  State<ColumnVideos> createState() => _ColumnVideosState();
}

class _ColumnVideosState extends State<ColumnVideos> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.initialPage);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return PageView.builder(
      controller: pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: (verticalPageIndex) {
        widget.updateVerticalIndex(verticalPageIndex);
        //need to keep track of current video in column for
        //back-traversal
        // previousVerticalPages.last = verticalPageIndex;

        if (widget.verticalVideos.videos[verticalPageIndex].childVideoCount ==
            0) {
          //remove (if exists) empty column
          context.read<VideoProvider>().removeEmptyColumn(
                widget.verticalVideos.parentId!,
                id: widget.verticalVideos.videos[verticalPageIndex].id,
              );
        } else {
          context.read<VideoProvider>().addEmptyVideosColumn(
              parentId: widget.verticalVideos.parentId!,
              id: widget.verticalVideos.videos[verticalPageIndex].id,
              videoTitle:
                  widget.verticalVideos.videos[verticalPageIndex].title);
        }
      },
      itemBuilder: (context, verticalIndex) {
        return VideoPlayer(
          videoTracker: VideoTracker(
            rowNo: verticalIndex + 1,
            colNo: widget.horizontalIndex + 1,
            totalRows: widget.verticalVideos.videos.length,
            hasChild:
                widget.verticalVideos.videos[verticalIndex].childVideoCount > 0,
          ),
          parentTitle: widget.verticalVideos
              .parentVideoTitle, // widget.ColumnVideos.parentVideoTitle,
          deviceHeight: deviceHeight,
          deviceWidth: deviceWidth,
          videoPost: widget.verticalVideos.videos[verticalIndex],
        );
      },
      itemCount: widget.verticalVideos.videos.length,
    );
  }
}
