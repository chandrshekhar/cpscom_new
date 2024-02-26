import 'package:flutter/material.dart';

class DeleteMemberAlertDialog extends StatelessWidget {
  final VoidCallback onDelete;
  final bool isLoading;
  const DeleteMemberAlertDialog(
      {super.key, required this.onDelete, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Are you sure to remove the member?",
        style: TextStyle(color: Colors.red),
      ),
      actions: <Widget>[
        // Delete Button

        // Cancel Button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); //
          },
          child: const Text('Cancel'),
        ),
        isLoading == false
            ? TextButton(
                onPressed: onDelete,
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              )
            : const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
      ],
    );
  }
}
