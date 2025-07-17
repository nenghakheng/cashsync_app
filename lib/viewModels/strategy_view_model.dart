import 'package:cashsyncapp/http/api/strategy_service.dart';
import 'package:cashsyncapp/models/stock_checklist_model.dart';
import 'package:cashsyncapp/models/strategy_model.dart';
import 'package:cashsyncapp/viewModels/base_view_model.dart';

class StrategyViewModel extends BaseViewModel {
  final StrategyService _strategyService = StrategyService();
  List<StrategyModel> strategies = [];
  List<StockChecklistModel> stockChecklists = [];

  StrategyViewModel() {
    initialize();
  }

  Future<void> initialize() async {
    setLoading(true);
    try {
      fetchUserStrategies();
    } catch (e) {
      print("Error initializing strategy data: $e");
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchUserStrategies() async {
    strategies = await _strategyService.fetchUserStrategies();
  }

  Future<void> createStrategy(StrategyModel strategy) async {
    setLoading(true);
    try {
      await _strategyService.createStrategy(strategy);
      await fetchUserStrategies();
    } catch (e) {
      print("Error creating strategy: $e");
      rethrow;
    }
    setLoading(false);
  }
}
