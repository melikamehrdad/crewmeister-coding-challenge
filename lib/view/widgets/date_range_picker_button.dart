import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangePickerButton extends StatelessWidget {
  final DateTimeRange? selectedDateRange;
  final ValueChanged<DateTimeRange?> onDateRangePicked;

  const DateRangePickerButton({
    required this.selectedDateRange,
    required this.onDateRangePicked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () async {
          final picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime(2025),
            initialDateRange: selectedDateRange,
            currentDate: DateTime.now(),
          );
          onDateRangePicked(picked);
        },
        icon: Icon(
          Icons.date_range,
          color: selectedDateRange == null ? Colors.black54 : Colors.green,
        ),
        label: Text(
          selectedDateRange == null
              ? 'Date'
              : '${DateFormat('dd MMM').format(selectedDateRange!.start)} - ${DateFormat('dd MMM').format(selectedDateRange!.end)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selectedDateRange == null ? Colors.black54 : Colors.green,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: selectedDateRange == null ? Colors.black54 : Colors.green,
            ),
          ),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
