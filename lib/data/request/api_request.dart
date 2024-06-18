// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';

// final LocalAuthentication _autenticacion = LocalAuthentication();
// bool _podemosUsarAutorizacion = false;
// String _autorizado = "No autorizado";
// List<BiometricType> _autorizacionesDisponibles = List<BiometricType>();

// Future<void> _probarAutorizacion() async {
//   bool podemosUsarAutorizacion = false;
//   try {
//     podemosUsarAutorizacion = await _autenticacion.canCheckBiometrics;
//   } on PlatformException catch (e) {
//     print(e);
//   }

//   if (!mounted) return;

//   setState(() {
//     _podemosUsarAutorizacion = podemosUsarAutorizacion;
//     print("Podemos usar autentincacion $_podemosUsarAutorizacion");
//   });
// }
// Future<void> _listaAutenticacionesDisponibles() async {
//   List<BiometricType> listaAutenticacion;
//   try {
//     listaAutenticacion = await _autenticacion.getAvailableBiometrics();
//   } on PlatformException catch (e) {
//     print(e);
//   }

//   if (!mounted) return;

//   setState(() {
//     _autorizacionesDisponibles = listaAutenticacion;
//     print("Podemos usar: ${_autorizacionesDisponibles.toString()}");
//   });
// }
// Future<void> _autorizar() async {
//   bool isAuthorized = false;
//   try {
//     isAuthorized = await _autenticacion.authenticateWithBiometrics(
//       localizedReason: "Autentíquese para completar su transacción",
//       useErrorDialogs: true,
//       stickyAuth: true,
//     );
//   } on PlatformException catch (e) {
//     print(e);
//   }

//   if (!mounted) return;

//   setState(() {
//     if (isAuthorized) {
//       _autorizado = "Autorizado";
//     } else {
//       _autorizado = "No autorizado";
//     }
//     print("Autorizado? $_autorizado");
//   });
// }

//==============================================================================================================

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

Future<void> abonarGasto(
    {required String bono, required String idFinance}) async {
  var data = {'opc': '33', 'bono': bono, 'idFinance': idFinance};

  try {
    final response = await http.post(
      url,
      body: data,
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

//NOTIFICACIONES =====================================
Future<void> sendNotification(
    {required String deviceToken, required String title, required String body}) async {
       var data = {'opc': '34',
      'token': deviceToken,
      'title': title,
      'body': body,};

  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: data,
  );

  if (response.statusCode == 200) {
    print('Notificación enviada exitosamente');
  } else {
    print('Error al enviar la notificación: ${response.reasonPhrase}');
  }
}
Future<dynamic> mostrarNotificaciones() async {
  var data = {'opc': '35'};

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
