import 'package:flutter/material.dart';
import 'package:persist_ventures/presentation/widgets/loading_video_widget.dart';
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
  // final _verticalPageController = PageController();
  int previousPage = 0;
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final videosMatrix = context.watch<VideoProvider>().videosMatrix;
    final videosIndexRow = context.watch<VideoProvider>().videosIndexRow;

    return Scaffold(
        body: videosMatrix.isEmpty
            ? const LoadingVideoWidget()
            :
            //Row of the videoMatrix
            PageView.builder(
                onPageChanged: (page) {
                  //right swipe
                  if (page > previousPage) {
                    context.read<VideoProvider>().addNewVideosIndex();
                  } else {
                    //left swipe
                    context.read<VideoProvider>().removeVideosIndex();
                  }
                  previousPage = page;
                },
                itemCount: videosMatrix.length, // currentVideos.length,
                itemBuilder: (context, horizontalIndex) {
                  //fetch videos is current column is empty
                  if (videosMatrix[horizontalIndex].videos.isEmpty) {
                    context.read<VideoProvider>().fetchVideos(
                          id: videosMatrix[horizontalIndex].parentId,
                          parentId: videosMatrix[horizontalIndex].grandParentId,
                          parentVideoTitle:
                              videosMatrix[horizontalIndex].parentVideoTitle,
                        );
                  }

                  return videosMatrix[horizontalIndex].videos.isEmpty
                      ? const LoadingVideoWidget()
                      :
                      //column of the videosMatrix
                      PageView.builder(
                          // controller: _verticalPageController,
                          scrollDirection: Axis.vertical,
                          onPageChanged: (verticalIndex) {
                            //need to keep track of current video in column for
                            //back-traversal
                            context
                                .read<VideoProvider>()
                                .updateVideosIndex(verticalIndex);
                            if (videosMatrix[horizontalIndex]
                                    .videos[verticalIndex]
                                    .childVideoCount ==
                                0) {
                              //remove (if exists) empty column
                              context.read<VideoProvider>().removeEmptyColumn(
                                  videosMatrix[horizontalIndex].parentId!);
                            } else {
                              context
                                  .read<VideoProvider>()
                                  .addEmptyVideosColumn(
                                      parentId: videosMatrix[horizontalIndex]
                                          .parentId!,
                                      id: videosMatrix[horizontalIndex]
                                          .videos[verticalIndex]
                                          .id,
                                      videoTitle: videosMatrix[horizontalIndex]
                                          .videos[verticalIndex]
                                          .title);
                            }
                          },
                          itemBuilder: (context, verticalIndex) {
                            return VideoPlayer(
                              parentTitle: videosMatrix[horizontalIndex]
                                  .parentVideoTitle, // widget.verticalVideos.parentVideoTitle,
                              deviceHeight: deviceHeight,
                              deviceWidth: deviceWidth,
                              videoPost: videosMatrix[horizontalIndex]
                                  .videos[verticalIndex],
                            );
                          },
                          itemCount:
                              videosMatrix[horizontalIndex].videos.length,
                        );
                }));
  }
}
