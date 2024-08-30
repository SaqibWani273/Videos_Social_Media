import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/video_post.dart';
import '../../providers/video_provider.dart';

class VideoPlayer extends StatefulWidget {
  final VideoPost videoPost;
  final String? parentTitle;
  final double deviceWidth;
  final double deviceHeight;
  const VideoPlayer({
    required this.videoPost,
    required this.deviceHeight,
    required this.deviceWidth,
    required this.parentTitle,
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
                                const TextSpan(
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
                              child: const Text(
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
      },
    );
  }
}
