import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_demo/_features.dart';

abstract class VideoTimerLogic extends StateNotifier<VideoTimer> {
  VideoTimerLogic({required VideoTimer state}) : super(state);

  static String get kName => 'VideoTimerLogic';

  void onDispose();
}

class VideoTimerLogicImpl extends VideoTimerLogic {
  VideoTimerLogicImpl({
    required this.reader,
    required this.videoLink,
  }) : super(state: const VideoTimer()) {
    _initialize();
  }

  final Reader reader;
  final VideoLink videoLink;
  late VoidCallback _listener;

  VideoPlayerLogic get _videoLogic {
    return reader(videoPlayerRef(videoLink).notifier);
  }

  VoidCallback _initializeListener() {
    return () {
      if (mounted) {
        state = VideoTimer(
          position: _videoLogic.position,
          duration: _videoLogic.duration,
        );
      }
    };
  }

  Future<void> _initialize() async {
    _listener = _initializeListener()..call();
    _videoLogic.addVideoListener(_listener);
  }

  @override
  void onDispose() => _videoLogic.removeVideoListener(_listener);
}
