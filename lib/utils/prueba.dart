//----------------CURVA EN FLUTTER---------------------------------------------------------

/*import 'package:flutter/material.dart';

class Prueba extends StatelessWidget {
  const Prueba({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            ClipPath(
              clipper: MyCustomClipper(),
              child: Container(
                color: Colors.blue,
                height: 400,
              ),
            ),
            Expanded(
              child: Center(
                child: Text('Contenido debajo de la curva'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  // Path getClip(Size size) {
  //   var path = Path();
  //   path.lineTo(0, size.height - 100);
  //   var firstControlPoint = Offset(size.width / 2, size.height);
  //   var firstEndPoint = Offset(size.width, size.height - 100);
  //   path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
  //       firstEndPoint.dx, firstEndPoint.dy);
  //   path.lineTo(size.width, 0);
  //   path.close();
  //   return path;
  // }

  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.8); // Inicio de la primera curva

//---------------PRIMERA CURVA -----------------------------------------------------
    /*var firstControlPoint = Offset(size.width * 0.25, size.height);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 0.75, size.height * 0.6);
    var secondEndPoint = Offset(size.width, size.height * 0.8);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);*/

    //-------SEGUNDA CURVA --------------------------------------------------------
    var firstControlPoint = Offset(size.width * 0.25, size.height * 0.6);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 0.75, size.height);
    var secondEndPoint = Offset(size.width, size.height * 0.8);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    //-------------------------------------------------------------------------------

    path.lineTo(size.width, 0); // Lado derecho del clipper
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}*/

//-----------CIRCULO EN FLUTTER -----------------------------------------------------------------------------------------------------

// import 'package:flutter/material.dart';

// class Prueba extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Container(
//             width: 200,
//             height: 200,
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               borderRadius:
//                   BorderRadius.circular(100), // Crea una curva circular
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//-----------curva compleja----------------------------------------------------------------------------------------------------
// import 'package:flutter/material.dart';

// class Prueba extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: CustomPaint(
//             size: Size(300, 300),
//             painter: MyCustomPainter(),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MyCustomPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.fill;

//     var path = Path();
//     path.moveTo(0, size.height * 0.5);
//     path.quadraticBezierTo(
//         size.width / 2, size.height, size.width, size.height * 0.5);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.close();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }

//---------------------------------------- CURVAS ENCIMADAS ----------------------------

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class Prueba extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
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
            // Contenido superpuesto
            Positioned(
              top: -40,
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: FadeInUp(
                  duration: Duration(seconds: 1),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/loginImage.png'),
                            fit: BoxFit.fill)),
                  )),
            ),
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
