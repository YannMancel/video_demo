import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show
        Provider,
        StateNotifier,
        StateNotifierProvider,
        StateProvider,
        StreamProvider;
import 'package:video_demo/_features.dart';

final fakeVideoLinksRef = Provider<List<VideoLink>>(
  (_) => <VideoLink>[
    VideoLink.asset(videoPath: Assets.videos.butterfly),
    const VideoLink.network(
      videoPath: 'https://assets.mixkit.co/'
          'videos/'
          'preview/'
          'mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement'
          '-park-1226-large.mp4',
    ),
    const VideoLink.network(
      videoPath: 'https://commondatastorage.googleapis.com/'
          'gtv-videos-bucket/sample/BigBuckBunny.mp4',
    ),
  ],
  name: 'fakeVideoLinksRef',
);

final scopedVideoLink = Provider.autoDispose<VideoLink>(
  (_) => throw UnimplementedError('This provider must be override.'),
  name: 'scopedVideoLink',
);

final videosManagerLogicRef = Provider.autoDispose<VideosManagerLogicInterface>(
  (ref) {
    final logic = VideosManagerLogic(reader: ref.read);
    ref.onDispose(logic.onDispose);
    return logic;
  },
  name: VideosManagerLogicInterface.kName,
);

final videoLinksRef = StateNotifierProvider.autoDispose<
    StateNotifier<List<VideoLink>>, List<VideoLink>>(
  (ref) {
    final logic = ref.watch(videosManagerLogicRef);
    return logic.asStateNotifier;
  },
  name: 'videoLinksRef',
);

final currentIndexStreamRef = StreamProvider.autoDispose<int>(
  (ref) => ref.watch(videosManagerLogicRef).currentIndexStream,
  name: 'currentIndexStreamRef',
);

final videoPlayerLogicRef =
    Provider.autoDispose.family<VideoPlayerLogicInterface, VideoLink>(
  (ref, videoLink) {
    final logic = VideoPlayerLogic(
      reader: ref.read,
      videoLink: videoLink,
    );
    ref.onDispose(logic.onDispose);
    return logic;
  },
  name: VideoPlayerLogicInterface.kName,
);

final videoStateRef = StateNotifierProvider.autoDispose
    .family<StateNotifier<VideoState>, VideoState, VideoLink>(
  (ref, videoLink) {
    // To avoid autoDispose of this provider and to can manage overlay by
    // MultiVideoManagerLogic
    ref.watch(isOpenedOverlay(videoLink).notifier);

    final logic = ref.watch(videoPlayerLogicRef(videoLink));
    return logic.asStateNotifier;
  },
  name: 'videoStateRef',
);

final _videoTimerLogicRef =
    Provider.autoDispose.family<VideoTimerLogicInterface, VideoLink>(
  (ref, videoLink) {
    final logic = VideoTimerLogic(
      reader: ref.read,
      videoLink: videoLink,
    );
    ref.onDispose(logic.onDispose);
    return logic;
  },
  name: VideoTimerLogicInterface.kName,
);

final videoTimerRef = StateNotifierProvider.autoDispose
    .family<StateNotifier<VideoTimer>, VideoTimer, VideoLink>(
  (ref, videoLink) {
    final logic = ref.watch(_videoTimerLogicRef(videoLink));
    return logic.asStateNotifier;
  },
  name: 'videoTimerRef',
);

final isOpenedOverlay = StateProvider.autoDispose.family<bool, VideoLink>(
  (_, __) => true,
  name: 'isOpenedOverlay',
);

final playPauseLogicRef =
    Provider.autoDispose.family<PlayPauseLogicInterface, VideoLink>(
  (ref, videoLink) => PlayPauseLogic(
    reader: ref.read,
    videoLink: videoLink,
  ),
  name: PlayPauseLogicInterface.kName,
);

final fullscreenLogicRef = Provider.autoDispose<FullscreenLogicInterface>(
  (_) => const FullscreenLogic(),
  name: FullscreenLogicInterface.kName,
);

final isScopedFullscreen = Provider.autoDispose<bool>(
  (_) => throw UnimplementedError('This provider must be override.'),
  name: 'isScopedFullscreen',
);

final onScopedTapFullscreenIcon = Provider.autoDispose<VoidCallback>(
  (_) => throw UnimplementedError('This provider must be override.'),
  name: 'onScopedTapFullscreenIcon',
);
