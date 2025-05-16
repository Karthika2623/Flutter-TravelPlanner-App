import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_planner_app/screens/add_tour_remainder_screen.dart';
import 'package:travel_planner_app/screens/tour_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_planner_app/model/tour_reminder_model.dart';

class TourPlannerScreen extends StatefulWidget {
  const TourPlannerScreen({super.key});

  @override
  State<TourPlannerScreen> createState() => _TourPlannerScreenState();
}

class _TourPlannerScreenState extends State<TourPlannerScreen> {
  final List<String> years =
      List.generate(5, (index) => (DateTime.now().year + index).toString());

  final List<String> months = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC"
  ];

  late String selectedYear;
  late String selectedMonth;
  List<TourReminder> reminders = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedYear = now.year.toString();
    selectedMonth = DateFormat('MMM').format(now).toUpperCase();

    fetchTourReminders().then((loadedReminders) {
      setState(() {
        reminders = loadedReminders;
        debugPrint('Reminders Length: ${reminders.length}');
      });
    });
  }

  Future<List<TourReminder>> fetchTourReminders() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('tour_reminders')
        .orderBy('startDate')
        .get();

    debugPrint('Fetched tour reminders: ${snapshot.docs.length}');
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final reminders = TourReminder(
        id: doc.id,
        title: data['title'] ?? '',
        location: data['location'] ?? '',
        remarks: data['remarks'] ?? '',
        startDate: data['startDate'] is Timestamp
            ? (data['startDate'] as Timestamp).toDate()
            : DateTime.parse(data['startDate'] ?? ''),
        endDate: data['endDate'] is Timestamp
            ? (data['endDate'] as Timestamp).toDate()
            : DateTime.parse(data['endDate'] ?? ''),
      );
      return reminders;
    }).toList();
  }

  List<TourReminder> get filteredReminders {
    final year = int.parse(selectedYear);
    final monthIndex = months.indexOf(selectedMonth) + 1;
    return reminders.where((reminder) {
      // Check if the reminder is in the selected month/year period
      final reminderStart = reminder.startDate;
      final reminderEnd = reminder.endDate;

      // If the reminder overlaps with the selected month/year
      return !(reminderEnd.isBefore(DateTime(year, monthIndex, 1)) ||
          reminderStart.isAfter(DateTime(year, monthIndex + 1, 0)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFFD9E3C1);
    final headerText = "$selectedMonth, $selectedYear";
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04, vertical: height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good Morning',
                          style: TextStyle(
                              fontSize: height * 0.025, color: Colors.black54)),
                      Text('John Doe',
                          style: TextStyle(
                              fontSize: height * 0.020,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final newReminder = await Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  AddTourReminderScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            // Define the animation: slide from right to left
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            final tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            final offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );

                      // final newReminder = await Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) =>
                      //           const AddTourReminderScreen()),
                      // );
                      if (newReminder != null) {
                        setState(() {
                          reminders.add(newReminder);
                        });
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add tour"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black26),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.030),
                    ),
                  ),
                ],
              ),
            ),

            // Year Chips
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04, vertical: height * 0.01),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: years
                      .map((year) =>
                          yearChip(year, selected: year == selectedYear))
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04, vertical: height * 0.01),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: months.map((month) {
                    final now = DateTime.now();
                    final isDisabled = int.parse(selectedYear) == now.year &&
                        months.indexOf(month) < now.month - 1;

                    return monthChip(
                      month,
                      selected: month == selectedMonth,
                      disabled: isDisabled,
                    );
                  }).toList(),
                ),
              ),
            ),

            // Bottom Section
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.02),
                      Text(
                        headerText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.018,
                          letterSpacing: 1.2,
                        ),
                      ),
                      calendarGrid(),
                      SizedBox(height: height * 0.03),

                      // Instead of FutureBuilder, we use filteredReminders directly
                      filteredReminders.isEmpty
                          ? Column(
                              children: [
                                Image.asset('assets/taxi.png',
                                    height: height * 0.2),
                                SizedBox(height: height * 0.01),
                                const Text('No tour planned, yet!',
                                    style: TextStyle(color: Colors.black54)),
                              ],
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: filteredReminders.length,
                              itemBuilder: (context, index) {
                                final reminder = filteredReminders[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            TourDetailsPage(
                                          reminder: reminder,
                                          reminderId: reminder.id,
                                        ),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: const Color(0xFF3A4646),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: width * 0.07,
                                        vertical: height * 0.01),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            reminder.title,
                                            style: TextStyle(
                                              fontSize: height * 0.02,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Text(
                                            "🗓️ ${DateFormat('MMM d').format(reminder.startDate)} - ${DateFormat('MMM d, yyyy').format(reminder.endDate)}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on,
                                                  size: 16,
                                                  color: Colors.white),
                                              SizedBox(width: width * 0.01),
                                              Expanded(
                                                child: Text(
                                                  reminder.location,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(Icons.notes,
                                                  size: 16,
                                                  color: Colors.white),
                                              SizedBox(width: width * 0.04),
                                              Expanded(
                                                child: Text(
                                                  reminder.remarks,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget monthChip(String month,
      {bool selected = false, bool disabled = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(month),
        selected: selected,
        selectedColor: Colors.black87,
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(
          color: disabled
              ? Colors.black54
              : (selected ? Colors.white : Colors.black),
        ),
        onSelected:
            disabled ? null : (_) => setState(() => selectedMonth = month),
      ),
    );
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  Widget yearChip(String year, {bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(year),
        selected: selected,
        selectedColor: Colors.black87,
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
        onSelected: (_) => setState(() => selectedYear = year),
      ),
    );
  }

  Widget calendarGrid() {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final int year = int.parse(selectedYear);
    final int monthIndex = months.indexOf(selectedMonth) + 1;
    final int daysInMonth = _daysInMonth(year, monthIndex);
    final DateTime firstDayOfMonth = DateTime(year, monthIndex, 1);
    final int startWeekday = firstDayOfMonth.weekday % 7;

    final List<Widget> dateWidgets = [];
    final DateTime today = DateTime.now();
    final DateTime todayDateOnly = DateTime(today.year, today.month, today.day);

    for (int i = 0; i < startWeekday; i++) {
      dateWidgets.add(const SizedBox(width: 40, height: 50));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(year, monthIndex, day);

      // Find reminder for this date (if any)
      TourReminder? reminder;
      try {
        reminder = reminders.firstWhere((reminder) =>
            !currentDate.isBefore(reminder.startDate) &&
            !currentDate.isAfter(reminder.endDate));
      } catch (_) {
        reminder = null;
      }

      final bool isPastDate = currentDate.isBefore(todayDateOnly);
      Color bgColor;
      Color textColor;

      if (isPastDate) {
        bgColor = Colors.transparent;
        textColor = Colors.grey;
      } else {
        if (reminder != null) {
          bgColor = Colors.white;
          textColor = Colors.black;
        } else {
          bgColor = Colors.transparent;
          textColor = Colors.black;
        }
      }

      dateWidgets.add(
        Container(
          margin: const EdgeInsets.all(1),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days
                .map((d) => Text(
                      d,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ))
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: dateWidgets,
          ),
        ),
      ],
    );
  }
}
