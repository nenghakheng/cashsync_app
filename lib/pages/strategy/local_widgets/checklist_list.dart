import 'package:cashsyncapp/models/stock_checklist_model.dart';
import 'package:cashsyncapp/viewModels/stock_checklist_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChecklistList extends StatelessWidget {
  const ChecklistList({super.key, required this.strategyId});

  final String? strategyId;

  @override
  Widget build(BuildContext context) {
    final StockChecklistViewModel checklistViewModel =
        Provider.of<StockChecklistViewModel>(context);
    final List<StockChecklistModel>? checklists = checklistViewModel.checklists;
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: checklists?.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text(checklists?[index].note ?? "N/A"),
          value: checklists?[index].isChecked,
          onChanged: (bool? value) {
            // Handle checkbox state change
            checklists?[index].isChecked = value ?? false;
            checklistViewModel.notifyListeners();
          },
        );
      },
    );
  }
}
