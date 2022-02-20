import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show useAnimationController;
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerWidget, HookConsumerWidget, WidgetRef;
import 'package:video_demo/_features.dart';
import 'package:video_player/video_player.dart' show VideoPlayer;

class VideoPlayerWidget extends ConsumerWidget {
  const VideoPlayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoPlayerRef);

    // TODO put AspectRatio here
    return videoState.maybeWhen<Widget>(
      notInitialized: () => const Center(child: CircularProgressIndicator()),
      error: (_) => const Center(child: Text('Error')),
      orElse: () => const _VideoView(),
    );
  }
}

class _VideoView extends ConsumerWidget {
  const _VideoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logic = ref.watch(videoPlayerRef.notifier) as VideoLogicImpl;

    return AspectRatio(
      aspectRatio: logic.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          VideoPlayer(logic.controller),
          const _Overlay(),
        ],
      ),
    );
  }
}

class _Overlay extends ConsumerWidget {
  const _Overlay({Key? key}) : super(key: key);

  static const _kAnimationDuration = Duration(seconds: 1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(isOpenedOverlay);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => ref.watch(isOpenedOverlay.notifier).state = !isOpen,
      child: AnimatedSwitcher(
        duration: _kAnimationDuration,
        child: isOpen ? const ActionOverlay() : const SizedBox.expand(),
      ),
    );
  }
}

class ActionOverlay extends StatelessWidget {
  const ActionOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: Colors.black.withOpacity(0.4),
        child: Stack(
          alignment: Alignment.center,
          children: const <Widget>[
            _PlayPauseButton(),
            Align(
              alignment: Alignment.bottomLeft,
              child: _VideoTimer(),
            ),
          ],
        ),
      ),
    );

    /*
      onTap: () => logic.isPlaying ? logic.pause() : logic.play(),
                if (!logic.isPlaying)
                  const Center(
                    child: Icon(
                      Icons.play_arrow,
                      size: 32.0,
                      color: Colors.white,
                    ),
                  ),
        VideoProgressIndicator(
          logic.controller,
          allowScrubbing: true,
        ),
    */
  }
}

class _PlayPauseButton extends HookConsumerWidget {
  const _PlayPauseButton({Key? key}) : super(key: key);

  static const _kIconSize = 32.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(
      duration: kThemeAnimationDuration,
    );

    return GestureDetector(
      onTap: () {
        switch (animationController.status) {
          // The animation is stopped at the beginning.
          case AnimationStatus.dismissed:
            animationController.forward();
            ref.watch(isOpenedOverlay.notifier).state = false;
            break;
          // The animation is running from beginning to end.
          case AnimationStatus.forward:
          // The animation is running backwards, from end to beginning.
          case AnimationStatus.reverse:
            break;
          // The animation is stopped at the end.
          case AnimationStatus.completed:
            animationController.reverse();
            ref.watch(isOpenedOverlay.notifier).state = true;
            break;
        }
      },
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: AnimatedIcon(
            size: _kIconSize,
            icon: AnimatedIcons.play_pause,
            progress: animationController,
          ),
        ),
      ),
    );
  }
}

class _VideoTimer extends ConsumerWidget {
  const _VideoTimer({
    Key? key,
    this.margin = const EdgeInsets.all(8.0),
  }) : super(key: key);

  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoTimer = ref.watch(videoTimerRef);

    final defaultStyle = DefaultTextStyle.of(context).style;

    return Ink(
      padding: margin,
      child: RichText(
        text: TextSpan(
          text: videoTimer.position.withFormat,
          style: defaultStyle.copyWith(color: Colors.white),
          children: <TextSpan>[
            TextSpan(
              text: ' / ${videoTimer.duration.withFormat}',
              style: defaultStyle.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
