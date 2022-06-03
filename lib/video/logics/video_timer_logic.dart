import 'package:hooks_riverpod/hooks_riverpod.dart' show Reader, StateNotifier;
import 'package:video_demo/_features.dart';

abstract class VideoTimerLogicInterface {
  static String get kName => 'VideoTimerLogic';
  StateNotifier<VideoTimer> get asStateNotifier;
  void onDispose();
}

class VideoTimerLogic extends StateNotifier<VideoTimer>
    implements VideoTimerLogicInterface {
  VideoTimerLogic({
    required this.reader,
    required this.videoLink,
  }) : super(const VideoTimer()) {
    _initialize();
  }

  final Reader reader;
  final VideoLink videoLink;

  VideoPlayerLogicInterface get _videoLogic {
    return reader(videoPlayerLogicRef(videoLink));
  }

  void _timerListener() {
    if (mounted) {
      state = VideoTimer(
        position: _videoLogic.position,
        duration: _videoLogic.duration,
      );
    }
  }

  Future<void> _initialize() async {
    _timerListener();
    _videoLogic.addVideoListener(_timerListener);
  }

  @override
  StateNotifier<VideoTimer> get asStateNotifier => this;

  @override
  void onDispose() => _videoLogic.removeVideoListener(_timerListener);
}
