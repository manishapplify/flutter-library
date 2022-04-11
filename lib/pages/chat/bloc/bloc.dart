import 'package:bloc/bloc.dart';
import 'package:components/authentication/form_submission.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/services/firebase_realtime_database/firebase_realtime_database.dart';
import 'package:components/services/firebase_realtime_database/models/chat.dart';
import 'package:components/services/firebase_realtime_database/models/user.dart';
import 'package:meta/meta.dart';

part 'event.dart';
part 'state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required this.imageBaseUrl,
    required AuthCubit authCubit,
    required FirebaseRealtimeDatabase firebaseRealtimeDatabase,
  })  : _authCubit = authCubit,
        _firebaseRealtimeDatabase = firebaseRealtimeDatabase,
        super(const ChatState()) {
    on<GetChatsEvent>(_getChatsEventHandler);
    on<RemoveChatEvent>(_removeChatEventHandler);
  }

  final String imageBaseUrl;
  final AuthCubit _authCubit;
  final FirebaseRealtimeDatabase _firebaseRealtimeDatabase;

  void _getChatsEventHandler(
      GetChatsEvent event, Emitter<ChatState> emit) async {
    final FirebaseUser? firebaseUser = await _firebaseRealtimeDatabase
        .getFirebaseUser(user: _authCubit.state.user);

    if (firebaseUser is FirebaseUser &&
        firebaseUser.chatIds is List<String> &&
        firebaseUser.chatIds!.isNotEmpty) {
      emit(
        state.copyWith(
          chats:
              await _firebaseRealtimeDatabase.getChats(firebaseUser.chatIds!),
        ),
      );
    }
  }

  void _removeChatEventHandler(
      RemoveChatEvent event, Emitter<ChatState> emit) async {
    await _firebaseRealtimeDatabase.removeChat(
      chat: event.chat,
    );
  }
}