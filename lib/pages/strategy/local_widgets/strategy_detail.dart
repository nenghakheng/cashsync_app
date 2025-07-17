import 'package:cashsyncapp/commons/widgets/sub_app_bar.dart';
import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/models/strategy_model.dart';
import 'package:cashsyncapp/pages/strategy/local_widgets/checklist_list.dart';
import 'package:cashsyncapp/viewModels/stock_checklist_view_model.dart';
import 'package:flutter/material.dart';

class StrategyDetail extends StatefulWidget {
  const StrategyDetail({super.key, required this.strategy});

  final StrategyModel strategy;

  @override
  State<StrategyDetail> createState() => _StrategyDetailState();
}

class _StrategyDetailState extends State<StrategyDetail> {
  late StockChecklistViewModel stockChecklistViewModel;
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    stockChecklistViewModel = StockChecklistViewModel();
    _future = stockChecklistViewModel.initialize();
  }

  void _refresh() {
    setState(() {
      stockChecklistViewModel = StockChecklistViewModel();
      _future = stockChecklistViewModel.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppBar(title: "Strategy Detail"),
      body: _buildBody(context, widget.strategy.id),
    );
  }

  Widget _buildBody(BuildContext context, String? strategyId) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF5164BF)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error loading strategies',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _refresh, child: const Text('Retry')),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => _refresh(),
          child: Container(
            padding: const EdgeInsets.all(ConfigConstant.padding4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [_buildStrategyInfo(context)]),
                ConfigConstant.sizedBoxH3,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInitialPrice(context),
                    ConfigConstant.sizedBoxH3,
                    _buildProfitLoss(context),
                  ],
                ),
                ConfigConstant.sizedBoxH3,
                Expanded(child: _buildCheckList(context, strategyId)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStrategyInfo(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ConfigConstant.radius2),
          color: Colors.blueGrey[50],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(ConfigConstant.padding3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.strategy.name ?? "No Name",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5163BF),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.strategy.description ?? "No description.",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialPrice(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Initial Price",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Color(0xFF878787),
          ),
        ),
        Text(
          "\$ ${widget.strategy.entryPrice?.toStringAsFixed(2) ?? 'N/A'}",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Color(0xFF5163BF),
          ),
        ),
      ],
    );
  }

  Widget _buildProfitLoss(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Profit/Loss",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Color(0xFF878787),
          ),
        ),
        Text(
          "\$ ${widget.strategy.profitLoss?.toStringAsFixed(2) ?? 'N/A'}",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color:
                widget.strategy.profitLoss != null &&
                        widget.strategy.profitLoss! >= 0
                    ? Color(0xFF4CAF50) // Green for profit
                    : Color(0xFFF44336), // Red for loss
          ),
        ),
      ],
    );
  }

  Widget _buildChecklistListTitle(BuildContext context) {
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
          onPressed: () {},
          child: Row(
            children: [
              const Text(
                "View All",
                style: TextStyle(
                  color: Color(0xFF5163BF),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Color(0xFF5163BF)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckList(BuildContext context, String? strategyId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChecklistListTitle(context),
        Expanded(child: ChecklistList(strategyId: strategyId)),
      ],
    );
  }
}
