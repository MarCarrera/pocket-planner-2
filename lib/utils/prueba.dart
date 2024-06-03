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



