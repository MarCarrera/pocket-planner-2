// ignore_for_file: non_constant_identifier_names

import 'package:animate_do/animate_do.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:prueba_realse_apk/Home/Bank/home_view.dart';
import 'package:prueba_realse_apk/statistics.dart';
import 'package:prueba_realse_apk/widgets/add_screen.dart';
import 'package:flutter/material.dart';
import 'package:prueba_realse_apk/widgets/Login.dart';
import 'package:prueba_realse_apk/widgets/test.dart';

import '../statisticsCash.dart';
import '../modal_data.dart';
import '../utils/prueba.dart';

class ButtomNav extends StatefulWidget {
  const ButtomNav({super.key, required this.index_color});
  final int index_color;

  @override
  State<ButtomNav> createState() => _ButtomNavState(index_color: index_color);
}

class _ButtomNavState extends State<ButtomNav> {
  //int index_color = 0;
  late int index_color;
  _ButtomNavState({required this.index_color});

  List Screen = [const Home()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screen[index_color],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: FadeInUp(
          duration: Duration(milliseconds: 2000),
          child: CustomNavigationBar(
            iconSize: 30.0,
            selectedColor: Color.fromARGB(255, 11, 57, 54),
            strokeColor: Colors.white,
            unSelectedColor: const Color.fromARGB(255, 255, 255, 255),
            backgroundColor: Color(0xff368983),
            borderRadius: Radius.circular(20.0),
            blurEffect: true,
            opacity: 0.4,
            items: [
              CustomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
              ),
              /*CustomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_cart,
                ),
              ),*/
            ],
            currentIndex: index_color,
            onTap: (index) {
              setState(() {
                index_color = index;
              });
            },
            isFloating: true,
          ),
        ),
      ),
    );
  }
}
