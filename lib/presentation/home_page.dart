import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:persist_ventures/presentation/horizontal_view.dart';
import 'package:provider/provider.dart';

import 'package:persist_ventures/providers/video_provider.dart';
import 'package:persist_ventures/utils/app_logger.dart';

import '../domain/models/video_post.dart';

class HomePage extends StatefulWidget {
  final int? parentId;
  const HomePage({
    required this.parentId,
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<VideoPost> currentVideos;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (widget.parentId != null) {
          // context.read<VideoProvider>().getReplies(widget.parentId!);
        } else {
          // context.read<VideoProvider>().getMainVideoPosts();
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Consumer<VideoProvider>(
        builder: (context, videoProvider, child) {
          if (videoProvider.mainVideos == null ||
              (widget.parentId != null &&
                  videoProvider.repliesVideos == null)) {
            //to show circular progress indicator while loading
            //data
            return AspectRatio(
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
            );
          }
          // currentVideos =
          //     videoProvider.repliesVideos ?? videoProvider.mainVideos!;
          // context.read<VideoProvider>().updateHorizontalVideosList(
          //     context.read<VideoProvider>().horizontalVideosList
          //       ..add(currentVideos));
          return const HorizontalPageView(
              // siblingVideos: currentVideos
              );
          //  PageView.builder(
          //   onPageChanged: (value) {
          //     AppLogger.logMessage("value on page change -> $value");
          //   },
          //   // scrollDirection: Axis.vertical,
          //   itemCount:2,// currentVideos.length,
          //   itemBuilder: (context, index) => VideoPlayer(
          //       deviceHeight: deviceHeight,
          //       deviceWidth: deviceWidth,
          //       videoPost: currentVideos[index]),
          // );
        },
      ),
    );
  }
}

class VideoPlayer extends StatefulWidget {
  // final int? parentVideoId;
  final VideoPost videoPost;
  final String? parentTitle;
  final double deviceWidth;
  final double deviceHeight;
  const VideoPlayer({
    required this.videoPost,
    required this.deviceHeight,
    required this.deviceWidth,
    required this.parentTitle,
    // required this.parentVideoId,
    super.key,
  });

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  VideoPost get videoPostData => widget.videoPost;
  BetterPlayerController? _betterPlayerController;
  @override
  void initState() {
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoDispose: true,

        placeholder: AspectRatio(
          aspectRatio: widget.deviceWidth / widget.deviceHeight,
          child: Image.network(videoPostData.thumbnailUrl ?? ""),
        ),
        subtitlesConfiguration: const BetterPlayerSubtitlesConfiguration(),
        fit: BoxFit.cover,
        autoPlay: true,
        aspectRatio: widget.deviceWidth / widget.deviceHeight,
        handleLifecycle: true,
        // autoDispose: false,
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        videoPostData.videoLink,
        bufferingConfiguration: const BetterPlayerBufferingConfiguration(
            minBufferMs: 2000,
            maxBufferMs: 10000,
            bufferForPlaybackMs: 1000,
            bufferForPlaybackAfterRebufferMs: 2000),
      ),
    );
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (timeStamp) {
    //     if (videoPostData.childVideoCount > 0) {
    //       context.read<VideoProvider>().addPlaceHolderToHorizontalList();
    //     }
    //   },
    // );
    super.initState();
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Consumer<VideoProvider>(
      builder: (context, videoProvider, child) {
        return GestureDetector(
          // onHorizontalDragEnd: (details) async {
          //   if (details.primaryVelocity != null) {
          //     if (details.primaryVelocity! > 0) {
          //       //left swiped
          //       //to do: show parent video if exists
          //       if (videoPostData.parentVideoId != null) {
          //         AppLogger.logMessage(
          //             "left Swipe detected , parentid -> ${videoPostData.toString()}");
          //         Navigator.pop(context);
          //       }
          //     } else if (details.primaryVelocity! < 0) {
          //       AppLogger.logMessage("right Swipe detected");
          //       //right swiped
          //       //to do: show responses video
          //       if (videoPostData.childVideoCount > 0) {
          //         // await context
          //         //     .read<VideoProvider>()
          //         //     .getReplies(videoPostData.id);
          //         if (mounted) {
          //           // ignore: use_build_context_synchronously
          //           Navigator.of(context).push(MaterialPageRoute(
          //               builder: (context) =>
          //                   HomePage(parentId: videoPostData.id)));
          //         }
          //       }
          //     }
          //   }
          // },
          child: Stack(
            children: [
              BetterPlayer(
                controller: _betterPlayerController!,
              ),
              Positioned(
                  bottom: deviceHeight * 0.09,
                  left: 20,
                  child: SizedBox(
                    width: deviceWidth,
                    height: deviceHeight * 0.08,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(videoPostData.title,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  )),
              if (widget.parentTitle != null)
                Positioned(
                    top: deviceHeight * 0.05,
                    // left: 20,
                    child: Container(
                      color: Colors.grey.shade100.withOpacity(0.5),
                      width: deviceWidth,
                      height: deviceHeight * 0.15,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "Response to \n",
                                    style: TextStyle(color: Colors.purple)),
                                TextSpan(
                                    text: widget.parentTitle,
                                    // overflow: TextOverflow.visible,
                                    // softWrap: true,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Colors.black,
                                            overflow: TextOverflow.ellipsis))
                              ]),
                            ),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "X",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ))
                        ],
                      ),
                    ))
            ],
          ),
        );

        SizedBox(
            height: deviceHeight,
            width: deviceWidth,
            child:
                //  BetterPlayerListVideoPlayer(
                //   BetterPlayerDataSource(
                //     BetterPlayerDataSourceType.network,
                //     videoPostData.videoLink,
                //     bufferingConfiguration: BetterPlayerBufferingConfiguration(
                //         minBufferMs: 2000,
                //         maxBufferMs: 10000,
                //         bufferForPlaybackMs: 1000,
                //         bufferForPlaybackAfterRebufferMs: 2000),
                //   ),

                //   configuration: BetterPlayerConfiguration(
                //     subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(),
                //     fit: BoxFit.cover,
                //     autoPlay: false,
                //     aspectRatio: deviceWidth / deviceHeight,
                //     handleLifecycle: true,
                //     // autoDispose: false,
                //   ),
                //   //key: Key(videoListData.hashCode.toString()),

                //   playFraction: 0.8,
                //   betterPlayerListVideoPlayerController: _betterPlayerController,
                // )
                BetterPlayer(
              controller: _betterPlayerController!,
            )
            // .
            // network(
            //     betterPlayerConfiguration: BetterPlayerConfiguration(
            //       placeholder: Image.network(
            //         videoProvider.mainVideos!.first.thumbnailUrl,
            //         fit: BoxFit.fill,
            //       ),
            //       aspectRatio: deviceWidth / deviceHeight,
            //       expandToFill: true,
            //       deviceOrientationsOnFullScreen: [
            //         DeviceOrientation.portraitUp
            //       ],
            //       autoPlay: true,
            //       fullScreenByDefault: true,
            //     ),
            //     videoProvider.mainVideos!.first.videoLink),
            );
      },
    );
  }
}
