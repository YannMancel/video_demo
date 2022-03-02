import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_demo/_features.dart';
import 'package:video_player/video_player.dart' show VideoPlayerController;

abstract class VideoPlayerLogic extends StateNotifier<VideoState> {
  VideoPlayerLogic({required VideoState state}) : super(state);

  static String get kName => 'VideoPlayerLogic';

  double get aspectRatio;
  bool get isInitialized;
  bool get isPlaying;
  bool get isMuted;
  Future<void> play();
  Future<void> pause();
  Future<void> setVolume({required double volume});
  Duration get position;
  Duration get duration;
  void addVideoListener(VoidCallback listener);
  void removeVideoListener(VoidCallback listener);
  void onDispose();
}

class VideoPlayerLogicImpl extends VideoPlayerLogic {
  VideoPlayerLogicImpl({
    required this.reader,
    required String assetPath,
  }) : super(state: const VideoState.notInitialized()) {
    _initialize(assetPath: assetPath);
  }

  final Reader reader;
  late VideoPlayerController _controller;

  Future<void> _initialize({required String assetPath}) async {
    _controller = VideoPlayerController.asset(assetPath);
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

  /// The current playback position.
  /// It is [Duration.zero] if the video hasn't been initialized.
  @override
  Duration get position {
    return isInitialized ? _controller.value.position : Duration.zero;
  }

  /// The total duration of the video.
  /// It is [Duration.zero] if the video hasn't been initialized.
  @override
  Duration get duration => _controller.value.duration;

  @override
  void addVideoListener(VoidCallback listener) {
    _controller.addListener(listener);
  }

  @override
  void removeVideoListener(VoidCallback listener) {
    _controller.removeListener(listener);
  }

  @override
  void onDispose() {
    Future.sync(
      () async => await _controller.dispose(),
    );
  }
}
