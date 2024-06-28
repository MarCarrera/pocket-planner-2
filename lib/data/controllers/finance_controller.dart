import 'dart:convert';

import '../models/view_model.dart';
import 'package:http/http.dart' as http;

import '../request/api_request.dart';

final url =
    Uri.parse('https://mariehcarey.000webhostapp.com/api-accounts/consults');
//--------------------------------------------------------------------

class HomeService {
  Future<List<Finance>> cargarFinanzas() async {
    List<Finance> finances = [];
    var respuesta = await mostrarFinanzas();
    if (respuesta != "err_internet_conex") {
      if (respuesta == 'empty') {
        print('no hay datos');
      } else {
        //print('Respuesta en vista ::::: ${respuesta}');
        if (respuesta.isNotEmpty) {
          finances.clear();
          for (int i = 0; i < respuesta.length; i++) {
            finances.add(Finance(
                idFinance: respuesta[i]['idFinance'],
                concept: respuesta[i]['concept'],
                reason: respuesta[i]['reason'],
                amount: respuesta[i]['amount'],
                type: respuesta[i]['type'],
                date: respuesta[i]['date']));
          }
          //print('Arreglo idFinance:');
          // Itera sobre la lista finances y accede al idFinance de cada objeto Finance
          for (var finance in finances) {
            //print(finance.idFinance);
          }
        }
      }
    } else {
      print('Verifique su conexion a internet');
    }
    return finances;
  }
}
