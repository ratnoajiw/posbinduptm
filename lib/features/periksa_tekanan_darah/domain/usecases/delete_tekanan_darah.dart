import 'package:fpdart/fpdart.dart';
import 'package:posbinduptm/core/error/failure.dart';
import 'package:posbinduptm/core/usecase/usecase.dart';
import 'package:posbinduptm/features/periksa_tekanan_darah/domain/repositories/tekanan_darah_repository.dart';

class DeleteTekananDarah implements UseCase<void, DeleteTekananDarahParams> {
  final TekananDarahRepository repository;

  DeleteTekananDarah(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteTekananDarahParams params) async {
    return await repository.deleteTekananDarah(params.tekananDarahId);
  }
}

class DeleteTekananDarahParams {
  final String tekananDarahId;

  DeleteTekananDarahParams({required this.tekananDarahId});
}
