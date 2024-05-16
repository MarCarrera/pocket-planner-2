// ignore_for_file: non_constant_identifier_names

import 'package:prueba_realse_apk/Home/Bank/home_view.dart';
import 'package:prueba_realse_apk/statistics.dart';
import 'package:prueba_realse_apk/widgets/add_screen.dart';
import 'package:flutter/material.dart';

import '../Home/Cash/home_view.dart';
import '../statisticsCash.dart';

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

  List Screen = [
    const Home(),
    const Statistics(),
    const HomeCash(),
    const StatisticsCash()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screen[index_color],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 0;
                  });
                },
                child: Icon(
                  Icons.credit_card_rounded,
                  size: 30,
                  color:
                      index_color == 0 ? const Color(0xff368983) : Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 1;
                  });
                },
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 30,
                  color:
                      index_color == 1 ? const Color(0xff368983) : Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 2;
                  });
                },
                child: Icon(
                  Icons.monetization_on_rounded,
                  size: 30,
                  color: index_color == 2
                      ? Color.fromARGB(255, 56, 128, 195)
                      : Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 3;
                  });
                },
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 30,
                  color: index_color == 3
                      ? Color.fromARGB(255, 56, 128, 195)
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
