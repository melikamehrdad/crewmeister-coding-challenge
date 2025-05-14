import 'package:code_challenge/domain/domain.dart';
import 'package:flutter/material.dart';

class AbsenceCardWidget extends StatelessWidget {
  final Absence absence;

  const AbsenceCardWidget({super.key, required this.absence});

  Color _getStatusColor(AbsenceRequestStatus status) {
    switch (status) {
      case AbsenceRequestStatus.confirmed:
        return Colors.green.shade200;
      case AbsenceRequestStatus.rejected:
        return Colors.red.shade200;
      default:
        return Colors.blue.shade200;
    }
  }

  Widget _buildMemberAvatar() {
    if (absence.memberImage == 'Unknown') {
      return const SizedBox();
    }
    return CircleAvatar(
      backgroundImage: NetworkImage(absence.memberImage),
      radius: 24,
      onBackgroundImageError: (_, __) => const Icon(Icons.error),
      child: absence.memberImage.isEmpty
          ? const CircularProgressIndicator()
          : null,
    );
  }

  Widget _buildMemberInfo() {
    return Row(
      children: [
        _buildMemberAvatar(),
        SizedBox(width: absence.memberImage == 'Unknown' ? 0 : 10),
        Text(
          absence.memberName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Chip(
          label: Text(absence.status.name),
          backgroundColor: _getStatusColor(absence.status),
        ),
      ],
    );
  }

  Widget _buildAbsenceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Type: ${absence.type}", style: const TextStyle(fontSize: 14)),
        Text("Period: ${absence.startDate} - ${absence.endDate}",
            style: const TextStyle(fontSize: 14)),
        if (absence.memberNote.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              "Member note: ${absence.memberNote}",
              style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
            ),
          ),
        if (absence.admitterNote.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              "Admitter note: ${absence.admitterNote}",
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
      ],
    );
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
            _buildMemberInfo(),
            const SizedBox(height: 8),
            _buildAbsenceDetails(),
          ],
        ),
      ),
    );
  }
}
