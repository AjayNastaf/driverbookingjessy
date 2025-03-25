// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   static void initialize() {
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings settings =
//     InitializationSettings(android: androidSettings);
//
//     _notificationsPlugin.initialize(settings,
//         onDidReceiveNotificationResponse: (response) {
//           // Handle when user clicks the notification
//           _onNotificationClick();
//         });
//   }
//
//   static Future<void> showNotification() async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'app_exit_channel',
//       'App Exit',
//       channelDescription: 'Shows notification when app is closed',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//
//     const NotificationDetails details = NotificationDetails(android: androidDetails);
//
//     await _notificationsPlugin.show(
//       0,
//       'Jessy Cabs',
//       'Tap to return to your booking!',
//       details,
//     );
//   }
//
//   static void _onNotificationClick() {
//     // Handle what happens when user clicks the notification
//     print('User tapped notification - Navigate to last screen');
//   }
// }
