import 'package:components/common/app_exception.dart';
import 'package:components/common/work_status.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/pages/base_page.dart';
import 'package:components/blocs/blocs.dart';
import 'package:components/pages/notifications/widget/notification_tile.dart';
import 'package:components/services/firebase_realtime_database/models/message/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationPage extends BasePage {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotificationState();
}

class _NotificationState extends BasePageState<NotificationPage> {
  late final NotificationBloc notificationBloc;
  late final User currentUser;

  @override
  void initState() {
    final AuthCubit authCubit = BlocProvider.of(context);
    if (!authCubit.state.isAuthorized) {
      throw AppException.authenticationException();
    }

    currentUser = authCubit.state.user!;
    notificationBloc = BlocProvider.of(context)..add(GetNotificationEvent());
    super.initState();
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) => AppBar(
        title: const Text('Notification'),
      );

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (BuildContext context, NotificationState state) {
        final List<FirebaseMessage> notifications =
            state.notifications.toList();
        return state.blocStatus is InProgress
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: notifications.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return NotificationTile(
                    notification: notifications[index],
                  );
                });
      },
    );
  }
}
