import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:persist_ventures/providers/video_provider.dart';
import 'package:provider/provider.dart';

import '../domain/models/video_post.dart';
import '../utils/app_logger.dart';
import 'home_page.dart';

// List<List<VideoPost>> horizontalVideos = [];

class HorizontalPageView extends StatefulWidget {
  // final List<VideoPost> siblingVideos;
  const HorizontalPageView({
    super.key,
    // required this.siblingVideos,
  });

  @override
  State<HorizontalPageView> createState() => _HorizontalPageViewState();
}

class _HorizontalPageViewState extends State<HorizontalPageView> {
  // List<VideoPost> get _siblingVideos => widget.siblingVideos;
  @override
  void initState() {
    // TODO: implement initState
    // context.read<VideoProvider>().updateHorizontalVideosList(
    //     context.read<VideoProvider>().horizontalVideosList
    //       ..add(_siblingVideos));
    // context.read<VideoProvider>().getReplies(_siblingVideos.first.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final videosList = context.watch<VideoProvider>().horizontalVideosList;
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return PageView.builder(
        onPageChanged: (index) {
          AppLogger.logMessage("horizontal -> $index");
// to do: add without replacement placeholder
//           in the main horizontalListvideos
          final verticalVideoVideos = videosList[index].videos;
          if (verticalVideoVideos.isNotEmpty &&
              verticalVideoVideos.first.childVideoCount > 0) {
            context.read<VideoProvider>().addPlaceHolderToHorizontalList(
                verticalVideoVideos.first.parentVideoId,
                verticalVideoVideos.first.id,
                verticalVideoVideos.first.title);
          }
        },
        // scrollDirection: Axis.vertical,
        itemCount: videosList.length, // currentVideos.length,
        itemBuilder: (context, index) => VerticalPageView(
              verticalVideos: videosList[index],
              index: index,
            ));
  }
}

class VerticalPageView extends StatefulWidget {
  final VerticalVideos verticalVideos;
  final int index;

  // final int parentId;
  const VerticalPageView(
      {super.key, required this.verticalVideos, required this.index});

  @override
  State<VerticalPageView> createState() => _VerticalPageViewState();
}

class _VerticalPageViewState extends State<VerticalPageView> {
  PageController pageController = PageController(initialPage: 0);
  @override
  void initState() {
    //here we replace the placeholder with actual data
    //& placeholder for next vertical column
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (mounted && widget.verticalVideos.videos.isEmpty) {
          //fetch videos for current vertical column
          await context.read<VideoProvider>().getReplies(
              widget.verticalVideos.grandParentId,
              widget.verticalVideos.id,
              widget.verticalVideos.parentVideoTitle);
          //add placeholder for next column if ist video has children
          Future.delayed(
            Durations.short1,
            () async {
              final VerticalVideos currentVerticalVideosList = context
                  .read<VideoProvider>()
                  .horizontalVideosList[widget.index];

              if (currentVerticalVideosList.videos.first.childVideoCount > 0) {
                context.read<VideoProvider>().addPlaceHolderToHorizontalList(
                    currentVerticalVideosList.videos.first.parentVideoId,
                    currentVerticalVideosList.videos.first.id,
                    currentVerticalVideosList.videos.first.title);
              }
            },
          );
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return widget.verticalVideos.videos.isEmpty
        ? AspectRatio(
            aspectRatio: deviceWidth / deviceHeight,
            child: Container(
              color: Colors.black,
              child: const Center(
                heightFactor: 20,
                widthFactor: 5,
                child: CircularProgressIndicator(
                  // backgroundColor: Colors.white,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : PageView.builder(
            scrollDirection: Axis.vertical,
            controller: pageController,
            onPageChanged: (index) {
              //to do: add with replacement placeholder
              // in the main horizontalListvideos
              if (widget.verticalVideos.videos[index].childVideoCount == 0) {
                //current video has no child or replies
                context
                    .read<VideoProvider>()
                    .removePlaceHolderWithReplacementToHorizontalList(
                        widget.verticalVideos.videos[index].parentVideoId);
              } else {
                context
                    .read<VideoProvider>()
                    .addPlaceHolderWithReplacementToHorizontalList(
                        widget.verticalVideos.videos[index].parentVideoId,
                        widget.verticalVideos.videos[index].id,
                        widget.verticalVideos.videos[index].title);
              }
            },
            itemCount: widget.verticalVideos.videos.length,
            itemBuilder: (context, index) => VideoPlayer(
                parentTitle: widget.verticalVideos.parentVideoTitle,
                deviceHeight: deviceHeight,
                deviceWidth: deviceWidth,
                videoPost: widget.verticalVideos.videos[index]),
          );
  }
}
