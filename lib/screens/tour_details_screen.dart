import 'package:flutter/material.dart';
import 'package:travel_planner_app/screens/add_tour_remainder_screen.dart';
import 'package:intl/intl.dart';
import 'package:travel_planner_app/screens/edit_tour_screen.dart';
import 'package:travel_planner_app/model/tour_reminder_model.dart';
import 'package:travel_planner_app/screens/tour_planner_screen.dart';

class TourDetailsPage extends StatefulWidget {
  final TourReminder reminder;
  final String reminderId;
  const TourDetailsPage(
      {super.key, required this.reminder, required this.reminderId});

  @override
  State<TourDetailsPage> createState() => _TourDetailsPageState();
}

class _TourDetailsPageState extends State<TourDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0XFFC1CB9C),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2E9C8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TourPlannerScreen()),
            );
          },
        ),
        title: const Text(
          'Tour details',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2F3E46),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  // ClipRRect(
                  //   borderRadius:
                  //       const BorderRadius.vertical(top: Radius.circular(20)),
                  //   child: Image.asset(
                  //     'assets/splashimage.png',
                  //     fit: BoxFit.cover,
                  //     height: 200,
                  //     width: double.infinity,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.01),
                        Text(
                          '🗓️ ${DateFormat('MMM d').format(widget.reminder.startDate)} - ${DateFormat('MMM d, yyyy').format(widget.reminder.endDate)}',
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          widget.reminder.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: height * 0.01),
                        Row(
                          children: [
                            Icon(Icons.location_pin,
                                color: Colors.white, size: height * 0.02),
                            SizedBox(width: 5),
                            Text(
                              widget.reminder.location,
                              style: TextStyle(
                                  color: Colors.white, fontSize: height * 0.02),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          widget.reminder.remarks,
                          style: TextStyle(color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F3E46),
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.4, vertical: height * 0.015),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditTourScreen(reminder: widget.reminder),
                  ),
                );
              },
              child: Text('Edit',
                  style:
                      TextStyle(color: Colors.white, fontSize: height * 0.02)),
            ),
          ],
        ),
      ),
    );
  }
}
