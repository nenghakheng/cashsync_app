import 'package:cashsyncapp/pages/home/local_widgets.dart/trending_stock_card.dart';
import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/models/stock/trending_stock_model.dart';
import 'package:cashsyncapp/viewModels/home_view_model.dart';
import 'package:flutter/material.dart';

class TrendingStockList extends StatelessWidget {
  const TrendingStockList({super.key, required this.homeViewModel});

  final HomeViewModel homeViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConfigConstant.sizedBoxH2,
        _buildGrowingStockTitle(context),
        ConfigConstant.sizedBoxH2,
        _buildTrendingStockList(context),
      ],
    );
  }

  Widget _buildGrowingStockTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Trending Stocks",
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

  Widget _buildTrendingStockList(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final TrendingStockModel trendingStock =
              homeViewModel.trendingStocks[index];
          return TrendingStockCard(stock: trendingStock);
        },
      ),
    );
  }
}
