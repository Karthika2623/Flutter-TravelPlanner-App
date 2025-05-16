import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_planner_app/model/tour_reminder_model.dart';

class AddTourReminderScreen extends StatefulWidget {
  const AddTourReminderScreen({super.key});

  @override
  State<AddTourReminderScreen> createState() => _AddTourReminderScreenState();
}

class _AddTourReminderScreenState extends State<AddTourReminderScreen> {
  final DateTime currentMonth =
      DateTime(DateTime.now().year, DateTime.now().month);
  late DateTime selectedMonth;
  final DateTime maxMonth =
      DateTime(DateTime.now().year + 5, DateTime.now().month);

  DateTime? startDate;
  DateTime? endDate;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController dateRangeController = TextEditingController();

  Future<void> saveTourReminderToFirebase(TourReminder reminder) async {
    try {
      await FirebaseFirestore.instance
          .collection('tour_reminders')
          .doc(reminder.id) // Set the document ID explicitly
          .set({
        'title': reminder.title,
        'location': reminder.location,
        'remarks': reminder.remarks,
        'startDate': reminder.startDate.toIso8601String(),
        'endDate': reminder.endDate.toIso8601String(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint('Tour reminder saved successfully.');
    } catch (e) {
      debugPrint('Failed to save reminder: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    selectedMonth = currentMonth;
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
        children: weekdays.map((day) {
          return Text(
            day,
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        }).toList(),
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
          icon:  Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add tour reminder",
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
                if (startDate != null &&
                    endDate != null &&
                    titleController.text.isNotEmpty) {
                  final newReminder = TourReminder(
                    id: FirebaseFirestore.instance
                        .collection('tour_reminders')
                        .doc()
                        .id,
                    title: titleController.text,
                    location: locationController.text,
                    remarks: remarksController.text,
                    startDate: startDate!,
                    endDate: endDate!,
                  );

                  debugPrint(newReminder.toString());
                  debugPrint('reminder id:${newReminder.id}');
                  debugPrint('Reminder Date:${newReminder.toString()}');
                  await saveTourReminderToFirebase(newReminder);
                  Navigator.pop(context, newReminder);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.4, vertical: height * 0.01),
                backgroundColor: const Color(0xFF3A4646),
                foregroundColor: Colors.black,
              ),
              child: Text(
                'Save',
                style: TextStyle(fontSize: height * 0.02, color: Colors.white),
              ),
            ),
            SizedBox(height: height * 0.03),
          ],
        ),
      ),
    );
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

  Widget _buildDateRangeField() {
    return TextField(
      readOnly: true,
      controller: dateRangeController,
      decoration: InputDecoration(
        labelText: "Date",
        border: const OutlineInputBorder(),
        hintText: getDateRangeText(),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.name,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
      ],
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildLocationField() {
    return TextField(
      controller: locationController,
      decoration: const InputDecoration(
        labelText: "Location",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
    );
  }

  Widget _buildRemarksField() {
    return TextField(
      controller: remarksController,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: "Remarks",
        border: OutlineInputBorder(),
      ),
    );
  }
}
