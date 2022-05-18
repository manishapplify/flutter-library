import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:components/blocs/blocs.dart';
import 'package:components/common/app_exception.dart';
import 'package:components/common/work_status.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/pages/base_page.dart';
import 'package:components/pages/notifications/widget/notification_tile.dart';
import 'package:components/services/firebase_realtime_database/models/message/message.dart';

class NotificationPage extends BasePage {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotificationState();
}

class _NotificationState extends BasePageState<NotificationPage> {
  late final NotificationsBloc notificationBloc;
  late final User currentUser;

  @override
  void initState() {
    final AuthCubit authCubit = BlocProvider.of(context);
    if (!authCubit.state.isAuthorized) {
      throw AppException.authenticationException();
    }

    currentUser = authCubit.state.user!;
    notificationBloc = BlocProvider.of(context)..add(GetNotificationsEvent());
    super.initState();
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) => AppBar(
        title: const Text('Notification'),
      );

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (BuildContext context, NotificationsState state) {
        final List<FirebaseMessage> notifications =
            state.notifications.toList();
        return state.blocStatus is InProgress
            ? const Center(child: CircularProgressIndicator())
            : notifications.isEmpty
                ? const Center(
                    child: Text("No Notification Yet!"),
                  )
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
