import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/pages/home/local_widgets.dart/growing_stock_list.dart';
import 'package:cashsyncapp/pages/home/local_widgets.dart/strategy_list.dart';
import 'package:cashsyncapp/pages/home/local_widgets.dart/trending_stock_list.dart';
import 'package:cashsyncapp/viewModels/home_view_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel homeViewModel;

  @override
  void initState() {
    super.initState();
    homeViewModel = HomeViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: homeViewModel.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error loading data',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      homeViewModel = HomeViewModel();
                    });
                  },
                  child: const Text('Retry'),
                ),
              ],
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                homeViewModel = HomeViewModel();
              });
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(ConfigConstant.padding2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StrategyList(homeViewModel: homeViewModel),
                    TrendingStockList(homeViewModel: homeViewModel),
                    GrowingStockList(homeViewModel: homeViewModel),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
