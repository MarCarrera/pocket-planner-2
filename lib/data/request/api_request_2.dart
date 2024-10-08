// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:http/http.dart' as http;

final url =
    Uri.parse('https://mariehcarey.000webhostapp.com/api-accounts/consults');
// CONSULTAS DE FINANZAS ------------------------------------------------------------------
Future<dynamic> mostrarFinanzas() async {
  var data = {'opc': '30'};

  try {
    final response = await http.post(
      url,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      //print('Respuesta Api JSON: ${jsonResponse}');
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}

Future<dynamic> mostrarDataConcept({required String concept}) async {
  var data = {'opc': '30.4', 'concept': concept};

  try {
    final response = await http.post(
      url,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print('Respuesta Api JSON: ${jsonResponse}');
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}

Future<int> mostrarTotalDataConcept({required String concept}) async {
  final response = await http.post(
    url,
    body: {'opc': '30.5', 'concept': concept},
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    if (data.isNotEmpty) {
      // Verificar si 'total' está presente en el mapa y no es nulo
      if (data.containsKey('diferencia') && data['diferencia'] != null) {
        // Extraer el valor totalIncome del mapa
        dynamic totalIncome = data['diferencia'];
        // Convertir el valor a entero y devolverlo
        return totalIncome;
      } else {
        // Si 'total' no está presente o es nulo, devolver 0
        return 0;
      }
    } else {
      // Si no hay datos disponibles, lanzar una excepción
      throw Exception('No se encontraron datos');
    }
  } else {
    // Si hay un error en la solicitud HTTP, lanzar una excepción
    throw Exception('Error al cargar los datos');
  }
}

Future<int> mostrarTotalDinero({required String opc}) async {
  final response = await http.post(
    url,
    body: {'opc': opc},
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    if (data.isNotEmpty) {
      // Verificar si 'total' está presente en el mapa y no es nulo
      if (data.containsKey('totalBanco') && data['totalBanco'] != null) {
        // Extraer el valor totalIncome del mapa
        dynamic totalBanco = data['totalBanco'];
        // Convertir el valor a entero y devolverlo
        return totalBanco;
      } else if (data.containsKey('totalEfectivo') &&
          data['totalEfectivo'] != null) {
        // Extraer el valor totalIncome del mapa
        dynamic totalEfectivo = data['totalEfectivo'];
        // Convertir el valor a entero y devolverlo
        return totalEfectivo;
      } else {
        // Si 'total' no está presente o es nulo, devolver 0
        return 0;
      }
    } else {
      // Si no hay datos disponibles, lanzar una excepción
      throw Exception('No se encontraron datos');
    }
  } else {
    // Si hay un error en la solicitud HTTP, lanzar una excepción
    throw Exception('Error al cargar los datos');
  }
}

Future<int> mostrarTotalIngreso() async {
  final response = await http.post(
    url,
    body: {'opc': '30.1'},
  );
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    if (data.isNotEmpty) {
      // Extraer el valor totalIncome del primer mapa en la lista
      dynamic totalIncome = data[0]['totalIncome'];
      // Convertir el valor a entero y devolverlo
      return totalIncome;
    } else {
      // Si no hay datos disponibles, lanzar una excepción
      throw Exception('No se encontraron datos de ingreso');
    }
  } else {
    // Si hay un error en la solicitud HTTP, lanzar una excepción
    throw Exception('Error al cargar los datos');
  }
}

Future<int> mostrarTotalGasto() async {
  final response = await http.post(
    url,
    body: {'opc': '30.2'},
  );
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    if (data.isNotEmpty) {
      // Extraer el valor totalIncome del primer mapa en la lista
      dynamic totalIncome = data[0]['totalExpense'];
      // Convertir el valor a entero y devolverlo
      return totalIncome;
    } else {
      // Si no hay datos disponibles, lanzar una excepción
      throw Exception('No se encontraron datos de gasto');
    }
  } else {
    // Si hay un error en la solicitud HTTP, lanzar una excepción
    throw Exception('Error al cargar los datos');
  }
}

Future<int> mostrarDiferenciaTotal() async {
  final response = await http.post(
    url,
    body: {'opc': '30.3'}, // Opción para calcular la diferencia
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    // Extraer el valor de la diferencia del mapa
    int diferencia = data['diferencia'];
    // Devolver el valor de la diferencia
    return diferencia;
  } else {
    // Si hay un error en la solicitud HTTP, lanzar una excepción
    throw Exception('Error al cargar la diferencia');
  }
}

Future<void> agregarFinanza(
    {required String concepto,
    required String motivo,
    required String monto,
    required String tipo,
    required String fecha}) async {
  try {
    final response = await http.post(
      url,
      body: {
        'opc': '31',
        'concept': concepto,
        'reason': motivo,
        'amount': monto,
        'type': tipo,
        'date': fecha,
      },
    );
    if (response.statusCode == 200) {
      print('Registro insertado exitosamente');
    } else {
      throw Exception('Error al insertar el registro');
    }
  } catch (error) {
    print('Error: $error');
    throw Exception('Error al insertar el registro');
  }
}

Future<void> eliminarFinanza({required String idFinance}) async {
  try {
    final response = await http.post(
      url,
      body: {
        'opc': '32',
        'idFinance': idFinance,
      },
    );
    if (response.statusCode == 200) {
      print('Registro eliminado exitosamente');
    } else {
      throw Exception('Error al eliminar el registro');
    }
  } catch (error) {
    print('Error: $error');
    throw Exception('Error al eliminar el registro');
  }
}

// CONSULTAS DE CUENTAS ------------------------------------------------------------------
Future<dynamic> mostrarCash() async {
  var data = {'opc': '33'};

  try {
    final response = await http.post(
      url,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      //print('Respuesta Api JSON: ${jsonResponse}');
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}

Future<int> mostrarTotalIngresoCash() async {
  final response = await http.post(
    url,
    body: {'opc': '33.1'},
  );
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    if (data.isNotEmpty) {
      // Extraer el valor totalIncome del primer mapa en la lista
      dynamic totalIncome = data[0]['totalIncome'];
      // Convertir el valor a entero y devolverlo
      return totalIncome;
    } else {
      // Si no hay datos disponibles, lanzar una excepción
      throw Exception('No se encontraron datos de ingreso');
    }
  } else {
    // Si hay un error en la solicitud HTTP, lanzar una excepción
    throw Exception('Error al cargar los datos');
  }
}

Future<int> mostrarTotalGastoCash() async {
  final response = await http.post(
    url,
    body: {'opc': '33.2'},
  );
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    if (data.isNotEmpty) {
      // Extraer el valor totalIncome del primer mapa en la lista
      dynamic totalIncome = data[0]['totalExpense'];
      // Convertir el valor a entero y devolverlo
      return totalIncome;
    } else {
      // Si no hay datos disponibles, lanzar una excepción
      throw Exception('No se encontraron datos de gasto');
    }
  } else {
    // Si hay un error en la solicitud HTTP, lanzar una excepción
    throw Exception('Error al cargar los datos');
  }
}

Future<int> mostrarDiferenciaTotalCash() async {
  final response = await http.post(
    url,
    body: {'opc': '33.3'}, // Opción para calcular la diferencia
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    // Extraer el valor de la diferencia del mapa
    int diferencia = data['diferencia'];
    // Devolver el valor de la diferencia
    return diferencia;
  } else {
    // Si hay un error en la solicitud HTTP, lanzar una excepción
    throw Exception('Error al cargar la diferencia');
  }
}

Future<void> agregarGastoCash(
    {required String concepto,
    required String motivo,
    required String monto,
    required String tipo,
    required String fecha}) async {
  try {
    final response = await http.post(
      url,
      body: {
        'opc': '34',
        'concept': concepto,
        'reason': motivo,
        'amount': monto,
        'type': tipo,
        'date': fecha,
      },
    );
    if (response.statusCode == 200) {
      print('Registro insertado exitosamente');
    } else {
      throw Exception('Error al insertar el registro');
    }
  } catch (error) {
    print('Error: $error');
    throw Exception('Error al insertar el registro');
  }
}

Future<void> eliminarGastoCash({required String idCash}) async {
  try {
    final response = await http.post(
      url,
      body: {
        'opc': '35',
        'idCash': idCash,
      },
    );
    if (response.statusCode == 200) {
      print('Registro eliminado exitosamente');
    } else {
      throw Exception('Error al eliminar el registro');
    }
  } catch (error) {
    print('Error: $error');
    throw Exception('Error al eliminar el registro');
  }
}
