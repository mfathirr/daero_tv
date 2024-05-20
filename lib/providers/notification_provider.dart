import 'package:daero_tv/services/notification_service.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  bool _isNotificationEnabled = false;

  bool get isNotificationEnabled => _isNotificationEnabled;

  final NotificationService notificationService = NotificationService();

  Future<void> toggleNotification(bool isEnabled) async {
    _isNotificationEnabled = isEnabled;
    notifyListeners();

    if (isEnabled) {
      await notificationService.scheduleNotification();
      print("succes min nyala");
    } else {
      NotificationService.flutterLocalNotificationsPlugin.cancelAll();
      print("succes min mati nih");
    }
  }
}
