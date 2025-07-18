import 'package:cashsyncapp/commons/widgets/action_button.dart';
import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/models/stock_checklist_model.dart';
import 'package:cashsyncapp/viewModels/stock_checklist_view_model.dart';
import 'package:flutter/material.dart';

class CreateChecklistDialog extends StatefulWidget {
  const CreateChecklistDialog({
    super.key,
    required this.strategyId,
    this.stockChecklistViewModel,
  });

  final String strategyId;
  final StockChecklistViewModel? stockChecklistViewModel;

  @override
  State<CreateChecklistDialog> createState() => _CreateChecklistDialogState();
}

class _CreateChecklistDialogState extends State<CreateChecklistDialog> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(ConfigConstant.padding3),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Checklist Note',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a note';
                  }
                  return null;
                },
              ),
              ConfigConstant.sizedBoxH4,
              ActionButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final note = _noteController.text;
                    final strategyId = widget.strategyId;

                    final newChecklist = StockChecklistModel(
                      note: note,
                      strategyId: strategyId,
                      isChecked: false,
                    );

                    print(
                      "Checklist create form creating checklist: ${newChecklist.toJson()}",
                    );

                    await widget.stockChecklistViewModel?.createChecklist(
                      newChecklist,
                    );

                    Navigator.of(context).pop();
                  }
                },
                title: 'Create ',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
