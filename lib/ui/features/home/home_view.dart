import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  initVideo() {
    controller = VideoPlayerController.networkUrl(
      Uri.parse(
        // Adicionar seu video aqui
        'https://video.gumlet.io/.../main.m3u8',
      ),
    );
    controller.initialize().then((_) {
      controller.setLooping(true);
      controller.play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video')),
      body:
          !controller.value.isInitialized
              ? Placeholder()
              : InkWell(
                onTap:
                    () => setState(() {
                      controller.value.isPlaying ? controller.pause() : controller.play();
                    }),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    ),
                    if (!controller.value.isPlaying)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey.shade900,
                        ),
                        padding: EdgeInsets.all(16),
                        child: Icon(Icons.play_arrow_rounded, size: 48),
                      ),
                  ],
                ),
              ),
    );
  }
}
