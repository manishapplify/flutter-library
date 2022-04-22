import 'package:components/authentication/form_submission.dart';
import 'package:components/base/base_page.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:components/pages/chat/bloc/bloc.dart';
import 'package:components/pages/chat/widgets/chat_tile.dart';
import 'package:components/pages/users/bloc/bloc.dart';
import 'package:components/pages/users/widgets/user_tile.dart';
import 'package:components/routes/navigation.dart';
import 'package:components/services/firebase_realtime_database/models/chat.dart';
import 'package:components/services/firebase_realtime_database/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class ChatsPage extends BasePage {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatsState();
}

class _ChatsState extends BasePageState<ChatsPage> {
  late final ChatBloc chatBloc;
  late final UsersBloc usersBloc;
  late final User currentUser;

  @override
  void initState() {
    final AuthCubit authCubit = BlocProvider.of(context);
    if (!authCubit.state.isAuthorized) {
      throw AppException.authenticationException;
    }

    currentUser = authCubit.state.user!;
    chatBloc = BlocProvider.of(context)
      ..add(GetChatsEvent())
      ..add(GetChatsSubscriptionEvent())
      ..add(GetMessageSubscriptionsEvent());
    usersBloc = BlocProvider.of(context)..add(GetUsersEvent());
    super.initState();
  }

  @override
  void dispose() {
    chatBloc.add(ViewDisposeEvent());
    super.dispose();
  }

  @override
  EdgeInsets get padding => EdgeInsets.zero;

  @override
  Widget body(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        chatBloc.add(ResetBlocState());
        return Future<bool>.value(true);
      },
      child: Stack(
        children: <Widget>[
          BlocBuilder<ChatBloc, ChatState>(
            builder: (BuildContext context, ChatState state) {
              if (state.blocStatus is SubmissionFailed) {
                final SubmissionFailed failure =
                    state.blocStatus as SubmissionFailed;
                if (failure.message !=
                    AppException.currentChatRemoved().message) {
                  Future<void>.microtask(
                    () => showSnackBar(
                      SnackBar(
                        content: Text(failure.message ?? 'Failure'),
                      ),
                    ),
                  );
                }
                chatBloc.add(ResetBlocStatus());
              }

              final List<FirebaseChat> chats = state.chats.toList();

              return Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight + 10),
                child: ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(
                    height: 8,
                  ),
                  itemBuilder: (BuildContext context, int i) {
                    final FirebaseChat chat = chats[i];

                    return ChatTile(
                      chat: chat,
                      imageBaseUrl: chatBloc.imageBaseUrl,
                      currentUserFirebaseId: currentUser.firebaseId,
                      onTileTap: () {
                        chatBloc.add(ChatOpenedEvent(chat));
                        Future<void>.microtask(
                          () => navigator.pushNamed(
                            Routes.chat,
                            arguments: Routes.chats,
                          ),
                        );
                      },
                      onTileDismissed: () => onChatTileDismissed(
                        context: context,
                        chat: chat,
                      ),
                    );
                  },
                  itemCount: chats.length,
                ),
              );
            },
          ),
          FloatingSearchBar(
            hint: 'Search a user...',
            scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
            transitionCurve: Curves.fastOutSlowIn,
            physics: const BouncingScrollPhysics(),
            openAxisAlignment: 0.0,
            width: 500,
            debounceDelay: const Duration(milliseconds: 200),
            onQueryChanged: (String query) =>
                usersBloc.add(QueryChangedEvent(query: query)),
            // Specify a custom transition to be used for
            // animating between opened and closed stated.
            transition: CircularFloatingSearchBarTransition(),
            actions: <FloatingSearchBarAction>[
              FloatingSearchBarAction(
                child: CircularButton(
                  icon: const Icon(Icons.account_circle),
                  onPressed: () {},
                ),
              ),
              FloatingSearchBarAction.searchToClear(
                showIfClosed: false,
              ),
            ],
            builder: (BuildContext context, Animation<double> transition) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Material(
                  color: Colors.white,
                  elevation: 4.0,
                  child: BlocBuilder<UsersBloc, UsersState>(
                    builder: (BuildContext context, UsersState state) {
                      final List<FirebaseUser> usersMatchingQuery =
                          state.usersMatchingQuery;
                      return ListView.separated(
                        padding:
                            const EdgeInsets.only(top: 8, right: 8, bottom: 8),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, __) => const SizedBox(
                          height: 8,
                        ),
                        itemBuilder: (BuildContext context, int i) {
                          final FirebaseUser otherUser = usersMatchingQuery[i];

                          return UserTile(
                            user: otherUser,
                            imageBaseUrl: usersBloc.imageBaseUrl,
                            onMessageIconTap: () {
                              final FirebaseUser firebaseUserA =
                                  FirebaseUser.fromMap(
                                currentUser.toFirebaseMap(),
                              );

                              usersBloc.add(
                                MessageIconTapEvent(
                                  firebaseUserA: firebaseUserA,
                                  firebaseUserB: otherUser,
                                ),
                              );

                              chatBloc.add(
                                ChatCreatedEvent(
                                  firebaseUserA: firebaseUserA,
                                  firebaseUserB: otherUser,
                                ),
                              );
                            },
                          );
                        },
                        itemCount: usersMatchingQuery.length,
                      );
                    },
                  ),
                ),
              );
            },
          ),
          BlocBuilder<ChatBloc, ChatState>(
            builder: (BuildContext context, ChatState state) {
              return Visibility(
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
                visible: state.blocStatus is FormSubmitting,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<bool?> onChatTileDismissed({
    required BuildContext context,
    required FirebaseChat chat,
  }) =>
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Delete chat'),
            content: const Text(
                'Are you sure? The chat will be deleted for both the users.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  chatBloc.add(RemoveChatEvent(chat));
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                  'Okay',
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          );
        },
      );
}
