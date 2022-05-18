import 'package:components/pages/base_page.dart';
import 'package:components/pages/video/widget/videoContolWidget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NetworkPlayerPage extends BasePage {
  const NetworkPlayerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NetworkPlayerState();
}

class _NetworkPlayerState extends BasePageState<NetworkPlayerPage> {
  VideoPlayerController? controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.network(
        'https://multiplatform-f.akamaihd.net/i/multi/will/bunny/big_buck_bunny_,640x360_400,640x360_700,640x360_1000,950x540_1500,.f4v.csmil/master.m3u8')
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller!.play());
  }

  @override
  EdgeInsets get padding => EdgeInsets.zero;

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
        title: const Text('Video Player'),
      );

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget body(BuildContext context) =>
      controller != null && controller!.value.isInitialized
          ? Column(children: <Widget>[
              Stack(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: controller!.value.aspectRatio,
                    child: VideoPlayer(controller!),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: VideoProgressIndicator(
                      controller!,
                      allowScrubbing: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              CustomControlsWidget(
                controller: controller!,
              ),
            ])
          : const Center(child: CircularProgressIndicator());
}
