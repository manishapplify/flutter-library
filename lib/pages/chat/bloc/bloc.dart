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
  }

  final String imageBaseUrl;
  final AuthCubit _authCubit;
  final FirebaseRealtimeDatabase _firebaseRealtimeDatabase;

  void _getChatsEventHandler(
      GetChatsEvent event, Emitter<ChatState> emit) async {
    final FirebaseUser? firebaseUser =
        await _firebaseRealtimeDatabase.getFirebaseUser(
      User(
        id: '27ee8b8c-bdc7-4a46-86ba-62463024fe11',
        registrationStep: 2,
        notificationEnabled: 2,
        isPhoneVerified: 1,
        isEmailVerified: 1,
        createdAt: 'createdAt',
        accessToken: 'accessToken',
        s3Folders: S3Folders(admin: '', users: ''),
      ),
    );

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
}
