// //e_oE7sfeSY2QrZQPaxJ_to:APA91bEgVKJlplQ9qoqgQWjW2f3-UbAyLO35qqjAWFDrq2AmYDsQOj7Fogvb5GyC2IZU-eCV8Ud1nW48Dtra0Elx6Ncuycn6ry2Z1ioIlcJ9J8MABPZXYhWn2ccENLVBJ-ZtTA0z_G9M

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class PushNotifications {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     await Firebase.initializeApp();
//     print('Handling a background message: ${message.messageId}');
//     // Manejar el mensaje aquí
//   }

//   Future<void> initNotifications() async {
//     // Inicializar Firebase
//     await Firebase.initializeApp();

//     // Configurar los canales de notificación para Android
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       description:
//           'This channel is used for important notifications.', // description
//       importance: Importance.high,
//     );

//     // Crear una instancia de AndroidNotificationChannel
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     // Configurar la inicialización de iOS
//     //final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();

//     // Configurar la inicialización de MacOS
//     //final MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings();

//     // Inicializar la configuración
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       //iOS: initializationSettingsIOS,
//       //macOS: initializationSettingsMacOS,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     // Crear el canal de notificaciones
//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     // Solicitar permisos de notificación (solo necesario en iOS)
//     NotificationSettings settings =
//         await _firebaseMessaging.requestPermission();

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }

//     // Obtener el token FCM
//     String? token = await _firebaseMessaging.getToken();
//     print("FCM Token: $token");

//     // Manejo de mensajes en primer plano
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Received a message while in the foreground!');
//       print('Message data: ${message.data}');

//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//         _showNotification(message);
//       }
//     });

//     // Manejo de mensajes cuando la aplicación está en segundo plano y se abre
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//       print('Message data: ${message.data}');
//     });

//     // Manejo de mensajes en segundo plano
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//   }

//   // Mostrar notificación usando flutter_local_notifications
//   Future<void> _showNotification(RemoteMessage message) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       channelDescription:
//           'This channel is used for important notifications.', // description
//       importance: Importance.high,
//       priority: Priority.high,
//       showWhen: false,
//     );

//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );

//     await _flutterLocalNotificationsPlugin.show(
//       message.notification.hashCode,
//       message.notification?.title,
//       message.notification?.body,
//       platformChannelSpecifics,
//       payload: message.data.toString(),
//     );
//   }
// }
