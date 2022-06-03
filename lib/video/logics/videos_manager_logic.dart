import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart'
    show Reader, StateController, StateNotifier;
import 'package:video_demo/_features.dart';

abstract class VideosManagerLogicInterface {
  static String get kName => 'VideosManagerLogic';
  StateNotifier<List<VideoLink>> get asStateNotifier;
  void setupLogicsOnCurrentAndNextVideoPlayers();
  Stream<int> get currentIndexStream;
  void onDispose();
}

class VideosManagerLogic extends StateNotifier<List<VideoLink>>
    implements VideosManagerLogicInterface {
  VideosManagerLogic({
    required this.reader,
  }) : super(const <VideoLink>[]) {
    _setupCurrentIndex();
    _fetchData();
  }

  final Reader reader;

  late int _currentIndex;
  late StreamController<int> _indexController;

  late VideoPlayerLogicInterface _currentVideoLogic;
  late VideoPlayerLogicInterface _nextVideoLogic;

  late bool _isReadyToPlayCurrentVideo;
  late bool _isReadyToPlayNextVideo;
  late bool _hasCompleteCurrentVideo;

  void _setupCurrentIndex() {
    _currentIndex = -1;
    _indexController = StreamController<int>.broadcast();
  }

  set _index(int value) => _indexController.sink.add(value);

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

  void _currentVideoListener() {
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
  }

  void _nextVideoListener() {
    if (mounted && _canPlayNextVideo) {
      _isReadyToPlayNextVideo = true;
      setupLogicsOnCurrentAndNextVideoPlayers();
    }
  }

  List<VideoLink> get _fakeVideoLinks => reader(fakeVideoLinksRef);

  VideoPlayerLogicInterface _videoLogic({required VideoLink videoLink}) {
    return reader(videoPlayerLogicRef(videoLink));
  }

  StateController<bool> _isOpenedOverlay({required VideoLink videoLink}) {
    return reader(isOpenedOverlay(videoLink).notifier);
  }

  Future<void> _fetchData() async {
    state = _fakeVideoLinks;
  }

  void _removePreviousListeners() {
    if (_currentIndex > -1) _removeListeners();
  }

  void _removeListeners() {
    _currentVideoLogic.removeVideoListener(_currentVideoListener);
    _nextVideoLogic.removeVideoListener(_nextVideoListener);
  }

  void _updateVideoLogics() {
    _currentIndex++;
    _index = _currentIndex;
    _currentVideoLogic = _videoLogic(videoLink: _currentVideoLink);
    if (!_isLastIndex) _nextVideoLogic = _videoLogic(videoLink: _nextVideoLink);
  }

  void _resetTriggers() {
    _isReadyToPlayCurrentVideo = false;
    _isReadyToPlayNextVideo = false;
    _hasCompleteCurrentVideo = false;
  }

  void _addListeners() {
    // The Call methods, on listeners, allow to run again the notify of
    // the video player even when is in stable state without state change.

    _currentVideoListener();
    _currentVideoLogic.addVideoListener(_currentVideoListener);

    if (!_isLastIndex) {
      _nextVideoListener();
      _nextVideoLogic.addVideoListener(_nextVideoListener);
    }
  }

  @override
  StateNotifier<List<VideoLink>> get asStateNotifier => this;

  @override
  void setupLogicsOnCurrentAndNextVideoPlayers() {
    _removePreviousListeners();
    _updateVideoLogics();
    _resetTriggers();
    _addListeners();
  }

  @override
  Stream<int> get currentIndexStream => _indexController.stream.distinct();

  @override
  void onDispose() {
    Future.sync(() async {
      await _indexController.close();
      _removeListeners();
    });
  }
}
