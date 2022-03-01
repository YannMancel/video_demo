class VideoTimer {
  const VideoTimer({
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  final Duration position;
  final Duration duration;

  @override
  String toString() {
    return 'VideoTimer [position: $position, duration: $duration]';
  }
}
