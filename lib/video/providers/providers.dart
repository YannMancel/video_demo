import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show Provider, StateNotifierProvider, StateProvider;
import 'package:video_demo/_features.dart';

final videoPlayerRef =
    StateNotifierProvider.autoDispose<VideoPlayerLogic, VideoState>(
  (ref) {
    final logic = VideoPlayerLogicImpl(
      reader: ref.read,
      // http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4
      assetPath: Assets.videos.bigBuckBunny,
    );
    ref.onDispose(logic.onDispose);
    return logic;
  },
  name: VideoPlayerLogic.kName,
);

final videoTimerRef =
    StateNotifierProvider.autoDispose<VideoTimerLogic, VideoTimer>(
  (ref) {
    final logic = VideoTimerLogicImpl(reader: ref.read);
    ref.onDispose(logic.onDispose);
    return logic;
  },
  name: 'videoTimerRef',
);

final isOpenedOverlay = StateProvider.autoDispose<bool>(
  (_) => true,
  name: 'isOpenedOverlay',
);

final playPauseLogicRef = Provider.autoDispose<PlayPauseLogic>(
  (ref) => PlayPauseLogicImpl(reader: ref.read),
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
