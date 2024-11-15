import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pocket_planner/src/push_providers/push_notifications.dart';
import 'package:pocket_planner/widgets/Login.dart';
import 'package:pocket_planner/widgets/add_screen.dart';
import 'Cards/cards_home.dart';
import 'data/models/add_date.dart';
import 'utils/NotificationScreen.dart';
import 'widgets/buttom_nav.dart';

void main() async {
  /*WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((app) {
    print("Initialized $app");
    
  });*/
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotifications.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(AdddataAdapter());
  await Hive.openBox<Add_data>('data');

  runApp(const MyApp(
    index_color: 0,
  ));
}

class MyApp extends StatefulWidget {
  final int index_color;
  const MyApp({super.key, required this.index_color});

  @override
  State<MyApp> createState() => _MyAppState(index_color: index_color);
}

class _MyAppState extends State<MyApp> {
  //instancia de navigatorKey para navegar al contexto despues de recibir la notificacion
  //final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  //final List<String> _notifications = []; // Lista para almacenar las notificaciones

  @override
  void initState() {
    super.initState();
    //acceso al messageStream de la notificacion
    /*PushNotifications.messagesStream.listen((data) {
      //print('Argumento: $data');

      navigatorKey.currentState?.pushNamed('addPay', arguments: data);
    });*/

    // PushNotifications.messagesStream.listen((data) {
    //   setState(() {
    //     _notifications.add(data); // Agregar la notificación a la lista
    //   });

    //   navigatorKey.currentState?.pushNamed('addPay', arguments: data);
    // });
  }

  late int index_color;
  _MyAppState({required this.index_color});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     // navigatorKey: navigatorKey,
      home:  CardsHome() //LoginScreen()
     // initialRoute: 'login',
      /*routes: {
        'login':(BuildContext context)=>LoginScreen(),
        'navBar':(BuildContext context)=>ButtomNav(index_color: 0),
        'addPay':(BuildContext context)=>Prueba(notifications: _notifications),
      },*/
    );
  }
}





//17:16 https://www.youtube.com/watch?v=9-QFt-cWZV8
//incluir responsividad para dispositivos
