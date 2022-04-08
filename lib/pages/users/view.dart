import 'package:components/Authentication/form_submission.dart';
import 'package:components/base/base_page.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:components/pages/chat/widgets/user_tile.dart';
import 'package:components/pages/users/bloc/bloc.dart';
import 'package:components/services/firebase_realtime_database/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersPage extends BasePage {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UsersState();
}

class _UsersState extends BasePageState<UsersPage> {
  late final UsersBloc usersBloc;
  late final AuthCubit authCubit;

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
        title: const Text('Users'),
      );

  @override
  void initState() {
    usersBloc = BlocProvider.of(context)..add(GetUsersEvent());
    authCubit = BlocProvider.of(context);
    if (!authCubit.state.isAuthorized) {
      throw AppException.authenticationException;
    }
    super.initState();
  }

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (BuildContext context, UsersState state) {
        // TODO: Redirect to chat screen when chatStatus is SubmissionSuccess.

        final List<FirebaseUser> users = state.users;
        return Stack(
          children: <Widget>[
            ListView.separated(
              separatorBuilder: (_, __) => const SizedBox(
                height: 8,
              ),
              itemBuilder: (BuildContext context, int i) {
                final FirebaseUser otherUser = users[i];

                return UserTile(
                  user: otherUser,
                  imageBaseUrl: usersBloc.imageBaseUrl,
                  onMessageIconTap: () {
                    final List<String> userIds = <String>[
                      authCubit.state.user!.firebaseId,
                      otherUser.id,
                    ]..sort();
                    usersBloc.add(
                      MessageIconTapEvent(chatID: userIds.join(',')),
                    );
                  },
                );
              },
              itemCount: users.length,
            ),
            Visibility(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
              visible: state.blocStatus is FormSubmitting,
            )
          ],
        );
      },
    );
  }
}