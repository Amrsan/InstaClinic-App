class TimeSlot {
  final String startTime;
  final String endTime;

  const TimeSlot({
    required this.startTime,
    required this.endTime,
  });

  factory TimeSlot.fromString(String timeSlotString) {
    final parts = timeSlotString.split('-');
    if (parts.length != 2) {
      throw FormatException('Invalid time slot format: $timeSlotString');
    }
    return TimeSlot(
      startTime: parts[0].trim(),
      endTime: parts[1].trim(),
    );
  }

  @override
  String toString() => '$startTime-$endTime';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeSlot &&
        other.startTime == startTime &&
        other.endTime == endTime;
  }

  @override
  int get hashCode => startTime.hashCode ^ endTime.hashCode;
} 