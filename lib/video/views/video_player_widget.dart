import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:video_demo/_features.dart';
import 'package:video_player/video_player.dart'
    show VideoPlayer, VideoProgressIndicator;

class VideoPlayerWidget extends ConsumerWidget {
  const VideoPlayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoPlayerRef);
    final logic = ref.watch(videoPlayerRef.notifier) as VideoLogicImpl;

    return videoState.maybeWhen<Widget>(
      notInitialized: () => const Center(child: CircularProgressIndicator()),
      error: (_) => const Center(child: Text('Error')),
      orElse: () {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => logic.isPlaying ? logic.pause() : logic.play(),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              AspectRatio(
                aspectRatio: logic.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    VideoPlayer(logic.controller),
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: _VideoTimer(),
                    ),
                    if (!logic.isPlaying)
                      const Center(
                        child: Icon(
                          Icons.play_arrow,
                          size: 32.0,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
              VideoProgressIndicator(
                logic.controller,
                allowScrubbing: true,
              ),
            ],
          ),
        );
      },
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
          style: defaultStyle,
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

/*class _VideoTime extends ConsumerStatefulWidget {
  const _VideoTime({
    Key? key,
    this.margin = const EdgeInsets.all(8.0),
  }) : super(key: key);

  final EdgeInsetsGeometry margin;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideoTimeState();
}

class _VideoTimeState extends ConsumerState<_VideoTime> {
  late Duration _position;
  late Duration _duration;
  late VoidCallback _listener;

  VideoLogicImpl get logic {
    return ref.watch(videoPlayerRef.notifier) as VideoLogicImpl;
  }

  @override
  void initState() {
    super.initState();

    _position = Duration.zero;
    _duration = Duration.zero;
    _listener = () {
      if (mounted) {
        setState(() {
          _position = logic.position;
          _duration = logic.duration;
        });
      }
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    logic.controller.addListener(_listener);
  }

  @override
  void dispose() {
    logic.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;

    return Ink(
      padding: widget.margin,
      child: RichText(
        text: TextSpan(
          text: _position.withFormat,
          style: defaultStyle,
          children: <TextSpan>[
            TextSpan(
              text: ' / ${_duration.withFormat}',
              style: defaultStyle.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}*/
