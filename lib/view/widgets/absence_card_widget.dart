import 'package:code_challenge/domain/domain.dart';
import 'package:flutter/material.dart';

class AbsenceCardWidget extends StatelessWidget {
  final Absence absence;

  const AbsenceCardWidget({super.key, required this.absence});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green.shade200;
      case 'Rejected':
        return Colors.red.shade200;
      default:
        return Colors.orange.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Member #${absence.userId}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Chip(
                  label: Text(absence.status),
                  backgroundColor: _getStatusColor(absence.status),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Type: ${absence.type}", style: const TextStyle(fontSize: 14)),
            Text("Period: ${absence.startDate} - ${absence.endDate}",
                style: const TextStyle(fontSize: 14)),
            if (absence.memberNote.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text("Member note: ${absence.memberNote}",
                    style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
              ),
            if (absence.admitterNote.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text("Admitter note: ${absence.admitterNote}",
                    style: TextStyle(fontSize: 13, color: Colors.grey[700])),
              ),
          ],
        ),
      ),
    );
  }
}
