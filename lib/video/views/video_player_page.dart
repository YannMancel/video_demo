import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:video_demo/_features.dart';

class VideoPlayerPage extends ConsumerWidget {
  const VideoPlayerPage({
    Key? key,
    this.backgroundColor = Colors.black,
    this.hasInteractiveViewer = true,
  }) : super(key: key);

  final Color backgroundColor;
  final bool hasInteractiveViewer;

  Future<void> _exitFullscreen(WidgetRef ref) async {
    final logic = ref.read(fullscreenLogicRef);
    await logic.exitFullscreen();
  }

  double get _minScale => hasInteractiveViewer ? 0.8 : 1.0;
  double get _maxScale => hasInteractiveViewer ? 5.0 : 1.0;

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
          child: InteractiveViewer(
            clipBehavior: Clip.none,
            minScale: _minScale,
            maxScale: _maxScale,
            child: VideoPlayerWidget(
              isFullscreen: true,
              onTapFullscreenIcon: () async {
                await _exitFullscreen(ref);
                Navigator.of(context).pop<void>();
              },
            ),
          ),
        ),
      ),
    );
  }
}
