import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_screen_event.dart';
part 'chat_screen_state.dart';

class ChatScreenBloc extends Bloc<ChatScreenEvent, ChatScreenState> {
  ChatScreenBloc() : super(ChatScreenInitial()) {
    on<ChatScreenEvent>((event, emit) {
       emit(ChatScreenInitial());
      if (event.groupId.isNotEmpty) {
        emit(ChatScreenClickedState(groupId: event.groupId,isAdmin: event.isAdmin));
      } else {
        emit(ChatScreenInitial());
      }
    });
  }
}
