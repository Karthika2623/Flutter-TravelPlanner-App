class TourReminder {
  final String id;
  final String title;
  final String location;
  final String remarks;
  final DateTime startDate;
  final DateTime endDate;

  // Constructor
  TourReminder({
    required this.id,
    required this.title,
    required this.location,
    required this.remarks,
    required this.startDate,
    required this.endDate,
  });

  // Add copyWith method here
  TourReminder copyWith({
    String? id,
    String? title,
    String? location,
    String? remarks,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return TourReminder(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      remarks: remarks ?? this.remarks,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
