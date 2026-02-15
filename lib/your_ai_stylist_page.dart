import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YourAiStylistPage extends StatefulWidget {
  const YourAiStylistPage({super.key});

  @override
  State<YourAiStylistPage> createState() => _YourAiStylistPageState();
}

class _YourAiStylistPageState extends State<YourAiStylistPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  void _initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    animationController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final deviceOrientation = MediaQuery.of(context).orientation;
    print(deviceOrientation);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5C1B3), Color(0xFFFDF8F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 0.6],
          ),
        ),

        child: Container(
          child: deviceOrientation == Orientation.portrait
              ? myColumn(screenHeight, screenWidth)
              : myRow(screenHeight, screenWidth),
        ),
      ),
    );
  }

  Column myColumn(double screenHeight, double screenWidth) {
    return Column(
      children: [
        Center(child: ticketContainer(screenHeight, screenWidth, 3)),

        Row(
          children: [
            Container(
              height: screenHeight * 0.1,
              width: screenWidth * 0.8,
              child: Text(
                "Your AI Stylist",
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontFamily: "PT_Serif",
                  fontWeight: FontWeight.w600,
                  fontSize: 40,
                ),
              ),
            ),
            Container(
              height: screenHeight * 0.1,
              width: screenWidth * 0.2,
              child: Text(
                "Get personalized outfit recommendations based on your wardrobe, mood, and the weather",
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontFamily: "PT_Serif",
                  fontWeight: FontWeight.w600,
                  fontSize: 40,
                ),
              ),
            ),
          ],
        ),

        Container(
          height: screenHeight * 0.09,
          width: screenWidth * 0.8,
          decoration: BoxDecoration(
            color: Color(0xFFDB7964),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(
                  255,
                  216,
                  135,
                  117,
                ).withValues(alpha: 0.2),
                spreadRadius: 20,
                blurRadius: 20,
              ),
            ],
          ),
          alignment: AlignmentGeometry.center,
          child: Text(
            "Get Started",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Roboto",
              fontWeight: FontWeight.bold,
              fontSize: 23,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.0, 2.0),
                  blurRadius: 4.0,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row myRow(double screenHeight, double screenWidth) {
    return Row(
      children: [
        Center(child: ticketContainer(screenHeight, screenWidth, 5)),
        Container(
          height: screenHeight * 0.33,
          width: screenWidth * 0.33,
          decoration: BoxDecoration(
            color: Color(0xFFDB7964),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          height: screenHeight * 0.33,
          width: screenWidth * 0.33,
          decoration: BoxDecoration(
            color: Color(0xFFDB7964),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Container ticketContainer(
    double screenHeight,
    double screenWidth,
    double size,
  ) {
    return Container(
      height: screenHeight * 0.65,
      width: screenWidth * 0.7,
      decoration: BoxDecoration(
        color: Color(0xFFDB7964),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 216, 135, 117).withValues(alpha: 0.2),
            spreadRadius: 20,
            blurRadius: 20,
          ),
        ],
      ),
      child: Icon(
        Icons.label_outline_rounded,
        size: (screenWidth / size),
        color: Colors.white,
      ),
    );
  }
}
