import 'package:components/base/base_page.dart';
import 'package:components/pages/delete_account/bloc/bloc.dart';
import 'package:components/pages/logout/bloc/bloc.dart';
import 'package:components/routes/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends BasePage {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends BasePageState<SettingsScreen> {
  late final LogoutBloc logoutBloc;
  late final DeleteAccountBloc deleteAccountBloc;
  @override
  void initState() {
    logoutBloc = BlocProvider.of(context);
    deleteAccountBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
        title: const Text('Settings'),
      );

  @override
  Widget body(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0.0),
      children: <Widget>[
        buildHeading("Account"),
        buildOption(
          "Change Password",
          () => navigator.pushNamed(
            Routes.changePassword,
          ),
          const Icon(
            Icons.password_sharp,
            color: Colors.black,
          ),
        ),
        buildOption(
          "Delete Account",
          onDeleteAccount,
          const Icon(
            Icons.account_circle,
            color: Colors.black,
          ),
        ),
        buildOption(
          "Logout",
          onLogout,
          const Icon(
            Icons.logout_rounded,
            color: Colors.black,
          ),
        ),
        const Divider(
          color: Colors.black12,
        ),
        buildHeading("Notification"),
        buildOption(
          "Change Notification",
          () => null,
          const Icon(
            Icons.notification_important_rounded,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Text buildHeading(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
    );
  }

  ListTile buildOption(String title, Function()? onTap, Icon leading) {
    return ListTile(
      // style: ButtonStyle(alignment: Alignment.centerLeft),
      onTap: onTap,
      contentPadding: const EdgeInsets.all(0.0),
      minLeadingWidth: 20.0,
      leading: leading,
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w400),
      ),
    );
  }

  void onLogout() {
    logoutBloc.add(
      LogoutSubmitted(),
    );
  }

  void onDeleteAccount() {
    deleteAccountBloc.add(
      DeleteAccountSubmitted(),
    );
  }
}
