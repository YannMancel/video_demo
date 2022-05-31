import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show Reader, StateController, StateNotifier;
import 'package:video_demo/_features.dart';

abstract class MultiVideoManagerLogic extends StateNotifier<List<VideoLink>> {
  MultiVideoManagerLogic({required List<VideoLink> state}) : super(state);

  static String get kName => 'MultiVideoManagerLogic';

  void setupLogicsOnCurrentAndNextVideoPlayers();
  void onDispose();
}

class MultiVideoManagerLogicImpl extends MultiVideoManagerLogic {
  MultiVideoManagerLogicImpl({
    required this.reader,
  }) : super(state: const <VideoLink>[]) {
    _fetchData();
  }

  final Reader reader;

  int _currentIndex = -1;

  late VideoPlayerLogic _currentVideoLogic;
  late VideoPlayerLogic _nextVideoLogic;

  late VoidCallback _currentVideoListener;
  late VoidCallback _nextVideoListener;

  late bool _isReadyToPlayCurrentVideo;
  late bool _isReadyToPlayNextVideo;
  late bool _hasCompleteCurrentVideo;

  VideoLink get _currentVideoLink => state[_currentIndex];
  VideoLink get _nextVideoLink => state[_currentIndex + 1];

  bool get _isLastIndex => _currentIndex == (state.length - 1);

  bool get _canPlayCurrentVideo {
    return _currentVideoLogic.isInitialized &&
        !_currentVideoLogic.isPlaying &&
        !_isReadyToPlayCurrentVideo;
  }

  bool get _canResetCurrentVideo {
    return _currentVideoLogic.isInitialized &&
        _currentVideoLogic.isVideoEnd &&
        !_hasCompleteCurrentVideo;
  }

  bool get _canPlayNextVideo {
    return _nextVideoLogic.isInitialized &&
        !_nextVideoLogic.isPlaying &&
        _hasCompleteCurrentVideo &&
        !_isReadyToPlayNextVideo;
  }

  VoidCallback _currentVideoCallback() {
    return () {
      if (mounted) {
        if (_canPlayCurrentVideo) {
          _isReadyToPlayCurrentVideo = true;
          _currentVideoLogic.play();
          _isOpenedOverlay(videoLink: _currentVideoLink).state = false;
        }

        if (_canResetCurrentVideo) {
          _hasCompleteCurrentVideo = true;
          _currentVideoLogic.reset();
          _isOpenedOverlay(videoLink: _currentVideoLink).state = true;

          if (!_isLastIndex) {
            // Waits that the next video player is initialized
            while (!_isReadyToPlayNextVideo) {
              _nextVideoListener();
              break;
            }
          }
        }
      }
    };
  }

  VoidCallback _nextVideoCallback() {
    return () {
      if (mounted && _canPlayNextVideo) {
        _isReadyToPlayNextVideo = true;
        setupLogicsOnCurrentAndNextVideoPlayers();
      }
    };
  }

  List<VideoLink> get _videoLinks => reader(videoLinksRef);

  VideoPlayerLogic _videoLogic({required VideoLink videoLink}) {
    return reader(videoPlayerRef(videoLink).notifier);
  }

  StateController<bool> _isOpenedOverlay({required VideoLink videoLink}) {
    return reader(isOpenedOverlay(videoLink).notifier);
  }

  Future<void> _fetchData() async {
    state = _videoLinks;
  }

  void _addListeners() {
    // The Call methods,  on listeners, allow to run again the notify of
    // the video player even when is in stable state without state change.

    _currentVideoListener = _currentVideoCallback()..call();
    _currentVideoLogic.addVideoListener(_currentVideoListener);

    if (!_isLastIndex) {
      _nextVideoListener = _nextVideoCallback()..call();
      _nextVideoLogic.addVideoListener(_nextVideoListener);
    }
  }

  void _removeListeners() {
    _currentVideoLogic.removeVideoListener(_currentVideoListener);
    _nextVideoLogic.removeVideoListener(_nextVideoListener);
  }

  void _removePreviousListeners() {
    if (_currentIndex > -1) _removeListeners();
  }

  void _updateVideoLogics() {
    _currentIndex++;
    _currentVideoLogic = _videoLogic(videoLink: _currentVideoLink);
    if (!_isLastIndex) _nextVideoLogic = _videoLogic(videoLink: _nextVideoLink);
  }

  void _resetTriggers() {
    _isReadyToPlayCurrentVideo = false;
    _isReadyToPlayNextVideo = false;
    _hasCompleteCurrentVideo = false;
  }

  @override
  void setupLogicsOnCurrentAndNextVideoPlayers() {
    _removePreviousListeners();
    _updateVideoLogics();
    _resetTriggers();
    _addListeners();
  }

  @override
  void onDispose() => _removeListeners();
}
