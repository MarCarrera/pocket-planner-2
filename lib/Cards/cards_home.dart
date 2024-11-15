import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pocket_planner/utils/components.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CardsHome extends StatefulWidget {
  const CardsHome({super.key});

  @override
  State<CardsHome> createState() => _CardsHomeState();
}

class _CardsHomeState extends State<CardsHome> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = Constants.getScreenHeight(context);
    double screenWidth = Constants.getScreenWidth(context);
    double fontSize = Constants.getFontSize(context);

    return Scaffold(
      backgroundColor: Constants.grayColor,
      body: Stack(
        children: [
          // Fondo blanco con borde redondeado
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: screenHeight * 0.7,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
              ),
            ],
          ),

          // Slider de tarjetas
          Positioned(
            top: screenHeight * 0.18,
            right: 0,
            left: 0,
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.4, // Altura del slider
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 5, // Número de tarjetas
                    itemBuilder: (context, index) {
                      return _buildCardContent(
                        context,
                        screenHeight,
                        screenWidth,
                        fontSize,
                        'NAME BANK ${index + 1}', // Texto dinámico
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 5, // Número de tarjetas
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.blueAccent,
                    dotColor: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget que construye el contenido de cada tarjeta
  Widget _buildCardContent(
    BuildContext context,
    double screenHeight,
    double screenWidth,
    double fontSize,
    String title,
  ) {
    return Stack(
      children: [
        // Tarjeta gris
        Container(
          height: screenHeight * 0.28,
          width: screenWidth * 0.8,
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.26),
                blurRadius: 10,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: fontSize * 1.7,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        // Tarjeta naranja
        Positioned(
          top: screenHeight * 0.106,
          right: screenWidth * 0.024,
          child: Container(
            height: screenHeight * 0.16,
            width: screenWidth * 0.75,
            decoration: BoxDecoration(
              color: orangeColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Gap(screenHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Balance:',
                      style: TextStyle(
                        fontSize: fontSize * 1.67,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$800',
                      style: TextStyle(
                        fontSize: fontSize * 1.8,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Gap(screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Ingresos:',
                          style: TextStyle(
                            fontSize: fontSize * 1.1,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '\$450',
                          style: TextStyle(
                            fontSize: fontSize * 1.05,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Egresos:',
                          style: TextStyle(
                            fontSize: fontSize * 1.1,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '\$-950',
                          style: TextStyle(
                            fontSize: fontSize * 1.05,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
