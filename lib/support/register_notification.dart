import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void configLocalNotification(flutterLocalNotificationsPlugin) {
  var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void showNotification(message, flutterLocalNotificationsPlugin) async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    'com.rd.pcchats',
    'PC Chats',
    'PC Chats',
    playSound: true,
    enableVibration: true,
    importance: Importance.Default,
    priority: Priority.Default,
  );

  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

  var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    message['title'].toString(),
    message['body'].toString(),
    platformChannelSpecifics,
    payload: json.encode(message),
  );
}

void registerNotification(context, firebaseMessaging, flutterLocalNotificationsPlugin, currentUserId) {
  firebaseMessaging.requestNotificationPermissions();

  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) {
      showNotification(message['notification'], flutterLocalNotificationsPlugin);
      return;
    },
    onResume: (Map<String, dynamic> message) {
      return;
    },
    onLaunch: (Map<String, dynamic> message) {
      return;
    }
  );

  firebaseMessaging.getToken().then((token) {
    Firestore.instance.collection('users').document(currentUserId).updateData({
      'tokenID': token.toString(),
    }).catchError((err) {
      Flushbar(
        title: "Whoops",
        message: "Couldn't load that link",
        duration: Duration(seconds: 2),
        icon: Icon(Icons.sentiment_dissatisfied),
      ).show(context);
    });
  });
}