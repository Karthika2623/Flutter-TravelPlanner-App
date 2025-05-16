import 'package:flutter/material.dart';
import 'package:travel_planner_app/screens/tour_planner_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF3A4646),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: height * 0.05,
              horizontal: width * 0.04,
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.05),
                Text(
                  'TRAVEL PLANNER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: height * 0.015),
                Text(
                  'Plan your tour and forget,\nwe will remind you in advance!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 0.04,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: height * 0.05),
                SizedBox(
                  height: height * 0.3,
                  child: Image.asset(
                    'assets/splashimage.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: height * 0.2),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TourPlannerScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.3,
                      vertical: height * 0.015,
                    ),
                    backgroundColor: const Color(0xFFC1CB9C),
                    foregroundColor: Colors.black,
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: width * 0.043,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
