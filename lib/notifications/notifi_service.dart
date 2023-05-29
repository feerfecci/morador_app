import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationDetailsAvisos {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotificationAvisos() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('logo_portaria');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetailsAvisos() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('4v1s0s', 'Avisos',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            visibility: NotificationVisibility.public,
            enableVibration: true,
            fullScreenIntent: true,
            sound: RawResourceAndroidNotificationSound('audio_avisos')));
  }

  Future showNotificationAvisos(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetailsAvisos());
  }
}
