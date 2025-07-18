import 'package:cashsyncapp/http/base_api.dart';
import 'package:cashsyncapp/models/stock_checklist_model.dart';

class StockChecklistService extends BaseApi {
  static const String endpoint = "/stock-checklists";

  Future<List<StockChecklistModel>?> fetchByStrategyId(
    String strategyId,
  ) async {
    final response = await get('$endpoint/$strategyId', withAuth: true);

    final List<dynamic>? checklists = response['data'] as List<dynamic>?;

    return checklists
        ?.map((checklist) => StockChecklistModel.fromJson(checklist))
        .toList();
  }

  Future<void> createChecklist(StockChecklistModel checklist) async {
    final response = await post(endpoint, checklist.toJson(), withAuth: true);

    if (response['errors'] != null) {
      throw Exception('Failed to create checklist');
    }
  }

  Future<void> updateChecklist(StockChecklistModel checklist) async {
    final response = await put(
      '$endpoint/${checklist.id}',
      checklist.toJson(),
      withAuth: true,
    );

    if (response['errors'] != null) {
      throw Exception('Failed to update checklist');
    }
  }

  Future<void> deleteChecklist(String checklistId) async {
    final response = await delete('$endpoint/$checklistId', withAuth: true);

    if (response['errors'] != null) {
      throw Exception('Failed to delete checklist');
    }
  }
}
