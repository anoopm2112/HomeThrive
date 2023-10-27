import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/core/models/input/register_device_input/register_device_input.dart';
import 'package:fostershare/core/services/graphql/auth/auth_graphql_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:graphql/client.dart';

class PushNotificationsService {
  final _authGraphQLService = locator<AuthGraphQLService>();
  final _loggerService = locator<LoggerService>();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidNotificationchannel =
      AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  Future<void> init() async {
    await _fcm.requestPermission();

    // Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidNotificationchannel);

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null && android != null) {
          _flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _androidNotificationchannel.id,
                _androidNotificationchannel.name,
                _androidNotificationchannel.description,
                icon: "@mipmap/ic_launcher",
              ),
            ),
          );
        }
      },
    );

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  Future<bool> registerDevice() async {
    _loggerService.info(
      "PushNotificationsService | registerDevice()",
    );

    final String deviceToken = await this.getToken();
    final RegisterDeviceInput input = RegisterDeviceInput(
      platform: Platform.isIOS ? AppPlatform.ios : AppPlatform.android,
      token: deviceToken,
    );

    final QueryResult result = await _authGraphQLService.registerDevice(input);
    final registered = result.data["registerDevice"] as bool;

    _loggerService.info(
      "PushNotificationsService | registerDevice() => $registered",
    );
    return registered;
  }

  void removeDevice() {}

  Future<String> getToken() async {
    return Platform.isIOS ? _fcm.getAPNSToken() : _fcm.getToken();
  }

  Future<void> onSignOut() async {
    await _fcm.deleteToken();
  }
}
