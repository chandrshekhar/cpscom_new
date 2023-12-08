part of 'chat_screen_bloc.dart';

 class ChatScreenEvent extends Equatable {
  const ChatScreenEvent({required this.groupId, required this.isAdmin});
  final String groupId;
  final bool isAdmin;

  @override
  List<Object> get props => [];
}
