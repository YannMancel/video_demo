import 'package:flutter/services.dart'
    show DeviceOrientation, SystemChrome, SystemUiMode, SystemUiOverlay;
import 'package:wakelock/wakelock.dart' show Wakelock;

abstract class FullscreenLogicInterface {
  static String get kName => 'FullscreenLogic';
  Future<void> openFullscreen();
  Future<void> exitFullscreen();
}

class FullscreenLogic implements FullscreenLogicInterface {
  const FullscreenLogic();

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
