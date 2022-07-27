import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, useState;
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show AsyncValue, AsyncValueX, ConsumerWidget, HookConsumerWidget, WidgetRef;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart'
    show ItemScrollController, ScrollablePositionedList;
import 'package:video_demo/_features.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoLinks = ref.watch(videoLinksRef);

    // Waits the first frame to setup listeners on video logic providers
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(videosManagerLogicRef)
            .setupLogicsOnCurrentAndNextVideoPlayers();
      });
      return null;
    }, const <Object?>[]);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: videoLinks.isEmpty
          ? const Center(
              child: Text('No video'),
            )
          : _HomeView(videoLinks: videoLinks),
    );
  }
}

class _HomeView extends HookConsumerWidget {
  const _HomeView({
    Key? key,
    required this.videoLinks,
  }) : super(key: key);

  final List<VideoLink> videoLinks;

  Future<void> _scrollTo({
    required ItemScrollController controller,
    required int index,
  }) async {
    return controller.scrollTo(
      index: index,
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useState<ItemScrollController>(ItemScrollController());

    ref.listen<AsyncValue<int>>(currentIndexStreamRef, (_, next) {
      if (next.asData != null) {
        _scrollTo(
          controller: controller.value,
          index: next.asData!.value,
        );
      }
    });

    return ScrollablePositionedList.builder(
      itemScrollController: controller.value,
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
      itemBuilder: (_, index) {
        final videoLink = videoLinks[index];
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: _VideoCard(videoLink: videoLink),
        );
      },
      itemCount: videoLinks.length,
    );
  }
}

class _VideoCard extends ConsumerWidget {
  const _VideoCard({
    Key? key,
    required this.videoLink,
  }) : super(key: key);

  final VideoLink videoLink;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      child: VideoPlayerWidget(
        videoLink: videoLink,
        onTapFullscreenIcon: () {
          Future.sync(() async {
            final logic = ref.read(fullscreenLogicRef);
            await logic.openFullscreen();
          });

          Navigator.of(context).push(
            FadeTransitionRoute(
              page: FullscreenVideoPage(videoLink: videoLink),
            ),
          );
        },
      ),
    );
  }
}
