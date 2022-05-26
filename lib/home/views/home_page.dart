import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:video_demo/_features.dart';

class HomePage extends ConsumerWidget {
  const HomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoLinks = ref.watch(videoLinksRef);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
        itemBuilder: (_, index) {
          final videoLink = videoLinks[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _VideoCard(videoLink: videoLink),
          );
        },
        itemCount: videoLinks.length,
      ),
    );
  }
}

class _VideoCard extends ConsumerWidget {
  const _VideoCard({
    Key? key,
    required this.videoLink,
  }) : super(key: key);

  final VideoLink videoLink;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      child: VideoPlayerWidget(
        videoLink: videoLink,
        onTapFullscreenIcon: () {
          Future.sync(() async {
            final logic = ref.read(fullscreenLogicRef);
            await logic.openFullscreen();
          });

          Navigator.of(context).push(
            FadeTransitionRoute(
              page: FullscreenVideoPage(videoLink: videoLink),
            ),
          );
        },
      ),
    );
  }
}
