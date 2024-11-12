import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pocket_planner/background_modal_route.dart';
import 'package:pocket_planner/src/push_providers/push_notifications.dart';
import 'package:pocket_planner/utils/NotificationScreen.dart';
import 'package:pocket_planner/widgets/add_screen.dart';
import '../../data/controllers/finance_controller.dart';
import '../../data/models/add_date.dart';
import '../../data/models/view_model.dart';
import '../../data/request/api_request.dart';
import '../../modal_data.dart';
import '../../utils/components.dart';
import '../../utils/showConfirm.dart';
import '../../utils/showDelete.dart';
import '../../widgets/loading_dots.dart';
import 'package:gap/gap.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isAuthenticating = true;
  bool showData = true;
  String _authorized = 'No autenticado';

  final HomeService service = HomeService();
  late Future<List<Finance>> futureFinance;

  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool isFlutterLocalNotificationsInitialized = false;
  final List<String> _notifications =
      []; // Lista para almacenar las notificaciones

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
      });
      authenticated = await auth.authenticate(
        localizedReason:
            'Escanee su huella dactilar o patrón para autenticarse.',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
        //_authorized = 'Error: ${e.toString()}';
        print('Error: ${e.toString()}');
      });
      return;
    }
    if (!mounted) return;

    setState(() {
      _authorized = authenticated ? 'Autenticado' : 'No Autenticado';
    });
    if (_authorized == 'Autenticado') {
      print('Se ha pulsado autenticar');
      showData = true;
      /*Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ButtomNav(index_color: 0)),
      );*/
    }
  }

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Crear un canal de notificación
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null &&
        android != null &&
        (Platform.isAndroid || Platform.isIOS)) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO Personalizar para no utilizar el por defecto
            icon: 'launch_background',
          ),
        ),
      );
    }
  }

//-------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    futureFinance = service.cargarFinanzas();

    setupFlutterNotifications().then((value) {
      FirebaseMessaging.onMessage.listen(showFlutterNotification);
    });

    dropdownItems = _item.map((item) {
      return CoolDropdownItem<String>(
        label: item,
        value: item,
      );
    }).toList();

    PushNotifications.messagesStream.listen((data) {
      setState(() {
        _notifications.add(data); // Agregar la notificación a la lista
      });

      //navigatorKey.currentState?.pushNamed('addPay', arguments: data);
    });
  }

  Future<void> _loadData() async {
    setState(() {
      futureFinance = service.cargarFinanzas();
    }); // Actualizar la vista después de cargar los datos
  }

  //--------------------------------------------------------------------
  //List<Finance> finances = [];
  // List<Finance> data = [];

  String? idFinance;
  String? concept;
  String? reason;
  String? amount;
  String? type;
  String? date;
  bool noData = false;
  bool reload = false;

  String? selctedItem;
  String? selctedItemi;

  final pokemonDropdownController = DropdownController<String>();
  List<CoolDropdownItem<String>> dropdownItems = [];
  TextEditingController abonoC = TextEditingController();

  final List<String> _item = [
    'Ahorro Cuenta',
    'Ahorro Efectivo',
    'Gastos Diarios Cuenta',
    'Gastos Diarios Efectivo',
    "Ganancia Netflix",
    "Pago Netflix",
    "Pago Spotify", 
    'Odontologo',
    'Renta'
  ];

  //-------------------------------------------------------------------

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
    double screenHeight = Constants.getScreenHeight(context);
    double screenWidth = Constants.getScreenWidth(context);
    double fontSize = Constants.getFontSize(context);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                // Imagen de fondo
                BackgroundImage(screenHeight: screenHeight, screenWidth: screenWidth),
                // Aquí está tu contenido (lo que tenía la función Padding Data)
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.04),
                  child: Center(
                    child: FutureBuilder<List<Finance>>(
                      future: futureFinance,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Finance>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Center(
                              child: FadeInUp(
                                duration: Duration(milliseconds: 2100),
                                child: Column(
                                  children: [
                                    SizedBox(height: 0),
                                    Text(
                                      'Sin datos o problemas de red. \nVerifica tu conexión a internet.',
                                      style: GoogleFonts.fredoka(
                                          fontSize: 25, color: Colors.black),
                                    ),
                                    Image.asset('assets/gifs/noData.gif'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Center(
                              child: FadeInUp(
                                duration: Duration(milliseconds: 2100),
                                child: Column(
                                  children: [
                                    SizedBox(height: 60),
                                    Text(
                                      'Sin datos o problemas de red. \nVerifica tu conexión a internet.',
                                      style: GoogleFonts.fredoka(
                                          fontSize: 25, color: Colors.black),
                                    ),
                                    Image.asset('assets/gifs/noData.gif'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          final finance = snapshot.data!.toList();
                          return Stack(
                            children: [
                              Balances(screenWidth, fontSize),
                              Positioned(
                                top: screenHeight * 0.12,
                                left: screenWidth * 0.78,
                                child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _loadData();
                            });
                          },
                          child: FadeInUp(
                            duration: Duration(milliseconds: 1500),
                            child: Container(
                              height: 40,
                              width: 40,
                              color: const Color.fromRGBO(250, 250, 250, 0.1),
                              child: const Icon(
                                Icons.change_circle,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                              ),
                              _title(screenHeight, screenWidth, fontSize),
                              Transactions(screenHeight, screenWidth, fontSize, finance),
                              AddButtom(context,screenHeight, screenWidth)
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Positioned Balances(double screenWidth, double fontSize) {
    return Positioned(
          right: screenWidth * 0.004,
          child: FadeInUp(
            duration: Duration(milliseconds: 1700),
            child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: fontSize * 0.7,
                              backgroundColor:
                                  Color.fromARGB(255, 56, 128, 195),
                              child: Icon(
                                Icons.arrow_downward,
                                color: Colors.white,
                                size: fontSize,
                              ),
                            ),
                            SizedBox(width: 7),
                            Text(
                              'Ingresos',
                              style: GoogleFonts.fredoka(
                                fontSize: fontSize * 0.9,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: screenWidth * 0.42),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: fontSize * 0.7,
                              backgroundColor:
                                  Color.fromARGB(255, 164, 60, 59),
                              child: Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                                size: fontSize ,
                              ),
                            ),
                            SizedBox(width: 7),
                            Text(
                              'Egresos',
                              style: GoogleFonts.fredoka(
                                fontSize: fontSize * 0.9,
                                color: Colors.black,
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
                        TotalIncome(fontSize),
                        SizedBox(width: screenWidth * 0.4),
                        TotalExpense(fontSize),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.00001),
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Column(
                      children: [
                        DiferenciaTotal(fontSize),
                        Text(
                              'Balance',
                              style: GoogleFonts.fredoka(
                                fontSize: fontSize * 0.9,
                                color: Colors.black,
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
          ),
        );
  }

  Padding Transactions(double screenHeight, double screenWidth, double fontSize , List<Finance> finance) {
    return Padding(
                              padding: EdgeInsets.only(
                                  top: screenHeight * 0.3 , right: screenWidth * 0.04, left: screenWidth * 0.04, bottom: screenHeight * 0.03),
                              child: Stack(
                                children: [
                                  ListView.builder(
                                    itemCount: finance.length,
                                    itemBuilder: (context, index) {
                                      final fin = finance[index];
                                      var cant = fin.amount;
                                      int amount = int.parse(cant);
                                      NumberFormat formatoMoneda =
                                          NumberFormat.currency(symbol: '\$');
                                      return Dismissible(
                                        key: Key(fin.idFinance.toString()),
                                        direction:
                                            DismissDirection.endToStart,
                                        background: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.only(
                                                right: 20.0),
                                            color: Colors.red,
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        onDismissed: (direction) async {
                                          setState(() {
                items.removeAt(index);
              });
                                          var idFinance = fin.idFinance;
                                          finance.removeWhere((element) =>
                                              element.idFinance == idFinance);
                                          String idFinanceString =
                                              idFinance.toString();
                                          await eliminarFinanza(
                                              idFinance: idFinanceString);
                                          await ShowDelete()
                                              .showDeleteDialog(context)
                                              .then((_) {
                                            if (mounted) {
                                              setState(() {});
                                            }
                                          });
                                        },
                                        child: GestureDetector(
                                          onLongPress: () async {
                                            _showModalSheetBono(
                                                fin.idFinance,
                                                fin.type,
                                                fin.concept,
                                                fin.amount);
                                          },
                                          child: ListTile(
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.asset(
                                                'assets/images/${fin.concept}.png',
                                                height: 40,
                                              ),
                                            ),
                                            title: Text(
                                              fin.concept,
                                              style: GoogleFonts.fredoka(
                                                  fontSize: fontSize * 0.9,
                                                  color: Colors.black),
                                            ),
                                            subtitle: Text(
                                              '${fin.reason}',
                                              style: GoogleFonts.fredoka(
                                                  fontSize: fontSize * 0.8,
                                                  color: Colors.blue.shade700),
                                            ),
                                            trailing: Column(
                                              children: [
                                                showData == true
                                                    ? Text(
                                                        fin.type == 'Income'
                                                            ? formatoMoneda
                                                                .format(
                                                                    amount)
                                                            : '-' +
                                                                formatoMoneda
                                                                    .format(
                                                                        amount),
                                                        style: GoogleFonts
                                                            .fredoka(
                                                          fontSize:  fontSize * 0.76,
                                                          color: fin.type ==
                                                                  'Income'
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ),
                                                      )
                                                    : Text(
                                                        fin.type == 'Income'
                                                            ? '\$***'
                                                            : '-\$***',
                                                        style: GoogleFonts
                                                            .fredoka(
                                                          fontSize:  fontSize * 0.76,
                                                          color: fin.type ==
                                                                  'Income'
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ),
                                                      ),
                                                Text(
                                                  '${fin.date}',
                                                  style: GoogleFonts.fredoka(
                                                      fontSize:  fontSize * 0.76,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
  }

  void _showModalSheet(String type, double screenHeight, double screenWidth, double fontSize ) async {
    if (type != null) {
      var data = await mostrarDataConcept(concept: type.toString());
      var totalData = await mostrarTotalDataConcept(concept: type.toString());
      //var cant = finance.amount;
      //int amount = int.parse(totalData);
      NumberFormat formatoMoneda = NumberFormat.currency(symbol: '\$');
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Total de $type: ${formatoMoneda.format(totalData)}',
              style: GoogleFonts.fredoka(
                  fontSize: fontSize * 1.12, color: const Color(0xff368983)),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'Cerrar',
                  style: GoogleFonts.fredoka(fontSize: 22, color: Colors.black54),
                ),
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
                              'No existen movimientos para el concepto $type',
                              style: GoogleFonts.fredoka(
                                  fontSize: 25, color: Colors.black),
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
                                  style: GoogleFonts.fredoka(fontSize: fontSize * 0.9),
                                ),
                                subtitle: Text(
                                  '${item['reason']}',
                                  style: GoogleFonts.fredoka(fontSize: fontSize * 0.8),
                                ),
                                trailing: Column(
                                  children: [
                                    Text(
                                      item['type'].toString() == 'Income'
                                          ? formatoMoneda.format(amount)
                                          : '-' + formatoMoneda.format(amount),
                                      style: GoogleFonts.fredoka(
                                        fontSize: fontSize * 0.8,
                                        color:
                                            item['type'].toString() == 'Income'
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                    Text(
                                      '${item['date']}',
                                      style: GoogleFonts.fredoka(fontSize: fontSize * 0.8),
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

  void _showModalSheetBono(
      int idFinance, String type, String concepto, String amount) async {
    if (type != null) {
      var data = await mostrarDataConcept(concept: type.toString());
      var totalData = await mostrarTotalDataConcept(concept: type.toString());
      //var cant = finance.amount;
      //int amount = int.parse(totalData);
      NumberFormat formatoMoneda = NumberFormat.currency(symbol: '\$');
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Abonar al concepto: ${type == 'Expense' ? 'Gasto' : 'Ingreso'} \nDetalles: $concepto',
              style: GoogleFonts.fredoka(
                  fontSize: 20, color: const Color(0xff368983)),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Cerrar', style: GoogleFonts.fredoka(fontSize: 16)),
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                },
              )
            ],
            message: Container(
              height: MediaQuery.of(context).size.height * 0.26,
              child: Material(
                child: Container(
                  child: Column(
                    children: [
                      Text('Cantidad máxima a abonar:',
                          style: GoogleFonts.fredoka(
                              fontSize: 24,
                              color: Color.fromRGBO(47, 125, 121, 0.9))),
                      SizedBox(
                        height: 15,
                      ),
                      Text('\$$amount.00',
                          style: GoogleFonts.fredoka(
                              fontSize: 80,
                              color: Color.fromRGBO(47, 125, 121, 0.9))),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: abonoC,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 11, 57, 54),
                                  ),
                                  borderRadius: BorderRadius.circular(30)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(47, 125, 121, 0.9),
                                  ),
                                  borderRadius: BorderRadius.circular(30)),
                              prefixIcon: Icon(
                                Icons.monetization_on_rounded,
                                color: Color.fromRGBO(47, 125, 121, 0.9),
                              ),
                              hintText: '00.0',
                              filled: true,
                              fillColor: Colors.transparent),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await abonarGasto(
                              bono: abonoC.text,
                              idFinance: idFinance.toString());
                          await ShowConfirm().showConfirmDialog2(context);
                          // Llamar a setState para reconstruir la vista y mostrar los nuevos datos
                          setState(() {});
                          // Navegar de regreso a la vista de inicio y reemplazar la vista actual
                          // Navigator.of(context).pop();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color(0xff368983),
                          ),
                          width: 120,
                          height: 50,
                          child: Text('Guardar',
                              style: GoogleFonts.fredoka(
                                  fontSize: 17, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
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

  Positioned AddButtom(BuildContext context, double screenHeight, double screenWidth) {
    return Positioned(
      left: screenWidth * 0.75,
      top: screenHeight * 0.82,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeInUp(
            duration: Duration(milliseconds: 2100),
            child: ElevatedButton(
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
          ),
        ],
      ),
    );
  }

  Padding _title(double screenHeight, double screenWidth, double fontSize) {
    return Padding(
      padding: EdgeInsets.only( top: screenHeight * 0.16),
      child: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: FadeInUp(
            duration: Duration(milliseconds: 1000),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ver por: ',
                  style: GoogleFonts.fredoka(fontSize: fontSize * 1.1, color: Colors.black),
                ),
                SizedBox(
                  width: 16,
                ),
                CoolDropdown<String>(
                  controller: pokemonDropdownController,
                  dropdownList: dropdownItems,
                  defaultItem:
                      dropdownItems.isNotEmpty ? dropdownItems.last : null,
                  onChange: (String selectedItem) {
                    //print(selectedItem);
                    //handleStatefulBackdropContent(context); // Muestra el valor seleccionado en la consola
                    _showModalSheet(selectedItem, screenHeight, screenWidth,  fontSize );
                    pokemonDropdownController.close();
                  },
                  resultOptions: ResultOptions(
                    width: 200,
                    render: ResultRender.all,
                    placeholder: 'Concepto',
                    textStyle:
                        GoogleFonts.fredoka(fontSize: 17, color: Colors.black),
                    isMarquee: true,
                    icon: SizedBox(
                      width: 10,
                      height: 10,
                      child: CustomPaint(
                        painter: DropdownArrowPainter(color: Colors.green),
                      ),
                    ),
                  ),
                  dropdownOptions: DropdownOptions(
                    width: 180,
                  ),
                  dropdownItemOptions: DropdownItemOptions(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    selectedBoxDecoration: BoxDecoration(
                      color: Color(0XFFEFFAF0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        FadeInUp(
          duration: Duration(milliseconds: 1700),
          child: Text(
            'Historial de Transacciones',
            style: GoogleFonts.fredoka(fontSize:  fontSize * 1.1),

            // TextStyle(
            //   fontWeight: FontWeight.w600,
            //   fontSize: 19,
            //   color: Colors.black,
            // ),
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
            return LoadingDots();
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si hay un error
            return Text(
              '\$00.0',
              style: GoogleFonts.fredoka(fontSize: 25, color: Colors.black),
            );
          } else if (snapshot.hasData) {
            ingresos = snapshot.data!;
            NumberFormat formatoMoneda = NumberFormat.currency(symbol: '\$');
            String cantidadFormateada = formatoMoneda.format(ingresos);
            // Muestra el valor devuelto en un widget Text
            return Text(
              showData == true ? '${cantidadFormateada}' : '\$***',
              style: GoogleFonts.fredoka(fontSize: 25, color: Colors.black),
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
            return LoadingDots();
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si hay un error
            return Text(
              '\$00.0',
              style: GoogleFonts.fredoka(fontSize: 25, color: Colors.black),
            );
          } else if (snapshot.hasData) {
            ingresos = snapshot.data!;
            NumberFormat formatoMoneda = NumberFormat.currency(symbol: '\$');
            String cantidadFormateada = formatoMoneda.format(ingresos);
            // Muestra el valor devuelto en un widget Text
            return Text(
              showData == true ? '${cantidadFormateada}' : '\$***',
              style: GoogleFonts.fredoka(fontSize: 25, color: Colors.black),
            );
          } else {
            // Si no hay datos disponibles, muestra un mensaje indicando que no hay datos
            return const Text('No hay datos disponibles');
          }
        },
      ),
    );
  }

  Padding TotalIncome(double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
      ),
      child: FutureBuilder<int>(
        future: mostrarTotalIngreso(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras espera la respuesta
            return LoadingDots();
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si hay un error
            return Text(
              '\$00.0',
              style: GoogleFonts.fredoka(fontSize: fontSize * 1.1, color: Colors.black),
            );
          } else if (snapshot.hasData) {
            ingresos = snapshot.data!;
            NumberFormat formatoMoneda = NumberFormat.currency(symbol: '\$');
            String cantidadFormateada = formatoMoneda.format(ingresos);
            // Muestra el valor devuelto en un widget Text
            return Text(
              showData == true ? '${cantidadFormateada}' : '\$***',
              style: GoogleFonts.fredoka(fontSize: fontSize * 1.1 , color: Colors.black),
            );
          } else {
            // Si no hay datos disponibles, muestra un mensaje indicando que no hay datos
            return Text(
              'No hay datos disponibles',
              style: GoogleFonts.fredoka(fontSize: fontSize * 1.1, color: Colors.black),
            );
          }
        },
      ),
    );
  }

  Padding TotalExpense(double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
      ),
      child: FutureBuilder<int>(
        future: mostrarTotalGasto(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras espera la respuesta
            return LoadingDots();
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si hay un error
            return Text(
              '\$00.0',
              style: GoogleFonts.fredoka(fontSize: fontSize * 1.1, color: Colors.black),
            );
          } else if (snapshot.hasData) {
            gastos = snapshot.data!;
            NumberFormat formatoMoneda = NumberFormat.currency(symbol: '\$');
            String cantidadFormateada = formatoMoneda.format(gastos);
            // Muestra el valor devuelto en un widget Text
            return Text(
              showData == true ? '-${cantidadFormateada}' : '\$***',
              style: GoogleFonts.fredoka(fontSize: fontSize * 1.1, color: Colors.black),
            );
          } else {
            // Si no hay datos disponibles, muestra un mensaje indicando que no hay datos
            return const Text('No hay datos disponibles');
          }
        },
      ),
    );
  }

  Padding DiferenciaTotal(double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
      ),
      child: FutureBuilder<int>(
        future: mostrarDiferenciaTotal(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras espera la respuesta
            return LoadingDots();
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si hay un error
            return Text(
              '\$00.0',
              style: GoogleFonts.fredoka(fontSize: fontSize * 1.4, color: Colors.black),
            );
          } else if (snapshot.hasData) {
            ingresos = snapshot.data!;
            NumberFormat formatoMoneda = NumberFormat.currency(symbol: '\$');
            String cantidadFormateada = formatoMoneda.format(ingresos);

            // Muestra el valor devuelto en un widget Text
            return Text(
              showData == true ? '${cantidadFormateada}' : '\$***',
              style: GoogleFonts.fredoka(fontSize: fontSize * 1.4, color: Colors.black),
            );
          } else {
            // Si no hay datos disponibles, muestra un mensaje indicando que no hay datos
            return const Text('No hay datos disponibles');
          }
        },
      ),
    );
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return NotificationScreen();
                                },
                              ),
                            );
                          },
                          child: FadeInUp(
                            duration: Duration(milliseconds: 1500),
                            child: Container(
                              height: 40,
                              width: 40,
                              color: const Color.fromRGBO(250, 250, 250, 0.1),
                              child: const Icon(
                                Icons.notifications,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 70,
                      left: MediaQuery.of(context).size.width * 0.74,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _loadData();
                            });
                          },
                          child: FadeInUp(
                            duration: Duration(milliseconds: 1500),
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 48, left: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInUp(
                            duration: Duration(milliseconds: 1500),
                            child: Text(
                              obtenerSaludo(),
                              style: GoogleFonts.fredoka(
                                fontSize: 24,
                                color: Colors.white,
                              ),

                              /*const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color.fromARGB(255, 224, 223, 223),
                              ),*/
                            ),
                          ),
                          FadeInUp(
                            duration: Duration(milliseconds: 1500),
                            child: Text(
                              'Mar Carrera',
                              style: GoogleFonts.fredoka(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                              /*style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.white,
                              ),*/
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
            child: FadeInUp(
              duration: Duration(milliseconds: 1700),
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Balance Total Cuenta',
                            style: GoogleFonts.fredoka(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_authorized != 'Autenticado') {
                                _authenticate();
                              } else {
                                setState(() {
                                  showData = false;
                                  _authorized = 'No autenticado';
                                });
                              }
                            },
                            child: Icon(
                              Icons.remove_red_eye,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                         // DiferenciaTotal(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
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
                                style: GoogleFonts.fredoka(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 13,
                                backgroundColor:
                                    Color.fromARGB(255, 164, 60, 59),
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: Colors.white,
                                  size: 19,
                                ),
                              ),
                              SizedBox(width: 7),
                              Text(
                                'Egresos',
                                style: GoogleFonts.fredoka(
                                  fontSize: 16,
                                  color: Colors.white,
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
                    
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 13,
                                backgroundColor:
                                    Color.fromARGB(255, 164, 153, 3),
                                child: Icon(
                                  Icons.monetization_on,
                                  color: Colors.white,
                                  size: 19,
                                ),
                              ),
                              SizedBox(width: 7),
                              Text(
                                'Banco',
                                style: GoogleFonts.fredoka(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 13,
                                backgroundColor:
                                    Color.fromARGB(255, 164, 153, 3),
                                child: Icon(
                                  Icons.monetization_on,
                                  color: Colors.white,
                                  size: 19,
                                ),
                              ),
                              SizedBox(width: 7),
                              Text(
                                'Efectivo',
                                style: GoogleFonts.fredoka(
                                  fontSize: 16,
                                  color: Colors.white,
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
            ),
          )
        ],
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Gap(screenHeight * 0.14),
          Container(
            height: screenHeight * 0.807,
            width: screenWidth * 0.9,
            child: SizedBox.expand(
              child: Image.asset(
                "assets/img/vector.png",
                fit: BoxFit
                    .cover, // La imagen se ajusta a toda la pantalla
              ),
            ),
          ),
        ],
      ),
    );
  }
}
