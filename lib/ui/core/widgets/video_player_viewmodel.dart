import 'package:flutter/material.dart';
import 'package:flutter_video_gumlet/data/repositories/videos_repository.dart';
import 'package:flutter_video_gumlet/domain/models/video.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerViewModel extends ChangeNotifier {
  final VideosRepository repository;
  Map<String, VideoPlayerController> videoControllers = {};
  List<Video> videos = [];
  bool isLoading = true;

  VideoPlayerViewModel({required this.repository});

  getVideos() async {
    isLoading = true;
    notifyListeners();

    videos = await repository.getVideos();
    for (var video in videos) {
      await addVideo(video);
    }
    playVideo(videos.first);

    isLoading = false;
    notifyListeners();
  }

  addVideo(Video video) async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(video.videoUrl));
    await controller.initialize();
    await controller.setLooping(true);
    videoControllers.putIfAbsent(video.videoUrl, () => controller);
  }

  playVideo(Video video) {
    videoControllers[video.videoUrl]?.play();
    notifyListeners();
  }

  pauseVideo(Video video) {
    videoControllers[video.videoUrl]?.pause();
    notifyListeners();
  }

  bool isPlaying(Video video) {
    return videoControllers[video.videoUrl]?.value.isPlaying ?? false;
  }

  double aspectRatioOf(Video video) {
    return videoControllers[video.videoUrl]?.value.aspectRatio ?? 1;
  }

  bool isInitialized(Video video) {
    return videoControllers[video.videoUrl]?.value.isInitialized ?? false;
  }

  VideoPlayerController getControllerOf(Video video) {
    return videoControllers[video.videoUrl]!;
  }

  videoVisibility(int id) async {
    for (var controller in videoControllers.values) {
      controller.pause();
    }
    playVideo(repository.videos[id]);
    notifyListeners();
  }

  @override
  void dispose() {
    for (var controller in videoControllers.values) {
      controller.dispose();
    }
    videoControllers = {};
    super.dispose();
  }
}
