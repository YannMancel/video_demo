import 'package:flutter/services.dart'
    show DeviceOrientation, SystemChrome, SystemUiMode, SystemUiOverlay;
import 'package:wakelock/wakelock.dart' show Wakelock;

abstract class FullscreenLogic {
  static String get kName => 'FullscreenLogic';

  Future<void> openFullscreen();
  Future<void> exitFullscreen();
}

class FullscreenLogicImpl implements FullscreenLogic {
  const FullscreenLogicImpl();

  @override
  Future<void> openFullscreen() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    await Wakelock.enable();
  }

  @override
  Future<void> exitFullscreen() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    await Wakelock.disable();
  }
}
