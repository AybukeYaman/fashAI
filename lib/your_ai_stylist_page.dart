import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YourAiStylistPage extends StatefulWidget {
  const YourAiStylistPage({super.key});

  @override
  State<YourAiStylistPage> createState() => _YourAiStylistPageState();
}

class _YourAiStylistPageState extends State<YourAiStylistPage>
    with SingleTickerProviderStateMixin {
      
  @override
  Widget build(BuildContext context) {
    final deviceOrientation = MediaQuery.of(context).orientation;

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
              ? myColumn(1, 1)
              : myRow(1, 1),
        ),
      ),
    );
  }

  Column myColumn(double screenHeight, double screenWidth) {
    return Column(
      children: [
        Center(child: ticketContainer(0.66, 0.525)),

        Column(
          children: [
            firstTextSizedBox(0.075, 1, 40),
            secondTextSizedBox(0.125, 0.8, 20),
          ],
        ),

        //buaraya animasyon gelecek
        sliderContainer(0.05, 0.05),

        Container(
          height: MediaQuery.of(context).size.height * 0.09,
          width: MediaQuery.of(context).size.width * 0.8,
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
        accountTextSizedBox(0.125, 1),
      ],
    );
  }

  Row myRow(double screenHeight, double screenWidth) {
    return Row(
      children: [
        Center(child: ticketContainer(0.30, 0.50)),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            firstTextSizedBox(0.14, 0.35, 32),
            secondTextSizedBox(0.3, 0.35, 17),

            //buaraya animasyon gelecek
            sliderContainer(0.05, 0.35),
          ],
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.15, //
              width: MediaQuery.of(context).size.width * 0.25, //
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
              alignment: Alignment.center,
              child: Text(
                "Get Started",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
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

            accountTextSizedBox(0.05, 0.35),
          ],
        ),
      ],
    );
  }

  /////////////////////////////////////////////////////////////////////////////
  //Insider Methods
  SizedBox accountTextSizedBox(double sH, double sW) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * sH,
      width: MediaQuery.of(context).size.width * sW,
      child: Text(
        "I already have an account",
        style: TextStyle(
          color: Color.fromARGB(255, 91, 93, 93),
          fontFamily: "Roboco",
          fontWeight: FontWeight.w400,
          fontSize: 17,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Container sliderContainer(double sH, double sW) {
    return Container(
      height: MediaQuery.of(context).size.height * sH,
      width: MediaQuery.of(context).size.width * sW, //
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
      alignment: Alignment.center,
    );
  }

  Container ticketContainer(double sW, double sH) {
    return Container(
      height: MediaQuery.of(context).size.height * sH,
      width: MediaQuery.of(context).size.width * sW,
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
        size:
            (MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.width / 120)),
        color: Colors.white,
      ),
    );
  }

  SizedBox firstTextSizedBox(double sH, double sW, double fS) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * sH,
      width: MediaQuery.of(context).size.width * sW,
      child: Text(
        "Your AI Stylist",
        style: TextStyle(
          color: Color(0xFF1A1A1A),
          fontFamily: "PT_Serif",
          fontWeight: FontWeight.w600,
          fontSize: fS,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  SizedBox secondTextSizedBox(double sH, double sW, double fS) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * sH,
      width: MediaQuery.of(context).size.width * sW,

      child: Center(
        child: Text(
          "Get personalized outfit recommendations based on your wardrobe, mood, and the weather",
          style: TextStyle(
            color: Color.fromARGB(255, 91, 93, 93),
            fontFamily: "Roboto",
            fontWeight: FontWeight.w400,
            fontSize: fS,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
