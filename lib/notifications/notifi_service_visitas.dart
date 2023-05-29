import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServiceVisitas {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotificationVisitas() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('logo_portaria');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetailsVisitas() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('v1s1t4s', 'Visitas',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            visibility: NotificationVisibility.public,
            enableVibration: true,
            fullScreenIntent: true,
            sound: RawResourceAndroidNotificationSound('audio_visitas')));
  }

  Future showNotificationVisitas(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetailsVisitas());
  }
}
