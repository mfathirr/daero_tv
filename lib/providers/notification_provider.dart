import 'package:daero_tv/services/notification_service.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  bool _isNotificationEnabled = false;

  bool get isNotificationEnabled => _isNotificationEnabled;

  Future<void> toggleNotification(bool isEnabled) async {
    _isNotificationEnabled = isEnabled;
    notifyListeners();

    if (isEnabled) {
      await NotificationService.periodicNotification();
    } else {
      NotificationService.flutterLocalNotificationsPlugin.cancelAll();
    }
  }
}
