import 'package:flutter_video_gumlet/data/services/gumlet_service.dart';
import 'package:flutter_video_gumlet/domain/models/video.dart';

class VideosRepository {
  List<Video> videos = [];
  GumletService gumletService;

  VideosRepository() : gumletService = GumletService();

  Future<List<Video>> getVideos() async {
    if (videos.isNotEmpty) return videos;
    return await loadVideos();
  }

  Future<List<Video>> loadVideos() async {
    videos = await gumletService.loadVideos();
    return videos;
  }
}
