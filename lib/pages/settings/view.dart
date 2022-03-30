import 'package:components/base/base_page.dart';
import 'package:components/enums/screen.dart';
import 'package:components/pages/settings/cubit/cubit.dart';
import 'package:components/routes/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends BasePage {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends BasePageState<SettingsPage> {
  late final SettingsCubit settingsCubit;

  @override
  void initState() {
    settingsCubit = BlocProvider.of(context);
    super.initState();
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
        title: const Text('Settings'),
      );

  @override
  Widget body(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        ListView(
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            const Heading("Account"),
            SettingOption(
              title: "Update profile",
              onOptionTap: () => navigator.pushNamed(
                Routes.profile,
                arguments: Screen.updateProfile,
              ),
              leading: const Icon(
                Icons.account_circle,
                color: Colors.black,
              ),
            ),
            SettingOption(
              title: "Verify email",
              onOptionTap: () => navigator.pushNamed(
                Routes.otp,
                arguments: Screen.verifyEmail,
              ),
              leading: const Icon(
                Icons.mark_email_read,
                color: Colors.black,
              ),
            ),
            SettingOption(
              title: "Change Password",
              onOptionTap: () => navigator.pushNamed(
                Routes.changePassword,
              ),
              leading: const Icon(
                Icons.password_sharp,
                color: Colors.black,
              ),
            ),
            SettingOption(
              title: "Delete Account",
              onOptionTap: () => settingsCubit.deleteAccount(),
              leading: const Icon(
                Icons.delete,
                color: Colors.black,
              ),
            ),
            SettingOption(
              title: "Logout",
              onOptionTap: () => settingsCubit.logout(),
              leading: const Icon(
                Icons.logout_rounded,
                color: Colors.black,
              ),
            ),
            // const Divider(
            //   color: Colors.black12,
            // ),
            // buildHeading("Notification"),
            // SettingOption(
            //   "Change Notification",
            //   () => null,
            //   const Icon(
            //     Icons.notification_important_rounded,
            //     color: Colors.black,
            //   ),
            // ),
          ],
        ),
        BlocBuilder<SettingsCubit, SettingsState>(
            builder: (_, SettingsState state) {
          if (state is CompletedAction) {
            settingsCubit.resetState();

            // Move to login screen on both LogdedOut, DeletedAccount.
            Future<void>.microtask(
              () => navigator
                ..popUntil(
                  (_) => false,
                )
                ..pushNamed(
                  Routes.login,
                ),
            );
          } else if (state is FailedAction) {
            settingsCubit.resetState();

            if (state is FailedLoggingOut) {
              Future<void>.microtask(
                () => showSnackBar(
                  const SnackBar(
                    content: Text('Failed to logout'),
                  ),
                ),
              );
            } else if (state is FailedDeletingAccount) {
              Future<void>.microtask(
                () => showSnackBar(
                  const SnackBar(
                    content: Text('Failed to delete account'),
                  ),
                ),
              );
            }
          }

          return Visibility(
            visible: state is PerformingAction,
            child: const CircularProgressIndicator(),
          );
        }),
      ],
    );
  }
}

class Heading extends StatelessWidget {
  const Heading(this.title, {Key? key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
      );
}

class SettingOption extends StatelessWidget {
  const SettingOption({
    required this.onOptionTap,
    this.leading,
    required this.title,
    Key? key,
  }) : super(key: key);

  final VoidCallback onOptionTap;
  final Widget? leading;
  final String title;

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: onOptionTap,
        contentPadding: const EdgeInsets.all(0.0),
        minLeadingWidth: 20.0,
        leading: leading,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
}