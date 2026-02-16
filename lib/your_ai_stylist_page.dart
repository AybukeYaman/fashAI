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
          child: myColumn(1, 1),
          /*  child: deviceOrientation == Orientation.portrait
              ? myColumn(screenHeight, screenWidth)
              : myRow(screenHeight, screenWidth), */
        ),
      ),
    );
  }

  //BURA DİKE EKRANIN CONTAİNERLARININ BİRİM GENİŞLİK VE UZUNLUKLARINI VERİYOR ORANSAL OLARAK
  Column myColumn(double screenHeight, double screenWidth) {
    return Column(
      children: [
        Center(child: ticketContainer(0.66, 0.525)),

        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.075,
              width: MediaQuery.of(context).size.width * 1,
              child: Text(
                "Your AI Stylist",
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontFamily: "PT_Serif",
                  fontWeight: FontWeight.w600,
                  fontSize: 40,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.125,
              width: MediaQuery.of(context).size.width * 0.8,

              child: Center(
                child: Text(
                  "Get personalized outfit recommendations based on your wardrobe, mood, and the weather",
                  style: TextStyle(
                    color: Color.fromARGB(255, 91, 93, 93),
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),

        //buaraya animasyon gelecek
        Container(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.05,
          decoration: BoxDecoration(
            color: Color(0xFFDB7964),
            shape: BoxShape.circle,

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
        ),

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

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.125,
          width: MediaQuery.of(context).size.width * 1,
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
        ),
      ],
    );
  }

  /* 
  Row myRow(double sH, double sW) {
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
 */
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
}
