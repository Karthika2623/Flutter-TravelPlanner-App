
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_planner_app/screens/tour_details_screen.dart';
import 'package:travel_planner_app/model/tour_reminder_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_planner_app/screens/tour_planner_screen.dart';

class EditTourScreen extends StatefulWidget {
  final TourReminder reminder;
  const EditTourScreen({super.key, required this.reminder});

  @override
  State<EditTourScreen> createState() => _EditTourScreenState();
}

class _EditTourScreenState extends State<EditTourScreen> {
  final DateTime currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  late DateTime selectedMonth;
  final DateTime maxMonth = DateTime(DateTime.now().year + 5, DateTime.now().month);

  DateTime? startDate;
  DateTime? endDate;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController dateRangeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedMonth = currentMonth;

    startDate = widget.reminder.startDate;
    endDate = widget.reminder.endDate;
    titleController.text = widget.reminder.title;
    locationController.text = widget.reminder.location;
    remarksController.text = widget.reminder.remarks;
    dateRangeController.text = getDateRangeText();
  }

  void _prevMonth() {
    if (selectedMonth.isAfter(currentMonth)) {
      setState(() {
        selectedMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
      });
    }
  }

  void _nextMonth() {
    if (selectedMonth.isBefore(maxMonth)) {
      setState(() {
        selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);
      });
    }
  }

  String getDateRangeText() {
    if (startDate == null) return '';
    if (endDate == null) return DateFormat('MMM d, yyyy').format(startDate!);
    return "${DateFormat('MMM d').format(startDate!)} - ${DateFormat('MMM d, yyyy').format(endDate!)}";
  }

  void _onDateTap(DateTime date) {
    setState(() {
      if (startDate == null || (startDate != null && endDate != null)) {
        startDate = date;
        endDate = null;
      } else {
        if (date.isBefore(startDate!)) {
          endDate = startDate;
          startDate = date;
        } else {
          endDate = date;
        }
      }
      dateRangeController.text = getDateRangeText();
    });
  }

  bool _isInRange(DateTime day) {
    if (startDate == null || endDate == null) return false;
    return day.isAfter(startDate!) && day.isBefore(endDate!);
  }

  bool _isSelected(DateTime day) {
    return day == startDate || day == endDate;
  }

  Widget _buildCalendarContainer() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFC9D6AE),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed:
                    selectedMonth.isAfter(currentMonth) ? _prevMonth : null,
              ),
              Text(
                DateFormat('MMMM, yyyy').format(selectedMonth),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: selectedMonth.isBefore(maxMonth) ? _nextMonth : null,
              ),
            ],
          ),
          ..._buildCalendar(),
        ],
      ),
    );
  }
  
List<Widget> _buildCalendar() {
  List<Widget> rows = [];
  DateTime firstOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
  int firstWeekday = firstOfMonth.weekday % 7; // Sunday = 0
  int daysInMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;

  List<Widget> currentRow = [];
  int totalDays = firstWeekday + daysInMonth;
  DateTime today = DateTime.now();
  DateTime currentDateOnly = DateTime(today.year, today.month, today.day); // remove time part

  for (int i = 0; i < totalDays; i++) {
    if (i < firstWeekday) {
      currentRow.add(const SizedBox(width: 40, height: 40));
    } else {
      int dayNum = i - firstWeekday + 1;
      DateTime current = DateTime(selectedMonth.year, selectedMonth.month, dayNum);
      bool isPast = current.isBefore(currentDateOnly);
      bool isSelected = _isSelected(current) && !isPast;
      bool inRange = _isInRange(current) && !isPast;

      currentRow.add(
        GestureDetector(
          onTap: isPast ? null : () => _onDateTap(current),
          child: Container(
            margin: const EdgeInsets.all(2),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white
                  : inRange
                      ? Colors.white70
                      : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$dayNum',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isPast
                      ? Colors.grey // dim past dates
                      : isSelected || inRange
                          ? Colors.black
                          : Colors.black87,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (currentRow.length == 7) {
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: currentRow,
      ));
      currentRow = [];
    }
  }

  if (currentRow.isNotEmpty) {
    while (currentRow.length < 7) {
      currentRow.add(const SizedBox(width: 40, height: 40));
    }
    rows.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: currentRow,
    ));
  }

  return [
    _buildWeekdaysHeader(),
    const SizedBox(height: 8),
    ...rows,
  ];
}

  Widget _buildWeekdaysHeader() {
    List<String> weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: weekdays
            .map((day) => Text(
                  day,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDateRangeField() {
    return TextField(
      controller: dateRangeController,
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: "Select tour date range",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
    );
  }

  Widget _buildLocationField() {
    return _buildTextField(locationController, "Location");
  }

  Widget _buildRemarksField() {
    return _buildTextField(remarksController, "Additional remarks");
  }


  Future<void> _updateReminder() async {
    if (startDate == null || titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete the required fields.")),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('tour_reminders')
        .doc(widget.reminder.id)
        .update({
      'title': titleController.text.trim(),
      'location': locationController.text.trim(),
      'remarks': remarksController.text.trim(),
      'startDate': startDate,
      'endDate': endDate,
    });

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => TourDetailsPage(reminderId: widget.reminder.id,
    //       reminder: widget.reminder.copyWith(
    //       title: titleController.text.trim(),
    //       location: locationController.text.trim(),
    //       remarks: remarksController.text.trim(),
    //       startDate: startDate!,
    //       endDate: endDate,
    //     )),
    //   ),
    // );

Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => TourDetailsPage(reminderId: widget.reminder.id,
          reminder: widget.reminder.copyWith(
          title: titleController.text.trim(),
          location: locationController.text.trim(),
          remarks: remarksController.text.trim(),
          startDate: startDate!,
          endDate: endDate,
        )),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(animation);

      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(animation);

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
      );
    },
  ),
);

  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit tour reminder",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildCalendarContainer(),
            SizedBox(height: height * 0.02),
            _buildDateRangeField(),
            SizedBox(height: height * 0.02),
            _buildTextField(titleController, "What's the tour about"),
            SizedBox(height: height * 0.02),
            _buildLocationField(),
            SizedBox(height: height * 0.02),
            _buildRemarksField(),
            SizedBox(height: height * 0.02),
            ElevatedButton(
              onPressed: () async {
                bool? confirmDelete = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFFC9D6AE),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    title: const Text("Are you sure?"),
                    content: const Text("Do you want to delete this tour?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("No", style: TextStyle(fontSize: 15)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Yes", style: TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),
                );
                if (confirmDelete == true) {
                  await FirebaseFirestore.instance
                      .collection('tour_reminders')
                      .doc(widget.reminder.id)
                      .delete();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const TourPlannerScreen()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 12),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Delete Tour', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateReminder,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: width * 0.3, vertical: height * 0.01),
                backgroundColor: const Color(0xFF3A4646),
                foregroundColor: Colors.white,
              ),
              child: const Text("Update Tour", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
