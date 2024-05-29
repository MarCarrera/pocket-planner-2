// import 'package:flutter/material.dart';
// import 'package:local_auth/local_auth.dart';



// class PruebaScreen extends StatefulWidget {
//   @override
//   _PruebaScreenState createState() => _PruebaScreenState();
// }

// class _PruebaScreenState extends State<PruebaScreen> {
//   final LocalAuthentication auth = LocalAuthentication();

//   bool _canCheckBiometrics = false;
//   String _authorized = 'Not Authorized';

//   @override
//   void initState() {
//     super.initState();
//     _checkBiometrics();
//   }

//   Future<void> _checkBiometrics() async {
//     bool canCheckBiometrics;
//     try {
//       canCheckBiometrics = await auth.canCheckBiometrics;
//     } catch (e) {
//       canCheckBiometrics = false;
//     }
//     if (!mounted) return;

//     setState(() {
//       _canCheckBiometrics = canCheckBiometrics;
//     });
//   }

//   Future<void> _authenticate() async {
//     bool authenticated = false;
//     try {
//       authenticated = await auth.authenticate(
//         localizedReason: 'Scan your fingerprint to authenticate',
//         options: const AuthenticationOptions(
//           useErrorDialogs: true,
//           stickyAuth: true,
//         ),
//       );
//     } catch (e) {
//       authenticated = false;
//     }
//     if (!mounted) return;

//     setState(() {
//       _authorized = authenticated ? 'Authorized' : 'Not Authorized';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Fingerprint Authentication'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text('Can check biometrics: $_canCheckBiometrics\n'),
//             ElevatedButton(
//               onPressed: _authenticate,
//               child: Text('Authenticate'),
//             ),
//             Text('Authorization status: $_authorized\n'),
//           ],
//         ),
//       ),
//     );
//   }
// }
