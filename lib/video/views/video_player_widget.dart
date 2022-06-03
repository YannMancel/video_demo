import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show useAnimationController;
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerWidget, HookConsumerWidget, Override, ProviderScope, WidgetRef;
import 'package:video_demo/_features.dart';
import 'package:video_player/video_player.dart'
    show VideoPlayer, VideoProgressIndicator;

class VideoPlayerWidget extends ConsumerWidget {
  const VideoPlayerWidget({
    Key? key,
    required this.videoLink,
    this.isFullscreen = false,
    required this.onTapFullscreenIcon,
  }) : super(key: key);

  final VideoLink videoLink;
  final bool isFullscreen;
  final VoidCallback onTapFullscreenIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoStateRef(videoLink));

    // TODO put AspectRatio here
    return ProviderScope(
      overrides: <Override>[
        isScopedFullscreen.overrideWithValue(isFullscreen),
        onScopedTapFullscreenIcon.overrideWithValue(onTapFullscreenIcon),
        scopedVideoLink.overrideWithValue(videoLink),
      ],
      child: videoState.maybeWhen<Widget>(
        notInitialized: () => const Center(child: CircularProgressIndicator()),
        error: (_) => const Center(child: Text('Error is found.')),
        orElse: () => const _VideoView(),
      ),
    );
  }
}

class _VideoView extends ConsumerWidget {
  const _VideoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoLink = ref.watch(scopedVideoLink);
    final logic = ref.watch(videoPlayerLogicRef(videoLink));

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
    final videoLink = ref.watch(scopedVideoLink);
    final isOpen = ref.watch(isOpenedOverlay(videoLink));

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ref.read(isOpenedOverlay(videoLink).notifier).state = !isOpen;
      },
      child: AnimatedSwitcher(
        duration: _kAnimationDuration,
        child: isOpen ? const ActionOverlay() : const SizedBox.expand(),
      ),
    );
  }
}

class ActionOverlay extends StatelessWidget {
  const ActionOverlay({
    Key? key,
    this.overlayOpacity = 0.4,
  }) : super(key: key);

  final double overlayOpacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: Colors.black.withOpacity(overlayOpacity),
        child: OrientationBuilder(
          builder: (_, orientation) {
            return orientation == Orientation.portrait
                ? const _PortraitOverlay()
                : const _LandscapeOverlay();
          },
        ),
      ),
    );
  }
}

class _PortraitOverlay extends StatelessWidget {
  const _PortraitOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: const <Widget>[
        _PlayPauseButton(),
        Align(
          alignment: Alignment.topRight,
          child: _MoreActionButton(),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: _FullScreenButton(),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: _VideoTimer(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _VideoProgressIndicator(),
        ),
      ],
    );
  }
}

class _LandscapeOverlay extends StatelessWidget {
  const _LandscapeOverlay({Key? key}) : super(key: key);

  // TODO: change format for landscape

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: const <Widget>[
        _PlayPauseButton(),
        Align(
          alignment: Alignment.topRight,
          child: _MoreActionButton(),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: _FullScreenButton(),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: _VideoTimer(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _VideoProgressIndicator(),
        ),
      ],
    );
  }
}

class _PlayPauseButton extends HookConsumerWidget {
  const _PlayPauseButton({
    Key? key,
    // ignore: unused_element
    this.iconSize = 32.0,
  }) : super(key: key);

  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoLink = ref.watch(scopedVideoLink);
    final logic = ref.watch(playPauseLogicRef(videoLink));

    final animationController = useAnimationController(
      duration: kThemeAnimationDuration,
      initialValue: logic.initialState,
    );

    return GestureDetector(
      onTap: () {
        switch (animationController.status) {
          // The animation is stopped at the beginning.
          case AnimationStatus.dismissed:
            animationController.forward();
            logic.play();
            break;
          // The animation is running from beginning to end.
          case AnimationStatus.forward:
          // The animation is running backwards, from end to beginning.
          case AnimationStatus.reverse:
            break;
          // The animation is stopped at the end.
          case AnimationStatus.completed:
            animationController.reverse();
            logic.pause();
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
            size: iconSize,
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
    // ignore: unused_element
    this.margin = const EdgeInsets.all(16.0),
  }) : super(key: key);

  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoLink = ref.watch(scopedVideoLink);
    final videoTimer = ref.watch(videoTimerRef(videoLink));

    final defaultStyle = DefaultTextStyle.of(context).style;

    return Padding(
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

class _ButtonLayout extends StatelessWidget {
  const _ButtonLayout({
    Key? key,
    required this.margin,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  final EdgeInsetsGeometry margin;
  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: margin,
      onPressed: () => onPressed?.call(),
      icon: icon,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }
}

class _FullScreenButton extends ConsumerWidget {
  const _FullScreenButton({
    Key? key,
    // ignore: unused_element
    this.margin = const EdgeInsets.only(bottom: 4.0),
  }) : super(key: key);

  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFullscreen = ref.watch(isScopedFullscreen);
    final onTapFullscreenIcon = ref.watch(onScopedTapFullscreenIcon);

    return _ButtonLayout(
      margin: margin,
      onPressed: onTapFullscreenIcon,
      icon: Icon(
        isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
        color: Colors.white,
      ),
    );
  }
}

class _MoreActionButton extends StatelessWidget {
  const _MoreActionButton({
    Key? key,
    // ignore: unused_element
    this.margin = const EdgeInsets.only(top: 4.0),
  }) : super(key: key);

  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return _ButtonLayout(
      margin: margin,
      onPressed: () {
        // TODO Open Dialog
      },
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
    );
  }
}

class _VideoProgressIndicator extends ConsumerWidget {
  const _VideoProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoLink = ref.watch(scopedVideoLink);
    final logic = ref.watch(videoPlayerLogicRef(videoLink));

    return VideoProgressIndicator(
      logic.controller,
      allowScrubbing: true,
    );
  }
}
