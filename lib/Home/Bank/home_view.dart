// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings, depend_on_referenced_packages, unnecessary_import

import 'dart:async';
import 'package:prueba_realse_apk/Home/Bank/components/concept_view.dart';
import 'package:prueba_realse_apk/widgets/add_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../../background_modal_route.dart';
import '../../data/models/add_date.dart';
import '../../data/models/view_model.dart';
import '../../data/request/api_request_2.dart';
import '../../test.dart';
import '../../utils/showDelete.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //FinanceController _controller = FinanceController();
  @override
  void initState() {
    super.initState();
    cargarFinanzas();
  }

  Future<void> _loadData() async {
    await cargarFinanzas();
    setState(() {}); // Actualizar la vista después de cargar los datos
  }

  //--------------------------------------------------------------------
  List<Finance> finances = [];
  List<Finance> data = [];

  String? idFinance;
  String? concept;
  String? reason;
  String? amount;
  String? type;
  String? date;
  bool noData = false;
  bool reload = false;

  String selctedItem = 'Odontologo';
  String? selctedItemi;

  //-------------------------------------------------------------------
  Future<void> cargarFinanzas() async {
    //parametros = {"opcion": "1.1"};
    reload = true;
    var respuesta = await mostrarFinanzas();
    reload = false;
    if (respuesta != "err_internet_conex") {
      setState(() {
        if (respuesta == 'empty') {
          noData = true;
          print('no hay datos');
        } else {
          noData = false;
          //print('Respuesta en vista ::::: ${respuesta}');
          finances.clear();
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
          }
        }
      });
    } else {
      noData = true;
      print('Verifique su conexion a internet');
    }
  }

  //-------------------------------------------------------------------------

  // ignore: prefer_typing_uninitialized_variables
  //var totalIngreso;
  int ingresos = 0;
  int gastos = 0;
  int cantidad = 0;
  final box = Hive.box<Add_data>('data');
  final List<String> day = [
    'Monday',
    "Tuesday",
    "Wednesday",
    "Thursday",
    'friday',
    'saturday',
    'sunday'
  ];
  final List<String> _item = [
    'Ahorro Cuenta',
    'Ahorro Efectivo',
    'Gastos Diarios Cuenta',
    'Gastos Diarios Efectivo',
    "Ganancia Netflix",
    "Pago Netflix",
    'Odontologo',
    'Renta'
  ];
  String obtenerSaludo() {
    DateTime ahora = DateTime.now();
    int hora = ahora.hour;

    if (hora >= 5 && hora < 12) {
      return 'Buenos días';
    } else if (hora >= 12 && hora < 18) {
      return 'Buenas tardes';
    } else {
      return 'Buenas noches';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(children: [
            _head(),
            _title(),
            Data(),
            AddButtom(context),
            //const ConceptView(),
          ]),
        ),
      ),
    );
  }

  void _showModalSheet() async {
    if (selctedItem != null) {
      var data = await mostrarDataConcept(concept: selctedItem.toString());
      var totalData =
          await mostrarTotalDataConcept(concept: selctedItem.toString());
      //var cant = finance.amount;
      //int amount = int.parse(totalData);
      NumberFormat formatoMoneda = NumberFormat.currency(symbol: '\$');
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Total de $selctedItem: ${formatoMoneda.format(totalData)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: const Color(0xff368983),
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            message: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: data.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'No existen movimientos para el concepto $selctedItem',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),
                            Image.asset('assets/gifs/noData.gif'),
                          ],
                        ),
                      ), // Cambia 'assets/error.gif' al path de tu GIF
                    )
                  : Material(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < data.length) {
                            // Construir elementos para los datos devueltos por la API
                            var item = data[index];
                            //var fin = data[(index).toInt()];
                            var cant = item['amount'];
                            int amount = int.parse(cant);
                            NumberFormat formatoMoneda =
                                NumberFormat.currency(symbol: '\$');

                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, right: 16, left: 16),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset(
                                      'assets/images/${item['concept']}.png',
                                      height: 40),
                                ),
                                title: Text(
                                  '${item['concept']}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  '${item['reason']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: Column(
                                  children: [
                                    Text(
                                      item['type'].toString() == 'Income'
                                          ? formatoMoneda.format(amount)
                                          : '-' + formatoMoneda.format(amount),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 19,
                                        color:
                                            item['type'].toString() == 'Income'
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                    Text(
                                      '${item['date']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
            ),
          );
        },
      );
    }
  }

  Positioned search() {
    return Positioned(
      top: -20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Mostrar por:',
            style: TextStyle(fontSize: 18),
          ),
          //name(),
          GestureDetector(
              onTap: () {
                handleStatefulBackdropContent(context);
              },
              child: Text('Datos')),
          //SearchButton(),
        ],
      ),
    );
  }

  void handleStatefulBackdropContent(BuildContext context) async {
    final result = await Navigator.push(
      context,
      BackdropModalRoute<int>(
        overlayContentBuilder: (context) => CounterContentStateful(),
      ),
    );

    setState(() {
      //backdropResult = result.toString();
    });
  }

  Positioned AddButtom(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.84,
      top: MediaQuery.of(context).size.height * 0.815,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const AddScreen();
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xff368983),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Container(
              width: 20,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _title() {
    return Padding(
      padding: EdgeInsets.only(top: 426, left: 20),
      child: Column(children: [
        search(),
        SizedBox(
          height: 16,
        ),
        Text(
          'Historial de Transacciones',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 19,
            color: Colors.black,
          ),
        ),
      ]),
    );
  }

  Padding TotalEfectivo() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
      ),
      child: FutureBuilder<int>(
        future: mostrarTotalDinero(opc: '30.7'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras espera la respuesta
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si hay un error
            return const Text(
              '\$00.0',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            );
          } else if (snapshot.hasData) {
            ingresos = snapshot.data!;
            NumberFormat formatoMoneda = NumberFormat.currency(symbol: '\$');
            String cantidadFormateada = formatoMoneda.format(ingresos);
            // Muestra el valor devuelto en un widget Text
            return Text(
              '${cantidadFormateada}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            );
          } else {
            // Si no hay datos disponibles, muestra un mensaje indicando que no hay datos
            return const Text('No hay datos disponibles');
          }
        },
      ),
    );
  }

  Padding TotalBanco() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
      ),
      child: FutureBuilder<int>(
        future: mostrarTotalDinero(opc: '30.6'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras espera la respuesta
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si hay un error
            return const Text(
              '\$00.0',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            );
          } else if (snapshot.hasData) {
            ingresos = snapshot.data!;
            NumberFormat formatoMoneda = NumberFormat.currency(symbol: '\$');
            String cantidadFormateada = formatoMoneda.format(ingresos);
            // Muestra el valor devuelto en un widget Text
            return Text(
              '${cantidadFormateada}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            );
          } else {
            // Si no hay datos disponibles, muestra un mensaje indicando que no hay datos
            return const Text('No hay datos disponibles');
          }
        },
      ),
    );
  }

  Padding TotalIncome() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
      ),
      child: FutureBuilder<int>(
        future: mostrarTotalIngreso(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras espera la respuesta
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si hay un error
            return const Text(
              '\$00.0',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            );
          } else if (snapshot.hasData) {
            ingresos = snapshot.data!;
            NumberFormat formatoMoneda = NumberFormat.currency(symbol: '\$');
            String cantidadFormateada = formatoMoneda.format(ingresos);
            // Muestra el valor devuelto en un widget Text
            return Text(
              '${cantidadFormateada}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            );
          } else {
            // Si no hay datos disponibles, muestra un mensaje indicando que no hay datos
            return const Text('No hay datos disponibles');
          }
        },
      ),
    );
  }

  Padding TotalExpense() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
      ),
      child: FutureBuilder<int>(
        future: mostrarTotalGasto(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras espera la respuesta
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si hay un error
            return const Text(
              '\$00.0',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            );
          } else if (snapshot.hasData) {
            gastos = snapshot.data!;
            NumberFormat formatoMoneda = NumberFormat.currency(symbol: '\$');
            String cantidadFormateada = formatoMoneda.format(gastos);
            // Muestra el valor devuelto en un widget Text
            return Text(
              '-${cantidadFormateada}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            );
          } else {
            // Si no hay datos disponibles, muestra un mensaje indicando que no hay datos
            return const Text('No hay datos disponibles');
          }
        },
      ),
    );
  }

  Padding DiferenciaTotal() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
      ),
      child: FutureBuilder<int>(
        future: mostrarDiferenciaTotal(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras espera la respuesta
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si hay un error
            return const Text(
              '\$00.0',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            );
          } else if (snapshot.hasData) {
            ingresos = snapshot.data!;
            NumberFormat formatoMoneda = NumberFormat.currency(symbol: '\$');
            String cantidadFormateada = formatoMoneda.format(ingresos);

            // Muestra el valor devuelto en un widget Text
            return Text(
              '${cantidadFormateada}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            );
          } else {
            // Si no hay datos disponibles, muestra un mensaje indicando que no hay datos
            return const Text('No hay datos disponibles');
          }
        },
      ),
    );
  }

  Padding Data() {
    //mientras carga la data
    if (noData == false && finances.isEmpty || reload) {
      return Padding(
        padding: const EdgeInsets.only(top: 378),
        child: Center(
          child: FutureBuilder<void>(
            future: Future.delayed(Duration(seconds: 4)),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Si estamos esperando, mostramos el CircularProgressIndicator
                return CircularProgressIndicator();
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 46),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                        ),
                        const Text(
                          'Sin datos o problemas de red. \nVerifica tu conexión a internet.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                        Image.asset('assets/gifs/noData.gif'),
                      ],
                    ),
                  ), // Cambia 'assets/error.gif' al path de tu GIF
                ); // Aquí debes reemplazar YourRegularContentWidget con tu widget habitual
              }
            },
          ),
        ),
      );
    } else
    //SI NO EXISTE DATA
    if (noData) {
      return Padding(
        padding: const EdgeInsets.only(top: 400),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              const Text(
                'Sin datos para mostrar.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
              Image.asset('assets/gifs/noData.gif'),
            ],
          ),
        ), // Cambia 'assets/error.gif' al path de tu GIF
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 538, right: 16, left: 16),
        child: Stack(children: [
          ListView.builder(
            itemCount: finances.length,
            itemBuilder: (context, index) {
              final finance = finances[index];
              var cant = finance.amount;
              int amount = int.parse(cant);
              NumberFormat formatoMoneda = NumberFormat.currency(symbol: '\$');
              return Dismissible(
                key: Key(finance.idFinance.toString()),
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
                  var idFinance = finance.idFinance;
                  // Eliminar el elemento de la lista de datos
                  finances
                      .removeWhere((element) => element.idFinance == idFinance);
                  String idFinanceString = idFinance.toString();
                  await eliminarFinanza(idFinance: idFinanceString);
                  // Esperar a que se muestre el diálogo y se cierre completamente
                  await ShowDelete().showDeleteDialog(context).then((_) {
                    // Llamar a setState para reconstruir la vista y mostrar los nuevos datos
                    // Verificar si el widget todavía está montado
                    if (mounted) {
                      // Llamar a setState solo si el widget está montado
                      setState(() {});
                    }
                  });
                },
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset('assets/images/${finance.concept}.png',
                        height: 40),
                  ),
                  title: Text(
                    finance.concept,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${finance.reason}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Column(
                    children: [
                      Text(
                        finance.type == 'Income'
                            ? formatoMoneda.format(amount)
                            : '-' + formatoMoneda.format(amount),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                          color: finance.type == 'Income'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      Text(
                        '${finance.date}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ]),
      );
    }
  }

  Widget _head() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 240,
                decoration: const BoxDecoration(
                  color: Color(0xff368983),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 70,
                      left: MediaQuery.of(context).size.width * 0.89,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _loadData();
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            color: const Color.fromRGBO(250, 250, 250, 0.1),
                            child: const Icon(
                              Icons.change_circle,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 70, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            obtenerSaludo(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 224, 223, 223),
                            ),
                          ),
                          const Text(
                            'Mar Carrera',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.14,
            left: MediaQuery.of(context).size.width * 0.15,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.253,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(47, 125, 121, 0.3),
                    offset: Offset(0, 6),
                    blurRadius: 12,
                    spreadRadius: 6,
                  ),
                ],
                color: const Color.fromARGB(255, 47, 125, 121),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Balance Total Cuenta',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 7),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        DiferenciaTotal(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor:
                                  Color.fromARGB(255, 56, 128, 195),
                              child: Icon(
                                Icons.arrow_downward,
                                color: Colors.white,
                                size: 19,
                              ),
                            ),
                            SizedBox(width: 7),
                            Text(
                              'Ingresos',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color.fromARGB(255, 216, 216, 216),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: Color.fromARGB(255, 164, 60, 59),
                              child: Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                                size: 19,
                              ),
                            ),
                            SizedBox(width: 7),
                            Text(
                              'Egresos',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color.fromARGB(255, 216, 216, 216),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TotalIncome(),
                        TotalExpense(),
                      ],
                    ),
                  ),
                  /*var totalGeneralCuenta = await mostrarTotalDinero(opc: '30.6');
      var totalGeneralEfectivo = await mostrarTotalDinero(opc: '30.7');
      print(totalGeneralCuenta);
      print(totalGeneralEfectivo); */
                  const SizedBox(height: 25),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: Color.fromARGB(255, 164, 153, 3),
                              child: Icon(
                                Icons.monetization_on,
                                color: Colors.white,
                                size: 19,
                              ),
                            ),
                            SizedBox(width: 7),
                            Text(
                              'Banco',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color.fromARGB(255, 216, 216, 216),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: Color.fromARGB(255, 164, 153, 3),
                              child: Icon(
                                Icons.monetization_on,
                                color: Colors.white,
                                size: 19,
                              ),
                            ),
                            SizedBox(width: 7),
                            Text(
                              'Efectivo',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color.fromARGB(255, 216, 216, 216),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TotalBanco(),
                        TotalEfectivo(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Padding name() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 15),
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 15),
  //       width: 300,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         border: Border.all(
  //           width: 2,
  //           color: const Color(0xffC5C5C5),
  //         ),
  //       ),
  //       child: DropdownButton<String>(
  //         value: selctedItem,
  //         onChanged: noData
  //             ? null
  //             : ((value) {
  //                 setState(() {
  //                   selctedItem = value!;

  //                 });
  //               }),
  //         items: _item
  //             .map((e) => DropdownMenuItem(
  //                   child: Container(
  //                     alignment: Alignment.center,
  //                     child: Row(
  //                       children: [
  //                         Container(
  //                           width: 40,
  //                           child: Image.asset('assets/images/${e}.png'),
  //                         ),
  //                         const SizedBox(width: 10),
  //                         Text(
  //                           e,
  //                           style: const TextStyle(fontSize: 18),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                   value: e,
  //                 ))
  //             .toList(),
  //         selectedItemBuilder: (BuildContext context) => _item
  //             .map((e) => Row(
  //                   children: [
  //                     Container(
  //                       width: 42,
  //                       child: Image.asset('assets/images/${e}.png'),
  //                     ),
  //                     const SizedBox(width: 5),
  //                     Text(e)
  //                   ],
  //                 ))
  //             .toList(),
  //         hint: const Padding(
  //           padding: EdgeInsets.only(top: 12),
  //           child: Text(
  //             'Concepto',
  //             style: TextStyle(color: Colors.grey),
  //           ),
  //         ),
  //         dropdownColor: Colors.white,
  //         isExpanded: true,
  //         underline: Container(),
  //         onTap: noData
  //             ? () {}
  //             : null, // Deshabilita el tap si noData es verdadero
  //       ),
  //     ),
  //   );
  // }
}
