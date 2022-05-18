import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomControlsWidget extends StatelessWidget {
  const CustomControlsWidget({
    required this.controller,
    Key? key,
  }) : super(key: key);
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      buildButton(const Icon(Icons.replay_10), rewind5Seconds),
      const SizedBox(width: 12),
      buildButton(
          controller.value.isPlaying
              ? const Icon(Icons.pause)
              : const Icon(Icons.play_arrow),
          () => controller.value.isPlaying
              ? controller.pause()
              : controller.play()),
      const SizedBox(width: 12),
      buildButton(const Icon(Icons.forward_10), forward5Seconds),
    ],
  );

  Widget buildButton(Widget child, Function()? onPressed) => IconButton(
        icon: child,
        onPressed: onPressed,
        iconSize: 32,
      );

  Future<dynamic> forward5Seconds() async =>
      goToPosition((Duration currentPosition) =>
          currentPosition + const Duration(seconds: 10));

  Future<dynamic> rewind5Seconds() async =>
      goToPosition((Duration currentPosition) =>
          currentPosition - const Duration(seconds: 10));

  Future<dynamic> goToPosition(
    Duration Function(Duration currentPosition) builder,
  ) async {
    final Duration? currentPosition = await controller.position;
    final Duration newPosition = builder(currentPosition!);

    await controller.seekTo(newPosition);
  }
}
