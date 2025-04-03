import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/cards/notification_card.dart';
import 'package:SmartTrainer_Personal/config/notificacao_provider.dart';
import 'package:SmartTrainer_Personal/fonts.dart';
import 'package:SmartTrainer_Personal/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationMenu extends StatelessWidget {
  final ColorFamily colorTheme;

  NotificationMenu({
    Key? key,
    required this.colorTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifications =
        Provider.of<NotificacaoProvider>(context).notifications;
    return Drawer(
      backgroundColor: colorTheme.light_container_500,
      child: Column(
        children: [
          // Cabeçalho com Alinhamentos
          Container(
            padding: EdgeInsets.zero,
            color: colorTheme.light_container_500,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
                    child: Text(
                      'Notificações',
                      style: Theme.of(context).textTheme.headline24px!.copyWith(
                            color: colorTheme.indigo_primary_800,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                    child: IconButton(
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: colorTheme.indigo_primary_700,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ListView de Notificações com Cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  colorTheme: colorTheme,
                  avatarUrl: notification['imagemAluno'],
                  nome: notification['nomeAluno'],
                  message: notification['mensagem']!,
                  dateTime: formatDateTime(notification['dateTime']),
                );
              },
            ),
          )
        ],
      ),
      width: MediaQuery.of(context).size.width * 0.7,
    );
  }
}
