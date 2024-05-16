import 'dart:convert';

import '../models/view_model.dart';
import 'package:http/http.dart' as http;

import '../request/api_request_2.dart';

final url =
    Uri.parse('https://mariehcarey.000webhostapp.com/api-accounts/consults');
//--------------------------------------------------------------------

class FinanceController {
  List<Finance> finances = []; // Lista de finanzas obtenidas de la API

  Future<void> fetchFinanceData() async {
    try {
      final List apiData = await mostrarFinanzas();

      // Limpiar la lista de finanzas antes de agregar nuevas
      finances.clear();

      // Iterar sobre los datos de la API y crear objetos Finance
      for (Map<String, dynamic> data in apiData) {
        final finance = Finance(
          idFinance: data['idFinance'],
          concept: data['concept'],
          reason: data['reason'],
          amount: data['amount']
              .toString(), // Asegúrate de convertir a String si es necesario
          type: data['type'],
          date: data['date'],
        );
        finances.add(finance);
        print('Objeto: ${finances}');
      }
    } catch (e) {
      print('Error al obtener datos de la API: $e');
      throw Exception('Error al cargar los datos');
    }
  }
}
