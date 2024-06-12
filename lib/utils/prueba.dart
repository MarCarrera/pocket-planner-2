import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Prueba extends StatefulWidget {
  const Prueba({super.key});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  @override
  Widget build(BuildContext context) {
    final idUser = ModalRoute.of(context)?.settings.arguments;

    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: SafeArea(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                background_container(context, idUser.toString()),
                Positioned(
                  top: 120,
                  child: main_container(),
                ),
              ],
            ),
          ),
        ));
  }

  Column background_container(BuildContext context, String idUser) {
    return Column(
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
          child: Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Text(
                      idUser,
                      style: GoogleFonts.fredoka(
                          fontSize: 20, color: Colors.white),
                    ),
                    const Icon(
                      Icons.attach_file_outlined,
                      color: Colors.white,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Container main_container() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Color de la sombra
            spreadRadius: 6, // Cuánto se extiende la sombra
            blurRadius: 8, // Qué tan desenfocado está el borde de la sombra
            offset: Offset(3, 10), // Desplazamiento de la sombra en x y en y
          ),
        ],
      ),
      height: MediaQuery.of(context).size.width * 1.2,
      width: MediaQuery.of(context).size.width * 0.76,
      child: Column(
        children: [
          const SizedBox(height: 50),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
