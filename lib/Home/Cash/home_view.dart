import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../../background_modal_route.dart';
import '../../data/models/add_date.dart';
import '../../data/models/view_model.dart';
import '../../data/request/api_request_2.dart';
import '../../data/utility.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../../modal_data.dart';
import '../../utils/showDelete.dart';
import '../../widgets/add_screen.dart';
import '../../widgets/add_screen_cash.dart';

class HomeCash extends StatefulWidget {
  const HomeCash({Key? key}) : super(key: key);

  @override
  State<HomeCash> createState() => _HomeCashState();
}

class _HomeCashState extends State<HomeCash> {
  @override
  void initState() {
    super.initState();
    cargarCash();
  }

  Future<void> _loadData() async {
    await cargarCash();
    setState(() {}); // Actualizar la vista después de cargar los datos
  }

  //--------------------------------------------------------------------
  List<Finance> finances = [];

  String? idFinance;
  String? concept;
  String? reason;
  String? amount;
  String? type;
  String? date;
  bool noData = false;
  bool reload = false;
  //-------------------------------------------------------------------
  Future<void> cargarCash() async {
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
            for (var cash in finances) {
              //print(finance.idCash);
            }
          }
        }
      });
    } else {
      setState(() {
        noData = true;
      });

      print('Verifique su conexion a internet');
    }
  }

  //-------------------------------------------------------------------------

  // ignore: prefer_typing_uninitialized_variables
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
          ]),
        ),
      ),
    );
  }

  void handleStatefulBackdropContent(BuildContext context) async {
    final result = await Navigator.push(
      context,
      BackdropModalRoute<int>(
        overlayContentBuilder: (context) => ModalData(),
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
                    return const AddScreenCash();
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 56, 128, 195),
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
        GestureDetector(
          onTap: () {
            handleStatefulBackdropContent(context);
          },
          child: Text(
            'Ver pagos',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 19,
              color: Colors.black,
            ),
          ),
        ),
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
              height: MediaQuery.of(context).size.height * 0.236,
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
}
