import 'package:cashsyncapp/commons/widgets/strategy_card.dart';
import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/models/strategy_model.dart';
import 'package:cashsyncapp/viewModels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:cashsyncapp/commons/physics/custom_page_scroll_physics.dart';

class HorizontalStrategyList extends StatelessWidget {
  const HorizontalStrategyList({super.key, required this.homeViewModel});

  final HomeViewModel homeViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Strategies",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Color(0xFF878787),
          ),
        ),
        ConfigConstant.sizedBoxH2,
        _buildHorizontalStrategyList(homeViewModel),
      ],
    );
  }

  Widget _buildHorizontalStrategyList(HomeViewModel homeViewModel) {
    // Define item width including margin
    final double itemWidth = 320 + ConfigConstant.padding3;
    final List<StrategyModel> strategies = homeViewModel.strategies;
    return SizedBox(
      height: 100,
      child: ListView.builder(
        physics: CustomPageScrollPhysics(itemDimension: itemWidth),
        padding: EdgeInsets.zero,
        itemCount: strategies.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final StrategyModel strategy = strategies[index];
          return Container(
            margin: EdgeInsets.only(right: ConfigConstant.padding3),
            child: StrategyCard(width: 320, strategy: strategy),
          );
        },
      ),
    );
  }
}
