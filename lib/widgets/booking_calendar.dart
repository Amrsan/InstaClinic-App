import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:instaclinics/constants/app_colors.dart';
import 'package:instaclinics/constants/app_styles.dart';

class BookingCalendar extends StatefulWidget {
  final Function(DateTime, String)? onDateTimeSelected;

  const BookingCalendar({Key? key, this.onDateTimeSelected}) : super(key: key);

  @override
  State<BookingCalendar> createState() => _BookingCalendarState();
}

class _BookingCalendarState extends State<BookingCalendar> {
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxString selectedTimeSlot = RxString('');
  final List<DateTime> dates = [];
  final List<String> timeSlots = [
    '09:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '02:00 PM', '03:00 PM',
    '04:00 PM', '05:00 PM'
  ];

  @override
  void initState() {
    super.initState();
    // Generate next 7 days
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      dates.add(now.add(Duration(days: i)));
    }
    // Set default selected date to today
    selectedDate.value = now;
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEE\nMMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Date', style: AppStyles.body1),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              return Obx(() => GestureDetector(
                onTap: () => selectedDate.value = date,
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: selectedDate.value?.day == date.day
                        ? AppColors.primary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _formatDate(date),
                      textAlign: TextAlign.center,
                      style: AppStyles.body2.copyWith(
                        color: selectedDate.value?.day == date.day
                            ? Colors.white
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ));
            },
          ),
        ),
        const SizedBox(height: 24),
        Text('Select Time', style: AppStyles.body1),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: timeSlots.map((time) => Obx(() => GestureDetector(
            onTap: () {
              selectedTimeSlot.value = time;
              if (selectedDate.value != null && widget.onDateTimeSelected != null) {
                widget.onDateTimeSelected!(selectedDate.value!, time);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selectedTimeSlot.value == time
                    ? AppColors.primary
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary,
                  width: 1,
                ),
              ),
              child: Text(
                time,
                style: AppStyles.body2.copyWith(
                  color: selectedTimeSlot.value == time
                      ? Colors.white
                      : AppColors.primary,
                ),
              ),
            ),
          ))).toList(),
        ),
      ],
    );
  }
} 