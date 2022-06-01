import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show Provider, StateNotifierProvider, StateProvider, StreamProvider;
import 'package:video_demo/_features.dart';

final videoLinksRef = Provider<List<VideoLink>>(
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
  name: 'videoLinksRef',
);

final scopedVideoLink = Provider.autoDispose<VideoLink>(
  (_) => throw UnimplementedError('This provider must be override.'),
  name: 'scopedVideoLink',
);

final multiVideoManagerLogicRef =
    StateNotifierProvider.autoDispose<MultiVideoManagerLogic, List<VideoLink>>(
  (ref) {
    final logic = MultiVideoManagerLogicImpl(reader: ref.read);
    ref.onDispose(logic.onDispose);
    return logic;
  },
  name: MultiVideoManagerLogic.kName,
);

final currentIndexStreamRef = StreamProvider.autoDispose<int>(
  (ref) => ref.watch(multiVideoManagerLogicRef.notifier).currentIndexStream,
  name: 'currentIndexStreamRef',
);

final videoPlayerRef = StateNotifierProvider.autoDispose
    .family<VideoPlayerLogic, VideoState, VideoLink>(
  (ref, videoLink) {
    // To avoid autoDispose of this provider and to can manage overlay by
    // MultiVideoManagerLogic
    ref.watch(isOpenedOverlay(videoLink).notifier);

    final logic = VideoPlayerLogicImpl(
      reader: ref.read,
      videoLink: videoLink,
    );
    ref.onDispose(logic.onDispose);
    return logic;
  },
  name: VideoPlayerLogic.kName,
);

final videoTimerRef = StateNotifierProvider.autoDispose
    .family<VideoTimerLogic, VideoTimer, VideoLink>(
  (ref, videoLink) {
    final logic = VideoTimerLogicImpl(
      reader: ref.read,
      videoLink: videoLink,
    );
    ref.onDispose(logic.onDispose);
    return logic;
  },
  name: VideoTimerLogic.kName,
);

final isOpenedOverlay = StateProvider.autoDispose.family<bool, VideoLink>(
  (_, __) => true,
  name: 'isOpenedOverlay',
);

final playPauseLogicRef =
    Provider.autoDispose.family<PlayPauseLogic, VideoLink>(
  (ref, videoLink) => PlayPauseLogicImpl(
    reader: ref.read,
    videoLink: videoLink,
  ),
  name: PlayPauseLogic.kName,
);

final fullscreenLogicRef = Provider.autoDispose<FullscreenLogic>(
  (_) => const FullscreenLogicImpl(),
  name: FullscreenLogic.kName,
);

final isScopedFullscreen = Provider.autoDispose<bool>(
  (_) => throw UnimplementedError('This provider must be override.'),
  name: 'isScopedFullscreen',
);

final onScopedTapFullscreenIcon = Provider.autoDispose<VoidCallback>(
  (_) => throw UnimplementedError('This provider must be override.'),
  name: 'onScopedTapFullscreenIcon',
);
