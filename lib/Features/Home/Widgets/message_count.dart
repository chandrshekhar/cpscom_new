import 'package:flutter/material.dart';

class MessageCountWidget extends StatelessWidget {
  final int messageCount;

  const MessageCountWidget({Key? key, required this.messageCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 10, // Adjust size of the circle
      backgroundColor: Theme.of(context).primaryColor, // Set background to blue
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            '$messageCount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16, // Adjust font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
