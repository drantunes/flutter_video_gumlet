import 'package:flutter/material.dart';
import 'package:flutter_video_gumlet/data/repositories/videos_repository.dart';
import 'package:flutter_video_gumlet/ui/core/widgets/video_player_viewmodel.dart';
import 'package:flutter_video_gumlet/ui/core/widgets/video_widget.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final PageController pageViewController = PageController(initialPage: 0);
  final VideoPlayerViewModel viewModel = VideoPlayerViewModel(
    repository: VideosRepository(),
  );

  @override
  void initState() {
    super.initState();
    viewModel.getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.videos.isNotEmpty) {
            final videos = viewModel.videos;

            return PageView(
              controller: pageViewController,
              scrollDirection: Axis.vertical,
              pageSnapping: true,
              onPageChanged: (index) => viewModel.videoVisibility(index),

              children: List.generate(
                videos.length,
                (index) => VideoWidget(video: videos[index], playerViewModel: viewModel),
              ),
            );
          }

          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Center(child: Text('Error on getVideos'));
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          spacing: 24,
          children: [
            Icon(Icons.home, size: 30),
            Icon(Icons.search, size: 30),
            Icon(Icons.add_box_outlined, size: 30),
            Icon(Icons.slow_motion_video_rounded, size: 30),
            Icon(Icons.person_outline, size: 30),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }
}
