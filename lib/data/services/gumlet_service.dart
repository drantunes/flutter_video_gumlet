import 'dart:convert';
import 'dart:io';

import 'package:flutter_video_gumlet/domain/models/video.dart';
import 'package:flutter_video_gumlet/env.dart';
import 'package:http/http.dart' as http;

class GumletService {
  Future<List<Video>> loadVideos() async {
    final List<Video> videos = [];
    try {
      final response = await http.get(
        Uri.parse(
          // Check in https://docs.gumlet.com/reference/list-assets
          'https://api.gumlet.com/v1/video/assets/list/COLLECTION?playlist_id=PLAYLIST&sortBy=createdAt&orderBy=desc',
        ),
        headers: {'Authorization': 'Bearer ${Env.gumletApiKey}'},
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map;
        final assets = body['all_assets'];

        for (var i = 0; i < assets.length; i++) {
          var asset = assets[i] as Map<String, dynamic>;

          final video = Video(
            id: i,
            videoUrl: asset['output']['playback_url'] as String,
            thumbUrl: asset['output']['thumbnail_url'][0] as String,
          );
          videos.add(video);
        }
        return videos;
      }
    } on HttpException catch (e) {
      // ToDo: Result Dart
      throw Exception('Erro ao carregar vídeos da API: $e');
    }
    return [];
  }
}
