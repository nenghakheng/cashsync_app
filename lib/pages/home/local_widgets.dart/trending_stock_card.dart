import 'dart:math';
import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/models/stock/trending_stock_model.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';

class TrendingStockCard extends StatelessWidget {
  const TrendingStockCard({super.key, required this.stock});

  final TrendingStockModel stock;

  @override
  Widget build(BuildContext context) {
    final isUp = stock.trend == "up";
    final isDown = stock.trend == "down";
    final color =
        isUp
            ? Colors.green
            : isDown
            ? Colors.red
            : Colors.blueGrey;

    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: color, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          fit: StackFit.loose,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildStockInfo(context),
                  ConfigConstant.sizedBoxH1,
                  _buildStockPrice(context, color),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Sparkline(
                  data: _generateSparklineData(stock),
                  lineWidth: 2.0,
                  lineColor: color,
                  pointsMode: PointsMode.last,
                  pointSize: 5.0,
                  pointColor: color,
                  fillMode: FillMode.below,
                  fillGradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withValues(alpha: 0.4),
                      color.withValues(alpha: 0.05),
                    ],
                  ),
                  gridLinesEnable: false,
                  useCubicSmoothing: true,
                  cubicSmoothingFactor: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Stock Icon
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFF5163BF),
          child: Icon(Icons.trending_up, color: Colors.white, size: 32),
        ),
        ConfigConstant.sizedBoxW2,
        // Stock Symbol
        Expanded(
          child: Text(
            stock.symbol ?? 'Unknown',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStockPrice(BuildContext context, Color color) {
    final isUp = stock.changePercent! > 0;
    final isDown = stock.changePercent! < 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Direction Icon
            Icon(
              isUp
                  ? Icons.arrow_upward
                  : isDown
                  ? Icons.arrow_downward
                  : Icons.trending_flat,
              color: color,
              size: ConfigConstant.iconSize3,
            ),
            ConfigConstant.sizedBoxH1,
            // Stock Price
            Text(
              "\$${stock.price?.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Change Percent
            Text(
              "${stock.changePercent! > 0 ? '+' : ''}${stock.changePercent?.toStringAsFixed(2)}%",
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Generate sparkline data based on price and trend
  List<double> _generateSparklineData(TrendingStockModel stock) {
    final rng = Random(stock.symbol.hashCode);
    final base = stock.price;
    final trend = stock.trend;
    final List<double> data = [];
    double value = base! * (0.95 + rng.nextDouble() * 0.1); // start near price

    for (int i = 0; i < 15; i++) {
      // Simulate trend
      if (trend == "up") {
        value += rng.nextDouble() * 0.5;
      } else if (trend == "down") {
        value -= rng.nextDouble() * 0.5;
      } else {
        value += (rng.nextDouble() - 0.5) * 0.3;
      }
      data.add(value);
    }
    // End at actual price
    data[data.length - 1] = base;
    return data;
  }
}
