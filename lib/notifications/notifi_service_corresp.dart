import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServiceCorresp {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // static Future init() async {
  //   NotificationDetails(
  //       iOS: DarwinNotificationDetails(),
  //       android: AndroidNotificationDetails(
  //           'c0rr3sp0nd3nc145', 'Correspondências',
  //           sound:
  //               RawResourceAndroidNotificationSound('audio_correspondencias'),
  //           importance: Importance.max,
  //           priority: Priority.high,
  //           playSound: true,
  //           visibility: NotificationVisibility.public,
  //           enableVibration: true,
  //           fullScreenIntent: true));
  //   var initAndroidSettings = AndroidInitializationSettings('logo_portaria');
  //   var ios = DarwinInitializationSettings();
  //   final settings = InitializationSettings(
  //     android: initAndroidSettings,
  //     iOS: ios,
  //   );
  //   await _notificationsPlugin.initialize(settings);
  // }

  // static Future showNotification({
  //   var id = 0,
  //   var title,
  //   var body,
  //   var payLoad,
  // }) async =>
  //     _notificationsPlugin.show(
  //         id, title, body, await notificationDetailsCorresp());

  static Future initNotificationCorresp() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('logo_portaria');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  static notificationDetailsCorresp() async {
    await NotificationDetails(
        iOS: DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
            'c0rr3sp0nd3nc145', 'Correspondências',
            sound:
                RawResourceAndroidNotificationSound('audio_correspondencias'),
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            visibility: NotificationVisibility.public,
            enableVibration: true,
            fullScreenIntent: true));
  }

  Future showNotificationCorresp(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return _notificationsPlugin.show(
        id, title, body, await notificationDetailsCorresp());
  }
}
