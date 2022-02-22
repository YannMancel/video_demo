import 'package:hooks_riverpod/hooks_riverpod.dart'
    show Provider, StateNotifierProvider, StateProvider;
import 'package:video_demo/_features.dart';

final videoPlayerRef =
    StateNotifierProvider.autoDispose<VideoLogic, VideoState>(
  (ref) {
    final logic = VideoLogicImpl(
      reader: ref.read,
      // http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4
      assetPath: Assets.videos.bigBuckBunny,
    );
    ref.onDispose(logic.onDispose);
    return logic;
  },
  name: VideoLogic.kName,
);

final videoTimerRef = StateProvider.autoDispose<VideoTimer>(
  (_) => const VideoTimer(),
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
