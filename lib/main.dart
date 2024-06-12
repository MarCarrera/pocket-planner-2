import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pocket_planner/src/push_providers/push_notifications.dart';
import 'package:pocket_planner/widgets/Login.dart';
import 'data/models/add_date.dart';
import 'utils/prueba.dart';
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
  late int index_color;
  _MyAppState({required this.index_color});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen()
        //home: ButtomNav(index_color: index_color)
        );
  }
}





//17:16 https://www.youtube.com/watch?v=9-QFt-cWZV8
//incluir responsividad para dispositivos
