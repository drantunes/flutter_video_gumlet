import 'package:flutter/material.dart';
import 'package:flutter_video_gumlet/domain/models/video.dart';
import 'package:flutter_video_gumlet/ui/core/widgets/video_player_viewmodel.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatelessWidget {
  final Video video;
  final VideoPlayerViewModel playerViewModel;
  const VideoWidget({super.key, required this.video, required this.playerViewModel});

  toggleVideo() {
    playerViewModel.isPlaying(video)
        ? playerViewModel.pauseVideo(video)
        : playerViewModel.playVideo(video);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: playerViewModel,
      builder: (context, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            playerViewModel.isInitialized(video)
                ? InkWell(
                  onTap: toggleVideo,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: playerViewModel.aspectRatioOf(video),
                        child: VideoPlayer(playerViewModel.getControllerOf(video)),
                      ),

                      if (!playerViewModel.isPlaying(video))
                        Image.network(video.thumbUrl),

                      AnimatedScale(
                        scale: (!playerViewModel.isPlaying(video)) ? 1 : 0,
                        duration: Durations.short3,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey.shade900,
                          ),
                          padding: EdgeInsets.all(16),
                          child: Icon(Icons.play_arrow_rounded, size: 48),
                        ),
                      ),
                    ],
                  ),
                )
                : Container(),

            SizedBox(
              height: 2,
              child: VideoProgressIndicator(
                playerViewModel.getControllerOf(video),
                allowScrubbing: false,
                colors: VideoProgressColors(
                  backgroundColor: Colors.grey.shade900,
                  bufferedColor: Colors.grey.shade900,
                  playedColor: Colors.white,
                ),
                padding: EdgeInsets.all(0),
              ),
            ),
          ],
        );
      },
    );
  }
}
