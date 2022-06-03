import 'package:hooks_riverpod/hooks_riverpod.dart'
    show Reader, StateController;
import 'package:video_demo/_features.dart';

abstract class PlayPauseLogicInterface {
  static String get kName => 'PlayPauseLogic';
  double get initialState;
  void play();
  void pause();
}

class PlayPauseLogic implements PlayPauseLogicInterface {
  const PlayPauseLogic({
    required this.reader,
    required this.videoLink,
  });

  final Reader reader;
  final VideoLink videoLink;

  VideoPlayerLogicInterface get _videoLogic {
    return reader(videoPlayerLogicRef(videoLink));
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
