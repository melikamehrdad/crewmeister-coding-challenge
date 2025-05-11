import 'package:code_challenge/data/absences_remote_data_source.dart';
import 'package:code_challenge/data/models/models.dart';
import 'package:code_challenge/domain/domain.dart';

class AbsencesRepositoryImpl implements AbsencesRepository {
  final AbsencesRemoteDataSource remoteDataSource;

  AbsencesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AllAbsences> getAbsences(AbsencesRequest absencesRequest) async {
    try {
      final absences = await remoteDataSource.getAbsences(
        AbsencesRequestModel(
          pageNumber: absencesRequest.pageNumber,
          pageSize: absencesRequest.pageSize,
        ),
      );
      return AllAbsences(
        totalCount: absences.totalCount,
        absences: absences.absences
            .map((absence) => Absence.fromEntity(absence.toJson()))
            .toList(),
      );
    } catch (e) {
      throw Exception('Error fetching absences: $e');
    }
  }
}
