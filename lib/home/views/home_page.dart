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
    final logic = ref.watch(videoPlayerRef.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: videoState.maybeWhen<Widget>(
        notInitialized: () => const Center(child: CircularProgressIndicator()),
        error: (_) => const Center(child: Text('Error')),
        orElse: () => const VideoPlayerWidget(),
      ),
      floatingActionButton: videoState.maybeWhen<Widget>(
        notInitialized: SizedBox.shrink,
        orElse: () {
          return FloatingActionButton(
            onPressed: () {
              logic.isPlaying ? logic.pause() : logic.play();
            },
            child: Icon(
              logic.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          );
        },
      ),
    );
  }
}
