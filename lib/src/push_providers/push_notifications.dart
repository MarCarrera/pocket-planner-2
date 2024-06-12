//e_oE7sfeSY2QrZQPaxJ_to:APA91bEgVKJlplQ9qoqgQWjW2f3-UbAyLO35qqjAWFDrq2AmYDsQOj7Fogvb5GyC2IZU-eCV8Ud1nW48Dtra0Elx6Ncuycn6ry2Z1ioIlcJ9J8MABPZXYhWn2ccENLVBJ-ZtTA0z_G9M

//eIspWC4LQZWmYTrrpfLDDm:APA91bFUCQQzKw4PFxP9dS_aW0bT0z1tA-bXmJzBucRK_S2t5RQNhSCzqKI3iHs5lSrg96KbZkSfSTsaQ0OunZ3KKyGfrdzqOnW4S0QWnrbRcGvaxhmgJOBy_OjDRUJcMxETnUStWq0_

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotifications {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static Future _backgroundHandler(RemoteMessage message) async {
    print('Background Handler ${message.messageId}');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('onMessage Handler ${message.messageId}');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    print('onMessageOpenApp Handler ${message.messageId}');
  }

  static Future initializeApp() async {
    //Push notifications
    await Firebase.initializeApp();
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
}
