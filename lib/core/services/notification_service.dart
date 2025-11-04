// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   static final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();

//   bool _isInitialized = false;

//   Future<void> initialize() async {
//     if (_isInitialized) return;

//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings iosSettings =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const InitializationSettings settings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );

//     await _notifications.initialize(
//       settings,
//       onDidReceiveNotificationResponse: _onNotificationTap,
//       onDidReceiveBackgroundNotificationResponse: _onNotificationTap,
//     );

//     // Create notification channels (important for Android 8.0+)
//     await _createNotificationChannels();
    
//     _isInitialized = true;
//   }

//   Future<void> _createNotificationChannels() async {
//     // Exam reminder channel
//     const AndroidNotificationChannel examChannel = AndroidNotificationChannel(
//       'exam_reminder_channel',
//       'Exam Reminders',
//       description: 'Notifications for exam reminders and updates',
//       importance: Importance.high,
//     );

//     // Payment channel
//     const AndroidNotificationChannel paymentChannel = AndroidNotificationChannel(
//       'payment_channel',
//       'Payment Updates',
//       description: 'Notifications for payment status updates',
//       importance: Importance.high,
//     );

//     // General channel
//     const AndroidNotificationChannel generalChannel = AndroidNotificationChannel(
//       'general_channel',
//       'General Notifications',
//       description: 'General app notifications',
//       importance: Importance.defaultImportance,
//     );

//     // Daily reminder channel
//     const AndroidNotificationChannel dailyChannel = AndroidNotificationChannel(
//       'daily_reminder_channel',
//       'Daily Reminders',
//       description: 'Daily study reminders',
//       importance: Importance.high,
//     );

//     // Create all channels
//     await _notifications
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(examChannel);

//     await _notifications
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(paymentChannel);

//     await _notifications
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(generalChannel);

//     await _notifications
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(dailyChannel);
//   }

//   void _onNotificationTap(NotificationResponse response) {
//     // Handle notification tap here
//     // You can use response.payload to handle deep linking
//     print('Notification tapped: ${response.payload}');
//   }

//   Future<void> showExamReminder({
//     required String title,
//     required String body,
//     required String payload,
//   }) async {
//     if (!_isInitialized) await initialize();

//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'exam_reminder_channel',
//       'Exam Reminders',
//       channelDescription: 'Notifications for exam reminders and updates',
//       importance: Importance.high,
//       priority: Priority.high,
//       playSound: true,
//       enableVibration: true,
//     );

//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _notifications.show(
//       _generateId(),
//       title,
//       body,
//       details,
//       payload: payload,
//     );
//   }

//   Future<void> showPaymentStatus({
//     required String title,
//     required String body,
//     required String payload,
//   }) async {
//     if (!_isInitialized) await initialize();

//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'payment_channel',
//       'Payment Updates',
//       channelDescription: 'Notifications for payment status updates',
//       importance: Importance.high,
//       priority: Priority.high,
//       playSound: true,
//       enableVibration: true,
//     );

//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _notifications.show(
//       _generateId(),
//       title,
//       body,
//       details,
//       payload: payload,
//     );
//   }

//   Future<void> showGeneralNotification({
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     if (!_isInitialized) await initialize();

//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'general_channel',
//       'General Notifications',
//       channelDescription: 'General app notifications',
//       importance: Importance.defaultImportance,
//       priority: Priority.defaultPriority,
//       playSound: true,
//     );

//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _notifications.show(
//       _generateId(),
//       title,
//       body,
//       details,
//       payload: payload,
//     );
//   }

//   Future<void> cancelAllNotifications() async {
//     await _notifications.cancelAll();
//   }

//   Future<void> cancelNotification(int id) async {
//     await _notifications.cancel(id);
//   }

//   Future<void> scheduleDailyReminder({
//     required Time time,
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     if (!_isInitialized) await initialize();

//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'daily_reminder_channel',
//       'Daily Reminders',
//       channelDescription: 'Daily study reminders',
//       importance: Importance.high,
//       priority: Priority.high,
//       playSound: true,
//       enableVibration: true,
//     );

//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _notifications.periodicallyShow(
//       _generateId(),
//       title,
//       body,
//       RepeatInterval.daily,
//       details,
//       payload: payload,
//     );
//   }

//   Future<void> scheduleExamReminder({
//     required DateTime scheduledDate,
//     required String title,
//     required String body,
//     required String payload,
//   }) async {
//     if (!_isInitialized) await initialize();

//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'exam_reminder_channel',
//       'Exam Reminders',
//       channelDescription: 'Notifications for exam reminders and updates',
//       importance: Importance.high,
//       priority: Priority.high,
//       playSound: true,
//       enableVibration: true,
//     );

//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _notifications.zonedSchedule(
//       _generateId(),
//       title,
//       body,
//       TZDateTime.from(scheduledDate, local),
//       details,
//       payload: payload,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle: true,
//     );
//   }

//   int _generateId() {
//     return DateTime.now().millisecondsSinceEpoch.remainder(100000);
//   }

//   // Check if notifications are enabled
//   Future<bool> areNotificationsEnabled() async {
//     final bool? result = await _notifications
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.areNotificationsEnabled();
//     return result ?? false;
//   }

//   // Request notification permissions (mainly for iOS)
//   Future<bool> requestPermissions() async {
//     final bool? result = await _notifications
//         .resolvePlatformSpecificImplementation<
//             DarwinFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//     return result ?? false;
//   }
// }