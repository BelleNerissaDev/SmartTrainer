import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

class NotificationCard extends StatelessWidget {
  final String? avatarUrl;
  final ColorFamily colorTheme;
  final String message;
  final String nome;
  final String dateTime;

  const NotificationCard({
    Key? key,
    this.avatarUrl,
    required this.message,
    required this.dateTime,
    required this.colorTheme,
    required this.nome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorTheme.white_onPrimary_100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 3.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.only(left: 0, right: 8.0, top: 0, bottom: 0),
        horizontalTitleGap: 8.0,
        minVerticalPadding: 0.0,
        dense: true,
        leading: CircleAvatar(
          radius: 28.0,
          backgroundColor: colorTheme.light_container_500,
          backgroundImage: avatarUrl != null
              ? NetworkImage(avatarUrl!)
              : const AssetImage('assets/images/rafiki_avatar.png'),
        ),
        title: Text(
          '$nome $message',
          style: Theme.of(context).textTheme.body12px!.copyWith(
                color: colorTheme.black_onSecondary_100,
                fontWeight: FontWeight.w700,
              ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              dateTime,
              style: Theme.of(context).textTheme.label10px!.copyWith(
                    color: colorTheme.black_onSecondary_100.withOpacity(0.6),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
