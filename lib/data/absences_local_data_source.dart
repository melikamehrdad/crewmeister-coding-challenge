import 'package:code_challenge/data/models/models.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AbsencesLocalDataSource {
  Future<void> createExportDataFile({
    required List<ExportDataRequestModel> absences,
  }) async {
    final exportFileContent = _generateCalendarContent(absences);
    await _saveExportFile(exportFileContent);
  }

  String _generateCalendarContent(List<ExportDataRequestModel> absences) {
    final buffer = StringBuffer();

    buffer.writeln(_generateCalendarHeader());

    for (var absence in absences) {
      buffer.writeln(_generateEventContent(absence));
    }

    buffer.writeln(_generateCalendarFooter());
    return buffer.toString();
  }

  String _generateCalendarHeader() {
    return '''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Your Company//NONSGML v1.0//EN
''';
  }

  String _generateCalendarFooter() {
    return 'END:VCALENDAR';
  }

  String _generateEventContent(ExportDataRequestModel absence) {
    return '''
BEGIN:VEVENT
SUMMARY:Absence of ${absence.memberName}
LOCATION:Not specified
DESCRIPTION:Type of absence: ${absence.absenceType}
DTSTART:${_formatDateTime(absence.startDate)}
DTEND:${_formatDateTime(absence.endDate)}
UID:${_generateUniqueId()}
STATUS:${absence.status}
SEQUENCE:0
BEGIN:VALARM
TRIGGER:-PT10M
DESCRIPTION:Reminder
ACTION:DISPLAY
END:VALARM
MEMBER NOTE: ${absence.memberNote ?? 'No member note'}
ADMITTER NOTE: ${absence.admitterNote ?? 'No admitter note'}
END:VEVENT
''';
  }

  Future<void> _saveExportFile(String content) async {
    final fileBytes = Uint8List.fromList(content.codeUnits);
    await FileSaver.instance.saveFile(
      name: 'absence_event.ics',
      bytes: fileBytes,
      ext: 'ics',
    );
  }

  String _formatDateTime(String date) {
    final parsedDate = DateFormat('yyyy-MM-dd').parse(date);
    return DateFormat('yyyyMMdd\'T\'HHmmss\'Z\'').format(parsedDate.toUtc());
  }

  String _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
