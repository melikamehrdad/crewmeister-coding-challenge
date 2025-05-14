import 'package:code_challenge/data/absences_local_data_source.dart';
import 'package:code_challenge/data/absences_remote_data_source.dart';
import 'package:code_challenge/data/models/models.dart';
import 'package:code_challenge/domain/domain.dart';

class AbsencesRepositoryImpl implements AbsencesRepository {
  final AbsencesRemoteDataSource remoteDataSource;
  final AbsencesLocalDataSource localDataSource;

  AbsencesRepositoryImpl(
      {required this.localDataSource, required this.remoteDataSource});

  @override
  Future<AllAbsences> getAbsences() async {
    try {
      final absences = await remoteDataSource.getAbsences();
      return AllAbsences(
        totalAbsenceRequestsCount: absences.totalAbsenceRequestCount,
        absenceRequests: absences.absenceRequests
            .map((absence) => Absence.fromEntity(absence.toJson()))
            .toList(),
      );
    } catch (e) {
      throw Exception('Error fetching absences: $e');
    }
  }

  @override
  Future<void> createExportDataFile(List<ExportDataRequest> absences) async {
    try {
      final absencesModel = absences
          .map((absence) => ExportDataRequestModel(
                memberName: absence.memberName,
                absenceType: absence.absenceType,
                startDate: absence.startDate,
                endDate: absence.endDate,
                memberNote: absence.memberNote,
                admitterNote: absence.admitterNote,
                status: absence.status,
              ))
          .toList();
      await localDataSource.createExportDataFile(absences: absencesModel);
    } catch (e) {
      throw Exception('Error creating export file: $e');
    }
  }
}
