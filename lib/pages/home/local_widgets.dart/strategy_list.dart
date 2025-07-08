import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:flutter/material.dart';
import 'package:cashsyncapp/commons/physics/custom_page_scroll_physics.dart';

class StrategyList extends StatelessWidget {
  const StrategyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ConfigConstant.padding3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConfigConstant.sizedBoxH2,
          Text(
            "Strategies",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Color(0xFF878787),
            ),
          ),
          ConfigConstant.sizedBoxH2,
          _buildStrategyList(),
        ],
      ),
    );
  }

  Widget _buildStrategyList() {
    // Define item width including margin
    final double itemWidth = 380 + ConfigConstant.padding3;
    return SizedBox(
      height: 100,
      child: ListView.builder(
        physics: CustomPageScrollPhysics(itemDimension: itemWidth),
        padding: EdgeInsets.zero,
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return _buildStrategyCard(context, index);
        },
      ),
    );
  }

  Widget _buildStrategyCard(BuildContext context, int index) {
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
            _buildTileIcon(index),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTileTitle(index),
                  SizedBox(height: 4),
                  Text(
                    "Short description for strategy ${index + 1}",
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey[400]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            _buildTileTrailing(index),
          ],
        ),
      ),
    );
  }

  Widget _buildTileIcon(int index) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.blueGrey[100],
      child: Icon(Icons.trending_up, color: Colors.blueGrey[700], size: 30),
    );
  }

  Widget _buildTileTitle(int index) {
    return Text(
      "Strategy ${index + 1}",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.blueGrey[800],
      ),
    );
  }

  Widget _buildTileTrailing(int index) {
    return Icon(Icons.arrow_forward_ios, color: Colors.blueGrey[600], size: 20);
  }
}
