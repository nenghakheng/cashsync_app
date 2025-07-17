import 'package:cashsyncapp/models/stock_checklist_model.dart';
import 'package:cashsyncapp/viewModels/base_view_model.dart';

class StockChecklistViewModel extends BaseViewModel {
  final List<StockChecklistModel>? checklists = [
    StockChecklistModel(id: "1", note: "Initial Analysis", isChecked: false),
    StockChecklistModel(id: "2", note: "Market Conditions", isChecked: false),
    StockChecklistModel(id: "3", note: "Financial Health", isChecked: false),
  ];

  Future<void> initialize() async {
    // Simulate a delay for loading data
    await Future.delayed(const Duration(seconds: 2));
    // Normally, you would fetch data from a database or API here
    notifyListeners();
  }
}
