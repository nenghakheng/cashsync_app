import 'package:cashsyncapp/http/api/stock_checklist_service.dart';
import 'package:cashsyncapp/models/stock_checklist_model.dart';
import 'package:cashsyncapp/viewModels/base_view_model.dart';

class StockChecklistViewModel extends BaseViewModel {
  final StockChecklistService _stockChecklistService = StockChecklistService();
  List<StockChecklistModel>? checklists = [];

  Future<void> initialize(String? strategyId) async {
    if (strategyId == null) {
      throw Exception("Strategy ID cannot be null");
    }

    checklists = await _stockChecklistService.fetchByStrategyId(strategyId);
    notifyListeners();
  }

  Future<void> createChecklist(StockChecklistModel checklist) async {
    if (checklist.strategyId == null || checklist.note!.isEmpty) {
      throw Exception("Strategy ID and note cannot be empty");
    }

    await _stockChecklistService.createChecklist(checklist);
    initialize(checklist.strategyId);

    notifyListeners();
  }
}
