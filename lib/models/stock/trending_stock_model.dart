class TrendingStockModel {
  final String? symbol;
  final String? name;
  final double? price;
  final double? changePercent;
  final double? volume;
  final String? trend;

  TrendingStockModel({
    required this.symbol,
    required this.name,
    required this.price,
    required this.changePercent,
    required this.volume,
    required this.trend,
  });

  factory TrendingStockModel.fromJson(Map<String, dynamic> json) {
    return TrendingStockModel(
      symbol: json['symbol'],
      name: json['name'],
      price: json['price']?.toDouble(),
      changePercent: json['changePercent']?.toDouble(),
      volume: json['volume']?.toDouble(),
      trend: json['trend'],
    );
  }
}
