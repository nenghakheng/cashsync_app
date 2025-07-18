import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/models/stock_checklist_model.dart';
import 'package:cashsyncapp/pages/strategy/local_widgets/create_checklist_dialog.dart';
import 'package:cashsyncapp/viewModels/stock_checklist_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChecklistList extends StatelessWidget {
  const ChecklistList({super.key, required this.strategyId});

  final String strategyId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = StockChecklistViewModel();
        vm.initialize(strategyId);
        return vm;
      },
      child: Column(
        children: [
          Consumer<StockChecklistViewModel>(
            builder: (context, checklistViewModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChecklistListTitle(
                    context,
                    strategyId,
                    checklistViewModel,
                  ),
                  ConfigConstant.sizedBoxH3,
                  _buildChecklist(
                    context,
                    checklistViewModel.checklists,
                    checklistViewModel,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistListTitle(
    BuildContext context,
    String strategyId,
    StockChecklistViewModel checklistViewModel,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Checklist",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF878787),
          ),
        ),
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (context) => CreateChecklistDialog(
                    strategyId: strategyId,
                    stockChecklistViewModel: checklistViewModel,
                  ),
            );
          },
          child: Row(
            children: [
              const Icon(Icons.add, color: Color(0xFF5163BF)),
              const Text(
                "Add Checklist",
                style: TextStyle(
                  color: Color(0xFF5163BF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChecklist(
    BuildContext context,
    List<StockChecklistModel>? checklists,
    StockChecklistViewModel checklistViewModel,
  ) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: checklists?.isEmpty == true ? 1 : checklists?.length,
      itemBuilder: (context, index) {
        if (checklists == null || checklists.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(ConfigConstant.padding2),
            child: const Center(child: Text("No checklists available")),
          );
        }

        return CheckboxListTile(
          title: Text(checklists[index].note ?? "N/A"),
          value: checklists[index].isChecked,
          onChanged: (bool? value) {
            // Handle checkbox state change
            checklists[index].isChecked = value ?? false;
            checklistViewModel.notifyListeners();
          },
        );
      },
    );
  }
}
