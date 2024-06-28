import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/models/view_model.dart';
import '../data/request/api_request.dart';
import 'showDelete.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool noData = false;
  List<MyNotification> notifications = [];

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

          if (respuesta.isNotEmpty) {
            notifications.clear();
            for (int i = 0; i < respuesta.length; i++) {
              notifications.add(MyNotification(
                  idNot: respuesta[i]['idNot'],
                  projectId: respuesta[i]['projectId'],
                  tokenUser: respuesta[i]['tokenUser'],
                  messageId: respuesta[i]['messageId'],
                  title: respuesta[i]['title'],
                  body: respuesta[i]['body'],
                  fecha: respuesta[i]['fecha']));
            }
            //print('Arreglo idFinance:');
            // Itera sobre la lista finances y accede al idFinance de cada objeto Finance
            for (var notification in notifications) {
              //print(finance.idFinance);
            }
          }
        }
      });
    } else {
      noData = true;
      print('Verifique su conexion a internet');
    }
  }

  @override
  void initState() {
    super.initState();
    cargarNotificaciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Dismissible(
                key: Key(notif.idNot.toString()),
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
                  //var idNot = notif.idNot;
                  // Eliminar el elemento de la lista de datos
                  setState(() {
                    notifications.removeAt(
                        index); // Usar removeAt para eliminar por índice
                  });
                  //String idNotifString = idNot.toString();
                  await eliminarNotificacion(idNot: notif.idNot.toString());
                  // Esperar a que se muestre el diálogo y se cierre completamente
                  await ShowDelete().showDeleteNotif(context).then((_) {
                    // Llamar a setState para reconstruir la vista y mostrar los nuevos datos
                    // Verificar si el widget todavía está montado
                    if (mounted) {
                      // Llamar a setState solo si el widget está montado
                      setState(() {});
                    }
                  });
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
                  height: MediaQuery.of(context).size.height * 0.12,
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
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
                                      '${notif.title}',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 22,
                                        color: Color(0xff368983),
                                      ),
                                    ),
                                    Text(
                                      '${notif.body}',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 17,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      '${notif.fecha}',
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
        },
      ),
    );
  }
}
