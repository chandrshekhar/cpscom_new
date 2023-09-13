part of 'chat_screen_bloc.dart';
 class ChatScreenState extends Equatable {
  const ChatScreenState();
  @override
  List<Object> get props => [];
}
 class ChatScreenInitial extends ChatScreenState {}
 class ChatScreenClickedState extends ChatScreenState{
  final String groupId;
  final bool isAdmin;
  const ChatScreenClickedState({required this.groupId, required this.isAdmin});
 }
