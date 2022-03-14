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
    final videoState = ref.watch(videoPlayerRef);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: videoState.maybeWhen<Widget>(
          notInitialized: () => const CircularProgressIndicator(),
          error: (_) => const Text('Error'),
          orElse: () => VideoPlayerWidget(
            onTapFullscreenIcon: () async {
              final logic = ref.read(fullscreenLogicRef);
              await logic.openFullscreen();

              Navigator.of(context).push(
                FadeTransitionRoute(
                  page: const VideoPlayerPage(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
