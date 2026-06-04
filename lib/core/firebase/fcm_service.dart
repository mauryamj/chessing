import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../supabase/supabase_client.dart';

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    try {
      // Request permission (iOS + Android 13+)
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus != AuthorizationStatus.authorized) return;

      // Initialize Local Notifications
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings();
      const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
      
      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (response) {
          if (response.payload != null) {
            try {
              final data = jsonDecode(response.payload!) as Map<String, dynamic>;
              _handleNotificationData(data);
            } catch (_) {}
          }
        },
      );

      // Create Android notification channel
      const channel = AndroidNotificationChannel(
        'chess_notifications',
        'Chess Notifications',
        description: 'Daily reminders and achievement alerts',
        importance: Importance.high,
      );
      
      if (Platform.isAndroid) {
        await _localNotifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);
      }

      // Get token and save to Supabase
      final token = await _messaging.getToken();
      if (token != null) await _saveToken(token);

      // Refresh token listener
      _messaging.onTokenRefresh.listen(_saveToken);

      // Foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Background/terminated tap handler
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check if app was opened from a terminated state via notification
      final initial = await _messaging.getInitialMessage();
      if (initial != null) _handleNotificationTap(initial);
    } catch (e) {
      debugPrint('FCM initialization failed: $e');
    }
  }

  Future<void> _saveToken(String token) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    try {
      await supabase.from('fcm_tokens').upsert({
        'user_id': userId,
        'token': token,
        'platform': Platform.isAndroid ? 'android' : 'ios',
      }, onConflict: 'token');
    } catch (_) {
      // Ignored for offline usage
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'chess_notifications',
          'Chess Notifications',
          channelDescription: 'Daily reminders and achievement alerts',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    _handleNotificationData(message.data);
  }

  void _handleNotificationData(Map<String, dynamic> data) {
    debugPrint('Notification tapped with data: $data');
  }

  Future<void> deleteToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await supabase.from('fcm_tokens').delete().eq('token', token);
      }
      await _messaging.deleteToken();
    } catch (_) {}
  }

  Future<void> scheduleDailyReminder(TimeOfDay time) async {
    await _localNotifications.zonedSchedule(
      0,
      'Time to practice!',
      'A daily game keeps your rating climbing ♟️',
      _nextInstanceOfTime(time),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'chess_notifications',
          'Chess Notifications',
          channelDescription: 'Daily reminders and achievement alerts',
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyReminder() async {
    await _localNotifications.cancel(0);
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduled.isBefore(now)) scheduled = scheduled.add(const Duration(days: 1));
    return scheduled;
  }
}
