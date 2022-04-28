import 'package:components/common/work_status.dart';
import 'package:components/pages/base_page.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:components/pages/chat/bloc/bloc.dart';
import 'package:components/pages/users/widgets/user_tile.dart';
import 'package:components/pages/users/bloc/bloc.dart';
import 'package:components/routes/navigation.dart';
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
  late final User user;
  late final ChatBloc chatBloc;

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
        title: const Text('Users'),
      );

  @override
  void initState() {
    usersBloc = BlocProvider.of(context)..add(GetUsersEvent());
    chatBloc = BlocProvider.of(context);
    final AuthCubit authCubit = BlocProvider.of(context);
    if (!authCubit.state.isAuthorized) {
      throw AppException.authenticationException;
    }
    user = authCubit.state.user!;

    super.initState();
  }

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (BuildContext context, UsersState state) {
        if (state.chatStatus is Success) {
          Future<void>.microtask(
            () => navigator.pushNamed(
              Routes.chat,
              arguments: Routes.users,
            ),
          );
          chatBloc.add(ChatOpenedEvent(state.chat!));
          usersBloc.add(ResetChatState());
        } else if (state.chatStatus is Failure) {
          final Failure failure = state.chatStatus as Failure;
          Future<void>.microtask(
            () => showSnackBar(
              SnackBar(
                content: Text(failure.message ?? 'Failure'),
              ),
            ),
          );
          usersBloc.add(ResetChatState());
        }

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
                    usersBloc.add(
                      MessageIconTapEvent(
                        firebaseUserA: FirebaseUser.fromMap(
                          user.toFirebaseMap(),
                        ),
                        firebaseUserB: otherUser,
                      ),
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
              visible: state.blocStatus is InProgress ||
                  state.chatStatus is InProgress,
            ),
          ],
        );
      },
    );
  }
}
