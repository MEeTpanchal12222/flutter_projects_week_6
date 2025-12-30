import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/module/Home/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Planto.Shop',
                style: GoogleFonts.cabin(
                  textStyle: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff3d3d4e),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Plant a',
                style: GoogleFonts.cabin(
                  textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.12),
                ),
              ),
              Text(
                'tree for life',
                style: GoogleFonts.cabin(
                  textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.12),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: screenHeight * 0.42,
                child: Image.asset(
                  'Assets/plant.png',
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.center,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Worldwide delivery\n within 10-15 days',
                textAlign: TextAlign.center,
                style: GoogleFonts.cabin(
                  textStyle: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: Container(
                  height: screenWidth * 0.15,
                  width: screenWidth * 0.15,
                  decoration: BoxDecoration(
                    color: const Color(0xff51AC97),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff51AC97).withValues(alpha: 0.7),
                        blurRadius: 15,
                        spreadRadius: 0.5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'GO',
                    style: GoogleFonts.cabin(
                      textStyle: TextStyle(color: Colors.white, fontSize: screenWidth * 0.05),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
