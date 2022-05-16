import 'dart:io';

import 'package:components/blocs/blocs.dart';
import 'package:components/common/bottomsheets.dart';
import 'package:components/common/work_status.dart';
import 'package:components/pages/base_page.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/common/app_exception.dart';
import 'package:components/routes/navigation.dart';

import 'package:components/common/widgets/image_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends BasePage {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends BasePageState<HomePage> {
  late final AuthCubit authCubit;
  late final HomeBloc homeBloc;

  @override
  void initState() {
    authCubit = BlocProvider.of(context);
    if (!authCubit.state.isAuthorized) {
      throw AppException.authenticationException();
    }
    homeBloc = BlocProvider.of(context);
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
          ),
        ],
      );

  @override
  Widget? drawer(BuildContext context) {
    return Drawer(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (BuildContext context, AuthState state) {
          if (!state.isAuthorized) {
            throw AppException.authenticationException();
          }

          final User user = authCubit.state.user!;
          return ListView(
            children: <Widget>[
              DrawerHeader(
                padding: const EdgeInsets.all(30.0),
                child: ImageContainer(
                  imageUrl: (user.profilePic is String)
                      ? (homeBloc.imageBaseUrl + user.profilePic!)
                      : null,
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
                title: const Text('Chats'),
                onTap: () => navigator.popAndPushNamed(
                  Routes.chats,
                ),
              ),
              ListTile(
                title: const Text('Notifications'),
                onTap: () => navigator.pushNamed(
                  Routes.notifications,
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
          );
        },
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (BuildContext context, HomeState state) {
        final bool _isLoading = state.blocStatus is InProgress ||
            state.imageUploadStatus is InProgress;
        if (_isLoading != isLoading) {
          Future<void>.microtask(() => isLoading = _isLoading);
        }
        if (state.imageUploadStatus is Failure) {
          final Failure failure = state.imageUploadStatus as Failure;
          Future<void>.microtask(
            () => showSnackBar(
              SnackBar(
                content: Text(failure.message ?? 'Failure'),
              ),
            ),
          );

          homeBloc.add(ResetImageUploadStatus());
        }

        final List<String> uploadedImageUrls = state.uploadedImageUrls;

        return Column(
          children: <Widget>[
            Flexible(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: uploadedImageUrls.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 50,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (_, int index) => ImageContainer(
                  imageUrl: uploadedImageUrls[index],
                  circularDecoration: false,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => multiImageSelectionBottomSheet(
                context: context,
                onImageSelectionDone: (List<File> images) {
                  homeBloc.add(UploadImagesEvent(images));
                  if (mounted) {
                    navigator.pop();
                  }
                },
              ),
              child: const Text('Pick images'),
            ),
          ],
        );
      },
    );
  }
}
