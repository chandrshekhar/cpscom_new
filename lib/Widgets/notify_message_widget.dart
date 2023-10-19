import 'package:cpscom_admin/Commons/app_colors.dart';
import 'package:cpscom_admin/Commons/app_sizes.dart';
import 'package:flutter/material.dart';

class NotifieMessageWidget extends StatelessWidget {
  String messageBy;
  String message;
  NotifieMessageWidget(
      {super.key, required this.message, required this.messageBy});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin:
              const EdgeInsets.symmetric(vertical: AppSizes.kDefaultPadding),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.kDefaultPadding,
              vertical: AppSizes.kDefaultPadding / 2),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: AppColors.lightGrey),
              borderRadius:
                  BorderRadius.circular(AppSizes.cardCornerRadius / 2),
              color: AppColors.shimmer),
          child: Text(
            '$messageBy $message',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
