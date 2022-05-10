import 'dart:async';

import 'package:components/common/work_status.dart';
import 'package:components/pages/base_page.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/common/app_exception.dart';
import 'package:components/pages/chat/widgets/chat_tile.dart';
import 'package:components/blocs/blocs.dart';
import 'package:components/pages/users/widgets/user_tile.dart';
import 'package:components/routes/navigation.dart';
import 'package:components/services/firebase_realtime_database/models/chat.dart';
import 'package:components/services/firebase_realtime_database/models/user.dart';
import 'package:components/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsPage extends BasePage {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatsState();
}

class _ChatsState extends BasePageState<ChatsPage> {
  late final ChatBloc chatBloc;
  late final UsersBloc usersBloc;
  late final User currentUser;
  late final ValueNotifier<bool> isSearchBarOpenNotifier;
  Timer? debounceTimer;

  OverlayEntry? usersOverlayEntry;

  @override
  void initState() {
    final AuthCubit authCubit = BlocProvider.of(context);
    if (!authCubit.state.isAuthorized) {
      throw AppException.authenticationException();
    }

    currentUser = authCubit.state.user!;
    chatBloc = BlocProvider.of(context)
      ..add(GetChatsEvent())
      ..add(GetChatsSubscriptionEvent())
      ..add(GetMessageSubscriptionsEvent());
    usersBloc = BlocProvider.of(context)..add(GetUsersEvent());
    isSearchBarOpenNotifier = ValueNotifier<bool>(false)
      ..addListener(onNotifierValue);
    super.initState();
  }

  @override
  void dispose() {
    chatBloc.add(ViewDisposeEvent());
    isSearchBarOpenNotifier
      ..removeListener(onNotifierValue)
      ..dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
        title: const Text('Chats'),
        actions: <Widget>[
          SearchBar(
            onQueryChanged: onQueryChanged,
            isSearchBarOpenNotifier: isSearchBarOpenNotifier,
          )
        ],
      );

  @override
  Widget body(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (usersOverlayEntry == null) {
          chatBloc.add(ResetChatBlocState());

          return Future<bool>.value(true);
        } else {
          isSearchBarOpenNotifier.value = false;
          hideOverlayEntry();

          return Future<bool>.value(false);
        }
      },
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (BuildContext context, ChatState state) {
          onStateChanged(state: state);
          final List<FirebaseChat> chats = state.chats.toList();

          return ListView.separated(
            separatorBuilder: (_, __) => const SizedBox(
              height: 8,
              child: Divider(
                thickness: 2,
                indent: 80,
              ),
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
          );
        },
      ),
    );
  }

  void onStateChanged({required ChatState state}) {
    final bool _isLoading = state.blocStatus is InProgress;
    if (_isLoading != isLoading) {
      Future<void>.microtask(() => isLoading = _isLoading);
    }

    if (state.blocStatus is Failure) {
      final Failure failure = state.blocStatus as Failure;
      if (failure.message == AppException.noChatsPresent().message ||
          failure.message == AppException.couldNotLoadChats().message) {
        Future<void>.microtask(
          () => showSnackBar(
            SnackBar(
              content: Text(failure.message ?? 'Failure'),
            ),
          ),
        );
      }
      chatBloc.add(ResetChatBlocStatus());
    }
  }

  void onQueryChanged(String query) {
    if (debounceTimer?.isActive ?? false) {
      debounceTimer?.cancel();
    }

    debounceTimer = Timer(const Duration(milliseconds: 200), () {
      usersBloc.add(
        QueryChangedEvent(query: query),
      );
    });
  }

  void onNotifierValue() {
    // true -> show overlay.
    // false -> hide overlay, clear input

    if (isSearchBarOpenNotifier.value) {
      showOverlay(
        context: context,
        onMessageIconTapped: () {
          navigator.pushNamed(
            Routes.chat,
            arguments: Routes.chats,
          );
        },
      );
    } else {
      hideOverlayEntry();
      usersBloc.add(QueryChangedEvent(query: ''));
    }
  }

  void showOverlay(
      {required BuildContext context,
      required VoidCallback onMessageIconTapped}) async {
    // Declaring and Initializing OverlayState
    // and OverlayEntry objects
    final OverlayState? overlayState = Overlay.of(context);
    if (overlayState is OverlayState) {
      usersOverlayEntry = OverlayEntry(
        builder: (BuildContext context) {
          // You can return any widget you like here
          // to be displayed on the Overlay
          final double screenWidth = MediaQuery.of(context).size.width;
          final double screenHeight = MediaQuery.of(context).size.height;

          return Positioned(
            left: screenWidth * 0.025,
            top: kToolbarHeight + screenHeight * 0.05,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(3)),
              ),
              width: screenWidth * 0.95,
              height: screenHeight * 0.9 - kToolbarHeight,
              child: BlocBuilder<UsersBloc, UsersState>(
                builder: (BuildContext context, UsersState state) {
                  final List<FirebaseUser> usersMatchingQuery =
                      state.usersMatchingQuery;
                  return Material(
                    color: Colors.grey[200],
                    child: usersMatchingQuery.isEmpty
                        ? const Center(child: Text('No users found!'))
                        : ListView.separated(
                            padding: const EdgeInsets.only(
                                top: 8, right: 8, bottom: 8),
                            separatorBuilder: (_, __) => const SizedBox(
                              height: 8,
                            ),
                            itemBuilder: (BuildContext context, int i) {
                              final FirebaseUser otherUser =
                                  usersMatchingQuery[i];

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
                                  isSearchBarOpenNotifier.value = false;
                                  onMessageIconTapped();
                                },
                              );
                            },
                            itemCount: usersMatchingQuery.length,
                          ),
                  );
                },
              ),
            ),
          );
        },
      );

      overlayState.insert(usersOverlayEntry!);
    } else {
      // Could not display overlay, close search bar.
      isSearchBarOpenNotifier.value = false;
    }
  }

  void hideOverlayEntry() {
    usersOverlayEntry?.remove();
    usersOverlayEntry = null;
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
              'Are you sure? The chat will be deleted for both the users.',
            ),
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
