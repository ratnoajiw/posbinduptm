import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_kolesterol_total/domain/repositories/kolesterol_total_repository.dart';

class DeleteKolesterolTotal
    implements UseCase<void, DeleteKolesterolTotalParams> {
  final KolesterolTotalRepository repository;

  DeleteKolesterolTotal(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteKolesterolTotalParams params) async {
    return await repository.deleteKolesterolTotal(params.kolesterolTotalId);
  }
}

class DeleteKolesterolTotalParams {
  final String kolesterolTotalId;

  DeleteKolesterolTotalParams({required this.kolesterolTotalId});
}
