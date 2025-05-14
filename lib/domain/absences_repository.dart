import 'package:code_challenge/domain/entities/entities.dart';

abstract class AbsencesRepository {
  Future<AllAbsences> getAbsences();
  Future<void> createExportDataFile(List<ExportDataRequest> absences);
}
