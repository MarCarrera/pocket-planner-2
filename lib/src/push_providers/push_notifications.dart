//e_oE7sfeSY2QrZQPaxJ_to:APA91bEgVKJlplQ9qoqgQWjW2f3-UbAyLO35qqjAWFDrq2AmYDsQOj7Fogvb5GyC2IZU-eCV8Ud1nW48Dtra0Elx6Ncuycn6ry2Z1ioIlcJ9J8MABPZXYhWn2ccENLVBJ-ZtTA0z_G9M

//eIspWC4LQZWmYTrrpfLDDm:APA91bFUCQQzKw4PFxP9dS_aW0bT0z1tA-bXmJzBucRK_S2t5RQNhSCzqKI3iHs5lSrg96KbZkSfSTsaQ0OunZ3KKyGfrdzqOnW4S0QWnrbRcGvaxhmgJOBy_OjDRUJcMxETnUStWq0_

import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotifications {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStream = StreamController.broadcast();
//get estatico que retorna el messageStream
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    // print('Background Handler ${message.messageId}');

    //cuando se recibe una notificacion se añade al stream, en este caso el titulo
    print('Data recibida: ${message.data}');
    //_messageStream.add(message.notification?.body ?? 'Sin titulo');

    String argumento = 'no-data';
    if (Platform.isAndroid) {
      argumento = message.data['userId'] ?? 'no-data';
    }
    _messageStream.add(argumento);
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    //print('onMessage Handler ${message.messageId}');
    print('Data recibida: ${message.data}');
    //_messageStream.add(message.notification?.body ?? 'Sin titulo');
    String argumento = 'no-data';
    if (Platform.isAndroid) {
      argumento = message.data['userId'] ?? 'no-data';
    }
    _messageStream.add(argumento);
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    //print('onMessageOpenApp Handler ${message.messageId}');
    print('Data recibida: ${message.data}');
    //_messageStream.add(message.notification?.body ?? 'Sin titulo');
    String argumento = 'no-data';
    if (Platform.isAndroid) {
      argumento = message.data['userId'] ?? 'no-data';
    }
    _messageStream.add(argumento);
  }

  static Future initializeApp() async {
    //inicializar firebase
    await Firebase.initializeApp();
    // Pedir permisos para notificaciones
    await _requestPermissions();

    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');

//Handlers
//cuando la aplicacion esta en segundo plano pero no se ha destruido o cerrado
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    //cuando la aplicacion esta abierta
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    //cuando la app esta cerrada y se debe abrir
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static Future<void> _requestPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permiso de notificaciones concedido');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Permiso de notificaciones provisional concedido');
    } else {
      print('Permiso de notificaciones denegado');
    }
  }

  static closeStreams() {
    _messageStream.close();
  }
}
