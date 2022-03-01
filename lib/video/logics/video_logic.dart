import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_demo/_features.dart';
import 'package:video_player/video_player.dart' show VideoPlayerController;

abstract class VideoLogic extends StateNotifier<VideoState> {
  VideoLogic({required VideoState state}) : super(state);

  static String get kName => 'VideoLogic';

  double get aspectRatio;
  bool get isInitialized;
  bool get isPlaying;
  bool get isMuted;
  Future<void> play();
  Future<void> pause();
  Future<void> setVolume({required double volume});
  void onDispose();
}

class VideoLogicImpl extends VideoLogic {
  VideoLogicImpl({
    // http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4
    String assetPath = 'assets/videos/Butterfly.mp4',
    required this.reader,
  }) : super(state: const VideoState.notInitialized()) {
    _initialize(assetPath: assetPath);
  }

  final Reader reader;
  late VideoPlayerController _controller;
  late VoidCallback _listener;

  VoidCallback _initializeListener() {
    return () {
      final videoTimerLogic = reader(videoTimerRef.notifier);
      if (videoTimerLogic.mounted) {
        videoTimerLogic.state = VideoTimer(
          /// The current playback position.
          /// It is [Duration.zero] if the video hasn't been initialized.
          position: isInitialized ? _controller.value.position : Duration.zero,

          /// The total duration of the video.
          /// It is [Duration.zero] if the video hasn't been initialized.
          duration: _controller.value.duration,
        );
      }
    };
  }

  Future<void> _initialize({required String assetPath}) async {
    _listener = _initializeListener();
    _controller = VideoPlayerController.asset(assetPath)
      ..addListener(_listener);

    await _controller.initialize();

    state = const VideoState.initialized();
  }

  VideoPlayerController get controller => _controller;

  @override
  double get aspectRatio => _controller.value.aspectRatio;

  @override
  bool get isInitialized => _controller.value.isInitialized;

  @override
  bool get isPlaying => _controller.value.isPlaying;

  @override
  bool get isMuted => _controller.value.volume == 0.0;

  @override
  Future<void> play() async {
    if (isInitialized && !isPlaying) {
      await _controller.play();
      state = const VideoState.play();
    }
  }

  @override
  Future<void> pause() async {
    if (isInitialized && isPlaying) {
      await _controller.pause();
      state = const VideoState.pause();
    }
  }

  @override
  Future<void> setVolume({required double volume}) async {
    if (isInitialized) {
      await _controller.setVolume(volume);
    }
  }

  @override
  void onDispose() {
    _controller.removeListener(_listener);
    Future.sync(
      () async => await _controller.dispose(),
    );
  }
}
