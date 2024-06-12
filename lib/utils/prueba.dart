import 'package:flutter/material.dart';

class Prueba extends StatelessWidget {
  const Prueba({super.key});

  @override
  Widget build(BuildContext context) {
     final idUser = ModalRoute.of(context)?.settings.arguments;

    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Center(
          child: Text('Id de usuario: $idUser'),
        ),
      ),
    );
  }
}