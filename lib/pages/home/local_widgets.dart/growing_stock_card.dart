import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:flutter/material.dart';
import 'package:cashsyncapp/models/stock/growing_stock_model.dart';

class GrowingStockCard extends StatelessWidget {
  final GrowingStockModel stock;
  const GrowingStockCard({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blueGrey.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Symbol and Name
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blueGrey.shade50,
                child: Text(
                  stock.symbol?[0] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5163BF),
                    fontSize: ConfigConstant.textSizeDisplay,
                  ),
                ),
              ),
              ConfigConstant.sizedBoxW2,
              Expanded(
                child: Text(
                  stock.name ?? '',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Current Price
          Text(
            "\$${stock.currentPrice?.toStringAsFixed(2) ?? '--'}",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.blueGrey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Growths
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _GrowthColumn(label: "1M", value: stock.monthGrowth),
              _GrowthColumn(label: "1Y", value: stock.yearGrowth),
            ],
          ),
          const SizedBox(height: 12),
          // Market Cap
          Text(
            "Market Cap: \$${_formatMarketCap(stock.marketCap)}",
            style: TextStyle(
              fontSize: ConfigConstant.textSizeCaption,
              color: Colors.blueGrey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatMarketCap(double? cap) {
    if (cap == null) return '--';
    if (cap >= 1e12) return "${(cap / 1e12).toStringAsFixed(2)}T";
    if (cap >= 1e9) return "${(cap / 1e9).toStringAsFixed(2)}B";
    if (cap >= 1e6) return "${(cap / 1e6).toStringAsFixed(2)}M";
    return cap.toStringAsFixed(0);
  }
}

class _GrowthColumn extends StatelessWidget {
  final String label;
  final double? value;
  const _GrowthColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final color =
        (value ?? 0) > 0
            ? Colors.green
            : ((value ?? 0) < 0 ? Colors.red : Colors.grey);
    final prefix = (value ?? 0) > 0 ? '+' : '';
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.blueGrey[400]),
        ),
        Text(
          "$prefix${value?.toStringAsFixed(2) ?? '--'}%",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
