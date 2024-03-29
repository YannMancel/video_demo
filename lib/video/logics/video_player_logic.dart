import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:hooks_riverpod/hooks_riverpod.dart' show Reader, StateNotifier;
import 'package:video_demo/_features.dart';
import 'package:video_player/video_player.dart' show VideoPlayerController;

abstract class VideoPlayerLogicInterface {
  static String get kName => 'VideoPlayerLogic';
  StateNotifier<VideoState> get asStateNotifier;
  VideoPlayerController get controller;
  double get aspectRatio;
  bool get isInitialized;
  bool get isPlaying;
  bool get isMuted;
  bool get isVideoEnd;
  Future<void> play();
  Future<void> pause();
  Future<void> reset();
  Future<void> setVolume({required double volume});
  Duration get position;
  Duration get duration;
  void addVideoListener(VoidCallback listener);
  void removeVideoListener(VoidCallback listener);
  void onDispose();
}

class VideoPlayerLogic extends StateNotifier<VideoState>
    implements VideoPlayerLogicInterface {
  VideoPlayerLogic({
    required this.reader,
    required VideoLink videoLink,
  }) : super(const VideoState.notInitialized()) {
    _initialize(videoLink: videoLink);
  }

  final Reader reader;
  late VideoPlayerController _controller;

  Future<void> _initialize({required VideoLink videoLink}) async {
    _controller = videoLink.when<VideoPlayerController>(
      network: (videoPath) => VideoPlayerController.network(videoPath),
      asset: (videoPath) => VideoPlayerController.asset(videoPath),
    );
    await _controller.initialize();
    state = const VideoState.initialized();
  }

  @override
  StateNotifier<VideoState> get asStateNotifier => this;

  @override
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
  bool get isVideoEnd => position == duration;

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
  Future<void> reset() async {
    if (isInitialized) {
      await _controller.seekTo(Duration.zero);
      state = const VideoState.initialized();
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
