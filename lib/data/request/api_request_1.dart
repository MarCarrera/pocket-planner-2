// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

final urlgetAccounts =
    Uri.parse('https://carreramar.000webhostapp.com/api-accounts/getAccounts');
final urlgetAccountByIdAccount = Uri.parse(
    'https://carreramar.000webhostapp.com/api-accounts/getAccountByIdAccount');
final urlupdatePassAccountById = Uri.parse(
    'https://carreramar.000webhostapp.com/api-accounts/updatePassAccountByIdAccount');
final urigetProfiles =
    Uri.parse('https://carreramar.000webhostapp.com/api-accounts/getProfiles');
final urigetProfilesByIdAccount = Uri.parse(
    'https://carreramar.000webhostapp.com/api-accounts/getProfilesByIdAccount');
final urigetProfilesByIdUser = Uri.parse(
    'https://carreramar.000webhostapp.com/api-accounts/getProfilesByIdUser');
final urladdProfile =
    Uri.parse('https://carreramar.000webhostapp.com/api-accounts/addProfile');
final urlupdateProfileByIdUser = Uri.parse(
    'https://carreramar.000webhostapp.com/api-accounts/updateProfileByIdUser');
final urlupdateDataProfileByIdUser = Uri.parse(
    "https://carreramar.000webhostapp.com/api-accounts/updateDataProfileByIdUser");
final urldeleteProfileByIdUser = Uri.parse(
    'https://carreramar.000webhostapp.com/api-accounts/deleteProfileByIdUser');
final urlgetPayments =
    Uri.parse('https://carreramar.000webhostapp.com/api-accounts/getPayments');
final urlgetPaymentsByIdUser = Uri.parse(
    'https://carreramar.000webhostapp.com/api-accounts/getPaymentsByIdUser');
final urlgetPaymentsByIdAccount = Uri.parse(
    'https://carreramar.000webhostapp.com/api-accounts/getPaymentsByIdAccountDate');
final urladdPayment =
    Uri.parse('https://carreramar.000webhostapp.com/api-accounts/addPayment');
final urldeletePayment = Uri.parse(
    'https://carreramar.000webhostapp.com/api-accounts/deletePaymentByIdPay');
final updatePinByIdUser = Uri.parse(
    'https://carreramar.000webhostapp.com/api-accounts/updatePinByIdUser');
final addTransaction = Uri.parse(
    'https://carreramar.000webhostapp.com/api-accounts/addTransaction');
final getTransaccionByAccountStatus = Uri.parse(
    'https://carreramar.000webhostapp.com/api-accounts/getTransactionsByIdAccountStatus');
final transactions = Uri.parse(
    'https://carreramar.000webhostapp.com/api-accounts/getTransactions');
final allMoney =
    Uri.parse('https://carreramar.000webhostapp.com/api-accounts/getAllMoney');
//------------------------------------------------------------------------------------------------------------

Future<dynamic> getAccounts() async {
  try {
    final response = await http.get(
      urlgetAccounts,
      //body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(response);
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}

Future<dynamic> getProfiles() async {
  /*var data = {
    'opcion': '1',
    'correo': parametros["correo"],
    'contrasena': parametros["contrasena"],
  };*/

  try {
    final response = await http.post(
      urigetProfiles,
      //body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}

Future getTransaccionAccountStatus(
    String idAccount, String status, String date1, String date2) async {
  var data = {
    'idAccount': idAccount,
    'status': status,
    'date1': date1,
    'date2': date2
  };

  try {
    final response = await http.post(
      getTransaccionByAccountStatus,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}

Future<dynamic> getAllMoney() async {
  try {
    final response = await http.post(
      allMoney,
      //body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}

Future<void> updateAccountData({
  required String idAccount,
  required String password,
}) async {
  // var url = 'tu_url_de_actualizacion'; // Reemplaza esto con la URL correcta de tu API

  var data = {
    'idAccount': idAccount,
    'password': password,
  };

  try {
    final response = await http.post(
      urlupdatePassAccountById,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      print('Hecho');
      print(jsonResponse); // Puedes hacer algo con la respuesta si es necesario
    } else {
      // Manejar el caso en el que la solicitud no fue exitosa
      print('Error en la solicitud HTTP: ${response.statusCode}');
    }
  } catch (e) {
    // Manejar errores de conexión
    print('Error de conexión: $e');
  }
}

Future<dynamic> getProfilesByAccount(String idAccount) async {
  var data = {
    //'opcion': '1',
    'idAccount': idAccount,
    // 'contrasena': parametros["contrasena"],
  };

  try {
    final response = await http.post(
      urigetProfilesByIdAccount,
      //Uri.parse(
      // 'https://marcarrera.000webhostapp.com/accounts-app-flutter/request_profiles_by_account.php?idAccountUser=$idAccount'),
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}

Future<dynamic> getPaymentsProfilesByUser(String idUser) async {
  var data = {
    // 'opcion': '1',
    'idUser': idUser,
    // 'contrasena': parametros["contrasena"],
  };

  try {
    final response = await http.post(
      //Uri.parse("https://marcarrera.000webhostapp.com/accounts-app-flutter/request_paymentsProfiles_by_user.php?idUser=$idUser")
      urlgetPaymentsByIdUser,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}

Future<dynamic> getPaymentsProfilesByAccountDate(
    String idAccount, String date1, String date2) async {
  var data = {
    // 'opcion': '1',
    'idAccount': idAccount,
    'date1': date1,
    'date2': date2,
    // 'contrasena': parametros["contrasena"],
  };

  try {
    final response = await http.post(
      //Uri.parse("https://marcarrera.000webhostapp.com/accounts-app-flutter/request_paymentsProfiles_by_user.php?idUser=$idUser")
      urlgetPaymentsByIdAccount,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}

Future<dynamic> getPaymentsProfiles() async {
  /*var data = {
    'opcion': '1',
    'correo': parametros["correo"],
    'contrasena': parametros["contrasena"],
  };*/

  try {
    final response = await http.post(urlgetPayments
        //body: data,
        );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}

Future<dynamic> getTransactions() async {
  try {
    final response = await http.get(transactions);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}

Future<void> addPaymentProfileData(
    {required String idUser,
    required String idAccount,
    required String paymentDate,
    required String amountPay}) async {
  // var url = 'tu_url_de_actualizacion'; // Reemplaza esto con la URL correcta de tu API

  var data = {
    'idUser': idUser,
    'idAccount': idAccount,
    'paymentStatus': 'hecho',
    'paymentDate': paymentDate,
    'amountPay': amountPay,
  };

  try {
    final response = await http.post(
      urladdPayment,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      print('Hecho');
      print(jsonResponse); // Puedes hacer algo con la respuesta si es necesario
    } else {
      // Manejar el caso en el que la solicitud no fue exitosa
      print('Error en la solicitud HTTP: ${response.statusCode}');
    }
  } catch (e) {
    // Manejar errores de conexión
    print('Error de conexión: $e');
  }
}

Future<void> addProfileData({
  required String idUser,
  required String nameUser,
  required String paymentDateUser,
  required String phoneUser,
  required String statusUser,
  required String genre,
}) async {
  // var url = 'tu_url_de_actualizacion'; // Reemplaza esto con la URL correcta de tu API

  var data = {
    'idUser': idUser,
    'nameUser': nameUser,
    'paymentDateUser': paymentDateUser,
    'phoneUser': phoneUser,
    'statusUser': statusUser,
    'genre': genre,
  };

  try {
    final response = await http.post(
      urlupdateProfileByIdUser,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      print('Hecho');
      print(jsonResponse); // Puedes hacer algo con la respuesta si es necesario
    } else {
      // Manejar el caso en el que la solicitud no fue exitosa
      print('Error en la solicitud HTTP: ${response.statusCode}');
    }
  } catch (e) {
    // Manejar errores de conexión
    print('Error de conexión: $e');
  }
}

//UPDATE DATA===================================================================================
Future<void> updateProfileData({
  required String idUser,
  required String nameUser,
  required String paymentDateUser,
  required String amount,
  required String phoneUser,
  required String pinUser,
  required String statusUser,
  required String genre,
}) async {
  // var url = 'tu_url_de_actualizacion'; // Reemplaza esto con la URL correcta de tu API

  var data = {
    'idUser': idUser,
    'nameUser': nameUser,
    'paymentDateUser': paymentDateUser,
    'amount': amount,
    'phoneUser': phoneUser,
    'pinUser': pinUser,
    'statusUser': statusUser,
    'genre': genre,
  };

  try {
    final response = await http.post(
      urlupdateProfileByIdUser,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      print('Hecho');
      print(jsonResponse); // Puedes hacer algo con la respuesta si es necesario
    } else {
      // Manejar el caso en el que la solicitud no fue exitosa
      print('Error en la solicitud HTTP: ${response.statusCode}');
    }
  } catch (e) {
    // Manejar errores de conexión
    print('Error de conexión: $e');
  }
}

Future<void> updateDateProfileData({
  required String idUser,
}) async {
  // var url = 'tu_url_de_actualizacion'; // Reemplaza esto con la URL correcta de tu API

  var data = {
    'idUser': idUser,
    'nameUser': "Vacio",
    'paymentDateUser': '1',
    'amount': "85",
    'phoneUser': "Vacio",
    'statusUser': "Libre",
    'genre': "Vacio",
  };

  try {
    final response = await http.post(
      urlupdateDataProfileByIdUser,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      print('Hecho');
      print(jsonResponse); // Puedes hacer algo con la respuesta si es necesario
    } else {
      // Manejar el caso en el que la solicitud no fue exitosa
      print('Error en la solicitud HTTP: ${response.statusCode}');
    }
  } catch (e) {
    // Manejar errores de conexión
    print('Error de conexión: $e');
  }
}

Future<void> updatePinByUser({
  required String idUser,
  required String pinUser,
}) async {
  // var url = 'tu_url_de_actualizacion'; // Reemplaza esto con la URL correcta de tu API

  var data = {
    'idUser': idUser,
    'pinUser': pinUser,
  };

  try {
    final response = await http.post(
      updatePinByIdUser,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      print('Hecho');
      print(jsonResponse); // Puedes hacer algo con la respuesta si es necesario
    } else {
      // Manejar el caso en el que la solicitud no fue exitosa
      print('Error en la solicitud HTTP: ${response.statusCode}');
    }
  } catch (e) {
    // Manejar errores de conexión
    print('Error de conexión: $e');
  }
}

Future<void> deleteProfileByUser({
  required String idUser,
  /* required String nameUser,
  required String paymentDateUser,
  required String amount,
  required String phoneUser,
  required String pinUser,
  required String statusUser,
  required String genre,*/
}) async {
  // var url = 'tu_url_de_actualizacion'; // Reemplaza esto con la URL correcta de tu API

  var data = {
    'idUser': idUser,
  };

  try {
    final response = await http.post(
      urldeleteProfileByIdUser,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      print('Hecho');
      print(jsonResponse); // Puedes hacer algo con la respuesta si es necesario
    } else {
      // Manejar el caso en el que la solicitud no fue exitosa
      print('Error en la solicitud HTTP: ${response.statusCode}');
    }
  } catch (e) {
    // Manejar errores de conexión
    print('Error de conexión: $e');
  }
}

Future<void> deletePaymentByPay({
  required String idPago,
  /* required String nameUser,
  required String paymentDateUser,
  required String amount,
  required String phoneUser,
  required String pinUser,
  required String statusUser,
  required String genre,*/
}) async {
  // var url = 'tu_url_de_actualizacion'; // Reemplaza esto con la URL correcta de tu API

  var data = {
    'idPago': idPago,
  };

  try {
    final response = await http.post(
      urldeletePayment,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      print('Hecho');
      print(jsonResponse); // Puedes hacer algo con la respuesta si es necesario
    } else {
      // Manejar el caso en el que la solicitud no fue exitosa
      print('Error en la solicitud HTTP: ${response.statusCode}');
    }
  } catch (e) {
    // Manejar errores de conexión
    print('Error de conexión: $e');
  }
}

Future<void> addNewTransaction({
  required String reason,
  required String amount,
  required String idAccount,
  required String status,
}) async {
  DateTime now = DateTime.now();
  String currentDate = DateFormat('yyyy-MM-dd').format(now);

  var data = {
    'idAccount': idAccount,
    'reason': reason,
    'transaction': '5',
    'date': currentDate,
    'amount': amount,
    'status': status,
  };

  try {
    final response = await http.post(
      addTransaction,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      print('Hecho');
      print(jsonResponse); // Puedes hacer algo con la respuesta si es necesario
    } else {
      // Manejar el caso en el que la solicitud no fue exitosa
      print('Error en la solicitud HTTP: ${response.statusCode}');
    }
  } catch (e) {
    // Manejar errores de conexión
    print('Error de conexión: $e');
  }
}
