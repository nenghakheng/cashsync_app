import 'package:cashsyncapp/commons/widgets/strategy_card.dart';
import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/models/strategy_model.dart';
import 'package:cashsyncapp/viewModels/strategy_view_model.dart';
import 'package:flutter/material.dart';

class StrategyList extends StatelessWidget {
  const StrategyList({super.key, required this.strategyViewModel});

  final StrategyViewModel strategyViewModel;

  @override
  Widget build(BuildContext context) {
    final List<StrategyModel> strategies = strategyViewModel.strategies;
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: strategies.length,
      itemBuilder: (context, index) {
        final StrategyModel strategy = strategies[index];
        return Container(
          margin: EdgeInsets.only(top: ConfigConstant.margin1),
          child: StrategyCard(strategy: strategy),
        );
      },
    );
  }
}
