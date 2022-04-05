import 'package:components/base/base_page.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/routes/navigation.dart';
import 'package:components/widgets/image_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends BasePage {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends BasePageState<HomePage> {
  late final AuthCubit authCubit;

  @override
  void initState() {
    authCubit = BlocProvider.of(context);
    if (!authCubit.state.isAuthorized) {
      throw Exception('not signed in');
    }
    super.initState();
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => openDrawer(context),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        }),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              navigator.pushNamed(
                Routes.settings,
              );
            },
            icon: const Icon(
              Icons.settings,
            ),
          )
        ],
      );

  @override
  Widget? drawer(BuildContext context) {
    final User user = authCubit.state.user!;
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: ImageContainer(
              imageUrl: user.profilePic,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primary,
            ),
          ),
          Center(
            child: Text(
              'Hello, ${user.fullName}',
              style: textTheme.headline1,
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Feedback'),
            onTap: () => navigator.popAndPushNamed(
              Routes.feedback,
            ),
          ),
          ListTile(
            title: const Text('Report Bug'),
            onTap: () => navigator.popAndPushNamed(
              Routes.reportBug,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Center(
      child: Text(
        'Home',
        style: textTheme.headline1,
      ),
    );
  }
}
