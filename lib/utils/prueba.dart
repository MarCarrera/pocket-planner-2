import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/request/api_request_2.dart';

class Prueba extends StatefulWidget {
  final List<String> notifications; // Recibir las notificaciones

  const Prueba({Key? key, required this.notifications}) : super(key: key);

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  @override
  void initState() {
    super.initState();
    cargarNotificaciones();
  }

  bool noData = false;

  Future<void> cargarNotificaciones() async {
    //parametros = {"opcion": "1.1"};
    //reload = true;
    var respuesta = await mostrarNotificaciones();
    // reload = false;
    if (respuesta != "err_internet_conex") {
      setState(() {
        if (respuesta == 'empty') {
          noData = true;
          print('no hay datos');
        } else {
          noData = false;
          print('Respuesta en vista ::::: ${respuesta}');
          /*finances.clear();
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
            //print('Arreglo idFinance:');
            // Itera sobre la lista finances y accede al idFinance de cada objeto Finance
            for (var finance in finances) {
              //print(finance.idFinance);
            }
          }*/
        }
      });
    } else {
      noData = true;
      print('Verifique su conexion a internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
      ),
      body: ListView.builder(
        itemCount: widget.notifications.length,
        itemBuilder: (context, index) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Dismissible(
                key: Key('5'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  color: Colors.red,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) async {
                  var idFinance = 5;
                  // Eliminar el elemento de la lista de datos
                  //finances.removeWhere((element) => element.idFinance == idFinance);
                  String idFinanceString = idFinance.toString();
                  //await eliminarFinanza(idFinance: idFinanceString);
                  // Esperar a que se muestre el diálogo y se cierre completamente
                  /*await ShowDelete().showDeleteDialog(context).then((_) {
               // Llamar a setState para reconstruir la vista y mostrar los nuevos datos
               // Verificar si el widget todavía está montado
               if (mounted) {
                 // Llamar a setState solo si el widget está montado
                 setState(() {});
               }
             });*/
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.5), // Color de la sombra
                        spreadRadius: 6, // Cuánto se extiende la sombra
                        blurRadius:
                            8, // Qué tan desenfocado está el borde de la sombra
                        offset: Offset(
                            3, 10), // Desplazamiento de la sombra en x y en y
                      ),
                    ],
                  ),
                  height: MediaQuery.of(context).size.width * 0.24,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.17,
                                    width: 2,
                                    color: Color(0xff368983),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Titulo de notificacion',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 22,
                                        color: Color(0xff368983),
                                      ),
                                    ),
                                    Text(
                                      'Descripción de notificacion  ${widget.notifications[index]}',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 19,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      '05 de Junio a las 14:30 pm',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 17,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Image.asset('assets/images/Todos.png', height: 84),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );

          /*Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Descripción de notificación ${widget.notifications[index]}',
                style: GoogleFonts.fredoka(
                  fontSize: 19,
                  color: Colors.black,
                ),
              ),
            ),
          );*/
        },
      ),
    );
  }
}
