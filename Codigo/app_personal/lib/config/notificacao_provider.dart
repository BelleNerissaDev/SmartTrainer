import 'package:flutter/material.dart';

class NotificacaoProvider extends ChangeNotifier {
  static final NotificacaoProvider _instance = NotificacaoProvider._internal();

  NotificacaoProvider._internal();

  factory NotificacaoProvider() => _instance;

  final List<Map<String, dynamic>> _notifications = [];

  List<Map<String, dynamic>> get notifications => _notifications;

  void addNotification(Map<String, dynamic> data) {
    if (!_notifications.contains(data)) {
      if (data['dateTime'] is String) {
        final date = DateTime.parse(data['dateTime']);
        data['dateTime'] = date;
      }
      _notifications.add(data);
      _notifications.sort((a, b) => b['dateTime'].compareTo(a['dateTime']));
      notifyListeners();
    }
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}

final NotificacaoProvider notificacaoProvider = NotificacaoProvider();
