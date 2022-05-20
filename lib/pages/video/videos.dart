import 'package:components/common/widgets/image_container.dart';
import 'package:components/pages/base_page.dart';
import 'package:components/routes/navigation.dart';
import 'package:flutter/material.dart';

class VideosPage extends BasePage {
  const VideosPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideosState();
}

class _VideosState extends BasePageState<VideosPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
        title: const Text('Videos'),
      );

  @override
  Widget body(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, int index) => Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(3),
          ),
          color: Colors.grey[100],
        ),
        child: InkWell(
          onTap: () => navigator.pushNamed(
            Routes.video,
          ),
          child: const Icon(
            Icons.play_circle_rounded,
            size: 150,
          ),
        ),
      ),
    );
  }
}
