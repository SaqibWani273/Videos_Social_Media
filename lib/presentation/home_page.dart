import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:persist_ventures/providers/video_provider.dart';
import 'package:persist_ventures/utils/app_logger.dart';
import 'package:provider/provider.dart';

import '../domain/models/video_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<VideoProvider>().getMainVideoPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Consumer<VideoProvider>(
        builder: (context, videoProvider, child) {
          if (videoProvider.mainVideos == null ||
              videoProvider.mainVideos!.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: videoProvider.mainVideos!.length,
              itemBuilder: (context, index) =>
                  VideoPlayer(videoPost: videoProvider.mainVideos![index]));
        },
      ),
    );
  }
}

class VideoPlayer extends StatefulWidget {
  // final int? parentVideoId;
  final VideoPost videoPost;
  const VideoPlayer({
    required this.videoPost,
    // required this.parentVideoId,
    super.key,
  });

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  VideoPost get videoPostData => widget.videoPost;
  BetterPlayerController? _temp;
  // BetterPlayerListVideoPlayerController? _betterPlayerController;
  @override
  void initState() {
    // _betterPlayerController = BetterPlayerListVideoPlayerController();
    _temp = BetterPlayerController(
      BetterPlayerConfiguration(
        subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(),
        fit: BoxFit.cover,
        autoPlay: true,
        aspectRatio: 9 / 16,
        handleLifecycle: true,
        // autoDispose: false,
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        videoPostData.videoLink,
        bufferingConfiguration: BetterPlayerBufferingConfiguration(
            minBufferMs: 2000,
            maxBufferMs: 10000,
            bufferForPlaybackMs: 1000,
            bufferForPlaybackAfterRebufferMs: 2000),
      ),
    );
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) {
    //     if (mounted) {
    //       _betterPlayerController?.play();
    //     }
    //   },
    // );
  }

  @override
  void dispose() {
    _temp?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Consumer<VideoProvider>(
      builder: (context, videoProvider, child) {
        return GestureDetector(
          onHorizontalDragEnd: (details) async {
            if (details.primaryVelocity != null) {
              if (details.primaryVelocity! > 0) {
                //left swiped
                AppLogger.logMessage("left Swipe detected");
                //to do: show parent video
                if (videoPostData.parentVideoId != null) {
                  Navigator.pop(context);
                }
              } else if (details.primaryVelocity! < 0) {
                AppLogger.logMessage("right Swipe detected");
                //right swiped
                //to do: show response video
                if (videoPostData.childVideoCount > 0) {
                  await context
                      .read<VideoProvider>()
                      .getReplies(videoPostData.id);
                  if (mounted) {
                    AppLogger.logMessage(
                        "replies.first id -> ${context.read<VideoProvider>().repliesVideos!.first}");
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VideoPlayer(
                        videoPost:
                            context.read<VideoProvider>().repliesVideos!.first,
                      ),
                    ));
                  }
                }
              }
            }
          },
          child: BetterPlayer(
            controller: _temp!,
          ),
        );

        Container(
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
              controller: _temp!,
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
