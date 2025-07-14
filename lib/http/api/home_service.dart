import 'package:cashsyncapp/http/base_api.dart';
import 'package:cashsyncapp/models/stock/growing_stock_model.dart';
import 'package:cashsyncapp/models/stock/trending_stock_model.dart';
import 'package:cashsyncapp/models/strategy_model.dart';

class HomeService extends BaseApi {
  static const String endpoint = "/home";

  Future<List<StrategyModel>> fetchStrategies() async {
    final response = await get("$endpoint/strategies", withAuth: true);

    final List<dynamic> strategiesList = response['data'] as List<dynamic>;
    return strategiesList
        .map((strategy) => StrategyModel.fromJson(strategy))
        .toList();
  }

  Future<List<TrendingStockModel>> fetchTrendingStocks() async {
    final response = await get("$endpoint/stocks/trending", withAuth: true);

    final List<dynamic> trendingStocksList = response['data'] as List<dynamic>;
    print("Trending Stocks Response: $response");
    return trendingStocksList
        .map((stock) => TrendingStockModel.fromJson(stock))
        .toList();
  }

  Future<List<GrowingStockModel>> fetchGrowingStocks() async {
    final response = await get("$endpoint/stocks/growing", withAuth: true);

    final List<dynamic> growingStocksList = response['data'] as List<dynamic>;
    print("Growing Stocks Response: $response");
    return growingStocksList
        .map((stock) => GrowingStockModel.fromJson(stock))
        .toList();
  }
}
