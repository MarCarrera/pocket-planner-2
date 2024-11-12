// import 'package:animate_do/animate_do.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import '../Home/Bank/home_view.dart';
import '../widgets/buttom_nav.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isAuthenticating = false;
  String _authorized = 'No autenticado';

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      canCheckBiometrics = false;
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>Home() )// ButtomNav(index_color: 0)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Primer contenedor con la curva original
            ClipPath(
              clipper: MyCustomClipper(),
              child: Container(
                color: Color.fromRGBO(47, 125, 121, 0.9),
                height: 450, // Ajusta la altura según sea necesario
              ),
            ),
            // Segundo contenedor con la curva invertida
            ClipPath(
              clipper: MyInvertedClipper(),
              child: Container(
                color: Color.fromARGB(255, 79, 174,
                    168), // Ajusta el color y la opacidad según sea necesario
                height: 450, // Ajusta la altura según sea necesario
              ),
            ),
            Positioned(
              top: 70,
              left: 25,
              child: FadeInUp(
                  duration: Duration(seconds: 1),
                  child: Text(
                    'Pocket \nPlanner',
                    style:
                        GoogleFonts.fredoka(fontSize: 59, color: Colors.white),
                  )),
            ),
            Positioned(
              top: 230,
              left: 55,
              child: FadeInUp(
                duration: Duration(seconds: 1),
                child: Text(
                  'Gestiona tus \ngastos diarios.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(fontSize: 21, color: Colors.white),
                ),
              ),
            ),
            // Contenido superpuesto
            Positioned(
              top: 80,
              left: 175,
              height: 260,
              width: MediaQuery.of(context).size.width * 0.7,
              child: FadeInUp(
                  duration: Duration(seconds: 1),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/loginImage.png'),
                            fit: BoxFit.fill)),
                  )),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 460,
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1700),
                    child: Text(
                      'Ingresa los siguientes datos.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredoka(
                          fontSize: 21, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FadeInUp(
                      duration: Duration(milliseconds: 1700),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                                color: Color.fromRGBO(196, 135, 198, .3)),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(196, 135, 198, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              )
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Color.fromRGBO(
                                              196, 135, 198, .3)))),
                              child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Usuario",
                                    hintStyle:
                                        TextStyle(color: Colors.grey.shade700)),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Contraseña",
                                    hintStyle:
                                        TextStyle(color: Colors.grey.shade700)),
                              ),
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FadeInUp(
                      duration: Duration(milliseconds: 1700),
                      child: Center(
                          child: TextButton(
                              onPressed: () {},
                              child: Text(
                                "¿Olvidaste tu contraseña?",
                                style: TextStyle(
                                    color: Color.fromRGBO(196, 135, 198, 1)),
                              )))),
                  SizedBox(
                    height: 30,
                  ),
                  FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: MaterialButton(
                        onPressed: () {},
                        color: Color.fromRGBO(49, 39, 79, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: 50,
                        child: Center(
                          child: Text(
                            "Iniciar",
                            style: GoogleFonts.fredoka(
                                fontSize: 22, color: Colors.white),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1900),
                        child: Text(
                          'O entrar con',
                          style: GoogleFonts.fredoka(
                              fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: MaterialButton(
                        onPressed: () {
                          _authenticate();
                        },
                        color: Color.fromRGBO(49, 39, 79, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: 50,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/huella.png',
                                height: 20,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Huella Dactilar',
                                style: GoogleFonts.fredoka(
                                    fontSize: 22, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.8);

    var firstControlPoint = Offset(size.width * 0.25, size.height);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 0.75, size.height * 0.6);
    var secondEndPoint = Offset(size.width, size.height * 0.8);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0); // Lado derecho del clipper
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MyInvertedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.8);

    var firstControlPoint = Offset(size.width * 0.25, size.height * 0.6);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 0.75, size.height);
    var secondEndPoint = Offset(size.width, size.height * 0.8);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0); // Lado derecho del clipper
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
