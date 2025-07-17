import 'package:cashsyncapp/http/base_api.dart';
import 'package:cashsyncapp/models/strategy_model.dart';

class StrategyService extends BaseApi {
  static const String endpoint = "/strategies";

  Future<List<StrategyModel>> fetchStrategies() async {
    final response = await get(endpoint, withAuth: true);

    final List<dynamic> strategiesList = response['data'] as List<dynamic>;
    return strategiesList
        .map((strategy) => StrategyModel.fromJson(strategy))
        .toList();
  }

  Future<StrategyModel> fetchStrategyById(String id) async {
    final response = await get("$endpoint/$id", withAuth: true);

    if (response['data'] == null) {
      throw Exception('Strategy not found');
    }

    return StrategyModel.fromJson(response['data']);
  }

  Future<List<StrategyModel>> fetchUserStrategies() async {
    final response = await get("$endpoint/user", withAuth: true);

    final List<dynamic> strategiesList = response['data'] as List<dynamic>;
    return strategiesList
        .map((strategy) => StrategyModel.fromJson(strategy))
        .toList();
  }

  Future<void> createStrategy(StrategyModel strategy) async {
    print("Creating strategy: ${strategy.toJson()}");
    final response = await post(endpoint, strategy.toJson(), withAuth: true);

    if (response['errors'] != null) {
      throw Exception('Failed to create strategy');
    }
  }

  Future<void> updateStrategy(StrategyModel strategy) async {
    final response = await put(
      "$endpoint/${strategy.id}",
      strategy.toJson(),
      withAuth: true,
    );

    if (response['errors'] != null) {
      throw Exception('Failed to update strategy');
    }
  }

  Future<void> deleteStrategy(String id) async {
    final response = await delete("$endpoint/$id", withAuth: true);

    if (response['errors'] != null) {
      throw Exception('Failed to delete strategy');
    }
  }
}
