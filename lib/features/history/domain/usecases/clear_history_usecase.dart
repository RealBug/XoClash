import 'package:tictac/features/history/domain/repositories/history_repository.dart';

class ClearHistoryUseCase {

  ClearHistoryUseCase(this._repository);
  final HistoryRepository _repository;

  Future<void> execute() async {
    await _repository.clearHistory();
  }
}

