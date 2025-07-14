import 'package:cashsyncapp/http/api/home_service.dart';
import 'package:cashsyncapp/models/stock/growing_stock_model.dart';
import 'package:cashsyncapp/models/stock/trending_stock_model.dart';
import 'package:cashsyncapp/models/strategy_model.dart';
import 'package:cashsyncapp/viewModels/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  final HomeService _homeService = HomeService();
  List<StrategyModel> strategies = [];
  List<TrendingStockModel> trendingStocks = [];
  List<GrowingStockModel> growingStocks = [];

  Future<void> initialize() async {
    setLoading(true);

    try {
      // Fetch all data concurrently
      await Future.wait([fetchStrategies()]);
      await Future.wait([fetchTrendingStocks()]);
      await Future.wait([fetchGrowingStocks()]);
    } catch (e) {
      print("Error initializing home data: $e");
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchStrategies() async {
    strategies = await _homeService.fetchStrategies();
  }

  Future<void> fetchTrendingStocks() async {
    trendingStocks = await _homeService.fetchTrendingStocks();
  }

  Future<void> fetchGrowingStocks() async {
    growingStocks = await _homeService.fetchGrowingStocks();
  }
}
