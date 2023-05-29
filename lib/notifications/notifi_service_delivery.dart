import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServiceDelivery {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotificationDelivery() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('logo_portaria');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetailsDelivery() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('d3l1v3ry', 'Delivery',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            visibility: NotificationVisibility.public,
            enableVibration: true,
            fullScreenIntent: true,
            sound: RawResourceAndroidNotificationSound('audio_delivery')));
  }

  Future showNotificationDelivery(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetailsDelivery());
  }
}
