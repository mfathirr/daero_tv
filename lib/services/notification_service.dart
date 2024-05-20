import 'dart:math';

import 'package:daero_tv/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService extends ChangeNotifier {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final onClickNotification = BehaviorSubject<String>();

  static void onNotitificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  static Future init() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotitificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotitificationTap);
  }

  static Future simpleNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    var movieList = await ApiService().fetchPopularMovie();
    var moviePopularList = movieList.movie;
    var randomIndex = Random().nextInt(moviePopularList.length);
    var randomMovieList = moviePopularList[randomIndex];

    await flutterLocalNotificationsPlugin.show(
      0,
      "Watch Our Popular Movie!",
      randomMovieList.title,
      notificationDetails,
    );
  }

  static Future periodicNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'repeating channel id', 'repeating channel name',
            channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    var movieList = await ApiService().fetchPopularMovie();
    var moviePopularList = movieList.movie;
    var randomIndex = Random().nextInt(moviePopularList.length);
    var randomMovieList = moviePopularList[randomIndex];
    await flutterLocalNotificationsPlugin.periodicallyShow(
      3,
      "Watch Our Popular Movie!",
      randomMovieList.title,
      RepeatInterval.everyMinute,
      notificationDetails,
    );
  }

  Future scheduleNotification() async {
    var movieList = await ApiService().fetchPopularMovie();
    var moviePopularList = movieList.movie;
    var randomIndex = Random().nextInt(moviePopularList.length);
    var randomMovieList = moviePopularList[randomIndex];

    await flutterLocalNotificationsPlugin.zonedSchedule(
      100,
      "Watch Our Popular Movie!",
      randomMovieList.title,
      setTimeDailyNotification(),
      const NotificationDetails(
          android: AndroidNotificationDetails('channel 3', 'your channel name',
              channelDescription: 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker')),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  setTimeDailyNotification() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
