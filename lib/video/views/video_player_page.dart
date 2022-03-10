import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:video_demo/_features.dart';

class VideoPlayerPage extends ConsumerWidget {
  const VideoPlayerPage({
    Key? key,
    this.backgroundColor = Colors.black,
  }) : super(key: key);

  final Color backgroundColor;

  Future<void> _exitFullscreen(WidgetRef ref) async {
    final logic = ref.read(fullscreenLogicRef);
    await logic.exitFullscreen();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        await _exitFullscreen(ref);
        return true;
      },
      child: Material(
        color: backgroundColor,
        child: Center(
          child: VideoPlayerWidget(
            isFullscreen: true,
            onTapFullscreenIcon: () async {
              await _exitFullscreen(ref);
              Navigator.of(context).pop<void>();
            },
          ),
        ),
      ),
    );
  }
}
