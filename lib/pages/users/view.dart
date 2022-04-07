import 'package:components/Authentication/form_submission.dart';
import 'package:components/base/base_page.dart';
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

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
        title: const Text('Users'),
      );

  @override
  void initState() {
    usersBloc = BlocProvider.of(context)..add(GetUsersEvent());
    super.initState();
  }

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (BuildContext context, UsersState state) {
        final List<FirebaseUser> users = state.users;
        return Stack(
          children: <Widget>[
            ListView.separated(
              separatorBuilder: (_, __) => const SizedBox(
                height: 8,
              ),
              itemBuilder: (BuildContext context, int i) => UserTile(
                user: users[i],
              ),
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
