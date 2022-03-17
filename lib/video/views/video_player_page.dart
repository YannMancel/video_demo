import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'
    show useAnimationController, useState, useTransformationController;
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show HookConsumerWidget, WidgetRef;
import 'package:video_demo/_features.dart';

class VideoPlayerPage extends HookConsumerWidget {
  const VideoPlayerPage({
    Key? key,
    this.backgroundColor = Colors.black,
    this.hasInteractiveViewer = true,
  }) : super(key: key);

  final Color backgroundColor;
  final bool hasInteractiveViewer;

  Future<void> _exitFullscreen(WidgetRef ref) async {
    final logic = ref.read(fullscreenLogicRef);
    await logic.exitFullscreen();
  }

  void _resetScale({
    required TransformationController transformationController,
    required AnimationController animationController,
    required ValueNotifier<bool> notifier,
  }) {
    final animation = Matrix4Tween(
      begin: transformationController.value,
      end: Matrix4.identity(),
    ).animate(animationController);

    animation.addListener(() {
      transformationController.value = animation.value;
      if (animation.value.getMaxScaleOnAxis() == 1) notifier.value = false;
    });

    animationController.reset();
    animationController.forward();
  }

  void _analyseScale({
    required TransformationController controller,
    required ValueNotifier<bool> notifier,
  }) {
    final scale = controller.value.getMaxScaleOnAxis();

    if (scale == 1.0 && notifier.value == true) {
      notifier.value = false;
      return;
    }

    if (scale > 1.0 && notifier.value == false) {
      notifier.value = true;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transformationController = useTransformationController();
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );
    final isScaled = useState<bool>(false);

    return WillPopScope(
      onWillPop: () async {
        await _exitFullscreen(ref);
        return true;
      },
      child: Material(
        color: backgroundColor,
        child: Stack(
          children: <Widget>[
            Center(
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                minScale: 1.0,
                maxScale: 5.0,
                scaleEnabled: hasInteractiveViewer,
                transformationController: transformationController,
                onInteractionUpdate: (_) => _analyseScale(
                  controller: transformationController,
                  notifier: isScaled,
                ),
                child: VideoPlayerWidget(
                  isFullscreen: true,
                  onTapFullscreenIcon: () async {
                    await _exitFullscreen(ref);
                    Navigator.of(context).pop<void>();
                  },
                ),
              ),
            ),
            if (isScaled.value)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: <Color>[
                        backgroundColor.withOpacity(0.4),
                        Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => _resetScale(
                      transformationController: transformationController,
                      animationController: animationController,
                      notifier: isScaled,
                    ),
                    icon: const Icon(
                      Icons.restore,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
