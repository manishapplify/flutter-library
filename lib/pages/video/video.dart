import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

import 'package:components/pages/base_page.dart';

class VideoPage extends BasePage {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoState();
}

class _VideoState extends BasePageState<VideoPage> {
  late BetterPlayerController _betterPlayerController;
  @override
  void initState() {
    const BetterPlayerControlsConfiguration controlsConfiguration =
        BetterPlayerControlsConfiguration(
      controlBarColor: Colors.black26,
      progressBarPlayedColor: Colors.indigo,
      progressBarHandleColor: Colors.indigo,
      controlBarHeight: 40,
      loadingColor: Colors.red,
      overflowModalColor: Colors.black54,
      overflowModalTextColor: Colors.white,
      overflowMenuIconsColor: Colors.white,
    );

    const BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      controlsConfiguration: controlsConfiguration,
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
        fontSize: 16.0,
      ),
    );
    final BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8',
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    super.initState();
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
        title: const Text('Sintel'),
      );

  @override
  Widget body(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(controller: _betterPlayerController),
    );
  }
}
