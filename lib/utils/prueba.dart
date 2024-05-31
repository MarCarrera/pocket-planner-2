import 'package:flutter/material.dart';

import '../data/models/view_model.dart';
import '../data/request/api_request_2.dart';

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  List<Finance> finances = [];

  Future<List<Finance>> cargarFinanzas() async {
    var respuesta = await mostrarFinanzas();
    List<Finance> finances = [];
    if (respuesta != "err_internet_conex") {
      if (respuesta == 'empty') {
        print('no hay datos');
      } else {
        print('Respuesta en vista ::::: ${respuesta}');
        if (respuesta.isNotEmpty) {
          for (int i = 0; i < respuesta.length; i++) {
            finances.add(Finance(
                idFinance: respuesta[i]['idFinance'],
                concept: respuesta[i]['concept'],
                reason: respuesta[i]['reason'],
                amount: respuesta[i]['amount'],
                type: respuesta[i]['type'],
                date: respuesta[i]['date']));
          }
        }
      }
    } else {
      print('Verifique su conexion a internet');
    }
    return finances;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finanzas'),
      ), // AppBar
      body: FutureBuilder<List<Finance>>(
        future: cargarFinanzas(), // Llama a la función que obtiene los datos
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se obtienen los datos
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Maneja los errores
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Maneja el caso cuando no hay datos
            return Center(child: Text('No hay datos disponibles'));
          } else {
            // Muestra los datos obtenidos
            List<Finance> finances = snapshot.data!;
            return ListView.builder(
              itemCount: finances.length,
              itemBuilder: (context, index) {
                Finance finance = finances[index];
                return ListTile(
                  title: Text(finance.concept),
                  subtitle: Text(finance.reason),
                  trailing: Text(finance.amount.toString()),
                ); // ListTile
              },
            ); // ListView.builder
          }
        },
      ), // FutureBuilder
    ); // Scaffold
  }
}
