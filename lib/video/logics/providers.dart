import 'package:hooks_riverpod/hooks_riverpod.dart'
    show StateNotifierProvider, StateProvider;
import 'package:video_demo/_features.dart';

final videoPlayerRef =
    StateNotifierProvider.autoDispose<VideoLogic, VideoState>(
  (ref) {
    final logic = VideoLogicImpl(reader: ref.read);
    ref.onDispose(logic.onDispose);
    return logic;
  },
  name: VideoLogic.kName,
);

final videoTimerRef = StateProvider.autoDispose<VideoTimer>(
  (_) => const VideoTimer(),
  name: 'videoTimerRef',
);

final isOpenedOverlay = StateProvider<bool>(
  (_) => false,
  name: 'isOpenedOverlay',
);
