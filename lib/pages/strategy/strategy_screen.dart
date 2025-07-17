import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/pages/strategy/local_widgets/create_strategy_form.dart';
import 'package:cashsyncapp/pages/strategy/local_widgets/strategy_list.dart';
import 'package:cashsyncapp/viewModels/strategy_view_model.dart';
import 'package:flutter/material.dart';

class StrategyScreen extends StatefulWidget {
  const StrategyScreen({super.key});

  @override
  State<StrategyScreen> createState() => _StrategyScreenState();
}

class _StrategyScreenState extends State<StrategyScreen> {
  late StrategyViewModel strategyViewModel;
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    strategyViewModel = StrategyViewModel();
    _future = strategyViewModel.initialize();
  }

  void _refresh() {
    setState(() {
      strategyViewModel = StrategyViewModel();
      _future = strategyViewModel.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.all(ConfigConstant.padding2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Strategies",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF878787),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return CreateStrategyForm();
                            },
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add_circle_outline,
                        size: ConfigConstant.iconSize3,
                        color: Color(0xFF5164BF),
                      ),
                    ),
                  ],
                ),
                ConfigConstant.sizedBoxH2,
                Expanded(
                  child: StrategyList(strategyViewModel: strategyViewModel),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
