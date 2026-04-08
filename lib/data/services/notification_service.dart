import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../main.dart';


class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  // initialize notification system
  static Future<void> init() async{
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: (response) {
          handleNavigation(response.payload);
        } ,
    );
  }

  // show notification when app is open
  static Future<void> show(RemoteMessage message)async{
    const androidDetails = AndroidNotificationDetails(
      'spendbuddy_channel',
      'SpendBuddy Notifications',
      importance: Importance.max,
      priority: Priority.high
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      id : 0,
      title: message.notification?.title?? "SpendBuddy",
      body:message.notification?.body ?? "",
      notificationDetails: details,
      payload: message.data['route'],
    );
  }

  // handle click navigation
  static void handleNavigation(String? route){
    if(route == "insights"){
      navigatorKey.currentState?.pushNamed('insights');
    }else{
      navigatorKey.currentState?.popUntil((route) => route.isFirst);
    }
  }
}