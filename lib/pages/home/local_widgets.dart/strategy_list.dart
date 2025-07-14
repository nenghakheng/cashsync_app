import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/models/strategy_model.dart';
import 'package:cashsyncapp/viewModels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:cashsyncapp/commons/physics/custom_page_scroll_physics.dart';

class StrategyList extends StatelessWidget {
  const StrategyList({super.key, required this.homeViewModel});

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
        _buildStrategyList(homeViewModel),
      ],
    );
  }

  Widget _buildStrategyList(HomeViewModel homeViewModel) {
    // Define item width including margin
    final double itemWidth = 380 + ConfigConstant.padding3;
    final List<StrategyModel> strategies = homeViewModel.strategies;
    print("Strategies count: ${strategies.length}");
    return SizedBox(
      height: 100,
      child: ListView.builder(
        physics: CustomPageScrollPhysics(itemDimension: itemWidth),
        padding: EdgeInsets.zero,
        itemCount: strategies.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final StrategyModel strategy = strategies[index];
          return _buildStrategyCard(context, strategy);
        },
      ),
    );
  }

  Widget _buildStrategyCard(BuildContext context, StrategyModel strategy) {
    return Container(
      width: 380,
      margin: EdgeInsets.only(right: ConfigConstant.padding3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Color(0xFF5163BF), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildTileIcon(strategy),
            SizedBox(width: 16),
            _buildStrategyInfo(strategy),
            SizedBox(width: 8),
            _buildTileTrailing(strategy),
          ],
        ),
      ),
    );
  }

  Widget _buildTileIcon(StrategyModel strategy) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.blueGrey[100],
      child: Icon(Icons.trending_up, color: Colors.blueGrey[700], size: 30),
    );
  }

  Widget _buildTileTitle(StrategyModel strategy) {
    return Expanded(
      child: Text(
        "Strategy ${strategy.name}",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.blueGrey[800],
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildStrategyInfo(StrategyModel strategy) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(children: [_buildTileTitle(strategy)]),
          ConfigConstant.sizedBoxH0,
          Row(
            children: [
              Expanded(
                child: Text(
                  "Description: ${strategy.description}",
                  style: TextStyle(fontSize: 12, color: Colors.blueGrey[400]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTileTrailing(StrategyModel strategy) {
    return Icon(Icons.arrow_forward_ios, color: Colors.blueGrey[600], size: 20);
  }
}
