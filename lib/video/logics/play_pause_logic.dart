import 'package:hooks_riverpod/hooks_riverpod.dart'
    show Reader, StateController;
import 'package:video_demo/_features.dart';

abstract class PlayPauseLogic {
  static String get kName => 'PlayPauseLogic';

  double get initialState;
  void play();
  void pause();
}

class PlayPauseLogicImpl implements PlayPauseLogic {
  const PlayPauseLogicImpl({
    required this.reader,
    required this.videoLink,
  });

  final Reader reader;
  final VideoLink videoLink;

  VideoPlayerLogic get _videoLogic {
    return reader(videoPlayerRef(videoLink).notifier);
  }

  StateController<bool> get _isOpenedOverlay {
    return reader(isOpenedOverlay(videoLink).notifier);
  }

  @override
  double get initialState => _videoLogic.isPlaying ? 1.0 : 0.0;

  @override
  void play() {
    _isOpenedOverlay.state = false;
    if (!_videoLogic.isPlaying) _videoLogic.play();
  }

  @override
  void pause() {
    _isOpenedOverlay.state = true;
    if (_videoLogic.isPlaying) _videoLogic.pause();
  }
}
