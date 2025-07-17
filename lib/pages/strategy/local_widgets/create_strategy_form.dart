import 'package:cashsyncapp/commons/form/input_field.dart';
import 'package:cashsyncapp/commons/widgets/action_button.dart';
import 'package:cashsyncapp/commons/widgets/sub_app_bar.dart';
import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/models/strategy_model.dart';
import 'package:cashsyncapp/utils/loader/loading_dialog.dart';
import 'package:cashsyncapp/viewModels/strategy_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateStrategyForm extends StatefulWidget {
  const CreateStrategyForm({super.key});

  @override
  State<CreateStrategyForm> createState() => _CreateStrategyFormState();
}

class _CreateStrategyFormState extends State<CreateStrategyForm> {
  // ViewModel
  final StrategyViewModel strategyViewModel = StrategyViewModel();

  final _formKey = GlobalKey<FormState>();
  final _stratNameController = TextEditingController();
  final _stratDescController = TextEditingController();
  final _entryPriceController = TextEditingController();

  @override
  void dispose() {
    _stratNameController.dispose();
    _stratDescController.dispose();
    _entryPriceController.dispose();
    super.dispose();
  }

  void onFormSubmit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle form submission logic here
      final strategyName = _stratNameController.text;
      final strategyDesc = _stratDescController.text;
      final entryPrice = _entryPriceController.text;

      // Example: Print the values to console
      print('Strategy Name: $strategyName');
      print('Strategy Description: $strategyDesc');
      print('Entry Price: $entryPrice');

      LoadingDialog.instance().show(
        context: context,
        text: "Saving Strategy...",
      );

      // Create a StrategyModel instance
      final strategy = StrategyModel(
        name: strategyName,
        description: strategyDesc,
        entryPrice: double.tryParse(entryPrice) ?? 0.0,
      );

      try {
        await strategyViewModel.createStrategy(strategy); // Await if async
        // Optionally show a success message or pop the screen
      } catch (e) {
        // Optionally show an error message
      } finally {
        LoadingDialog.instance().hide(); // Always hide the dialog
      }

      // Clear the form fields after submission
      _stratNameController.clear();
      _stratDescController.clear();
      _entryPriceController.clear();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppBar(title: "Add Strategy"),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ConfigConstant.padding4),
      child: Column(
        children: [
          Text(
            "To add a new strategy, please fill out the fields below carefully in order to add card successfully.",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade500),
          ),
          ConfigConstant.sizedBoxH4,
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InputField(
                  text: "Name",
                  hintText: "Enter Strategy Name",
                  keyboardType: TextInputType.text,
                  controller: _stratNameController,
                ),
                ConfigConstant.sizedBoxH4,
                InputField(
                  text: "Description",
                  hintText: "Enter Strategy Description",
                  keyboardType: TextInputType.text,
                  controller: _stratDescController,
                ),
                ConfigConstant.sizedBoxH4,
                InputField(
                  text: "Entry Price",
                  hintText: "Enter Entry Price",
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ], // allows decimals
                  controller: _entryPriceController,
                ),
              ],
            ),
          ),
          ConfigConstant.sizedBoxH7,
          ConfigConstant.sizedBoxH7,
          ActionButton(
            title: "Save",
            onPressed: () {
              onFormSubmit(context);
            },
          ),
        ],
      ),
    );
  }
}
