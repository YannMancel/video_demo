import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show Reader, StateController, StateNotifier;
import 'package:video_demo/_features.dart';

abstract class MultiVideoManagerLogic extends StateNotifier<List<VideoLink>> {
  MultiVideoManagerLogic({required List<VideoLink> state}) : super(state);

  static String get kName => 'MultiVideoManagerLogic';

  void start();
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

  bool _isReadyToPlayCurrentVideo = false;
  bool _isReadyToPlayNextVideo = false;
  bool _hasCompleteCurrentVideo = false;
  bool _hasCompleteNextVideo = false;

  bool get _canPlayCurrentVideo {
    return _currentVideoLogic.isInitialized &&
        !_currentVideoLogic.isPlaying &&
        !_isReadyToPlayCurrentVideo;
  }

  bool get _canPauseCurrentVideo {
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

  bool get _canPauseNextVideo {
    return _nextVideoLogic.isInitialized &&
        _nextVideoLogic.isVideoEnd &&
        !_hasCompleteNextVideo;
  }

  VoidCallback _currentVideoCallback() {
    return () {
      if (mounted) {
        if (_canPlayCurrentVideo) {
          _isReadyToPlayCurrentVideo = true;
          _currentVideoLogic.play();
          _isOpenedOverlay(videoLink: state[_currentIndex]).state = false;
          return;
        }

        if (_canPauseCurrentVideo) {
          _hasCompleteCurrentVideo = true;
          _currentVideoLogic.pause();
          _isOpenedOverlay(videoLink: state[_currentIndex]).state = true;

          // Waits that the next video player is initialized
          while (!_isReadyToPlayNextVideo) {
            _nextVideoListener();
          }
        }
      }
    };
  }

  VoidCallback _nextVideoCallback() {
    return () {
      if (mounted) {
        if (_canPlayNextVideo) {
          _isReadyToPlayNextVideo = true;
          _nextVideoLogic.play();
          _isOpenedOverlay(videoLink: state[_currentIndex + 1]).state = false;
        }

        if (_canPauseNextVideo) {
          _hasCompleteNextVideo = true;
          print('''
        --------------------------
        End Video (NEXT)
        --------------------------
        ''');
        }
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
    _currentVideoListener = _currentVideoCallback();
    _nextVideoListener = _nextVideoCallback();

    _currentVideoLogic.addVideoListener(_currentVideoListener);
    _nextVideoLogic.addVideoListener(_nextVideoListener);
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
    _currentVideoLogic = _videoLogic(videoLink: state[_currentIndex]);

    if (_currentIndex == (state.length - 1)) return;
    _nextVideoLogic = _videoLogic(videoLink: state[_currentIndex + 1]);
  }

  @override
  void start() {
    _removePreviousListeners();
    _updateVideoLogics();
    _addListeners();
  }

  @override
  void onDispose() => _removeListeners();
}
