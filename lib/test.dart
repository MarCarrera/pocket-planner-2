import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  //Text(snapshot.data![index]['idFinance'].toString()),
  Widget build(BuildContext context) {
    return 
    
    
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Consulta API')),
        body: Center(
          child: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                // Procesar y mostrar los datos
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset('assets/images/Transporte.png',
                            height: 40),
                      ),
                      title: Text(
                        snapshot.data![index]['concept'],
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${snapshot.data![index]['date']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Text(
                        snapshot.data![index]['amount'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                          color: snapshot.data![index]['type'] == 'Income'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.post(
      Uri.parse('https://mariehcarey.000webhostapp.com/api-accounts/consults'),
      body: {'opc': '30'}, // Parámetro opc con valor 30
    );

    if (response.statusCode == 200) {
      print('Respuesta API:::: ${response.body}');
      // Decodificar la respuesta JSON
      List<dynamic> data = json.decode(response.body);
      // Convertir la lista de dynamic a List<Map<String, dynamic>>
      return List<Map<String, dynamic>>.from(data);
    } else {
      // Si la solicitud no fue exitosa, lanzar una excepción
      throw Exception('Error al cargar los datos');
    }
  }
}
