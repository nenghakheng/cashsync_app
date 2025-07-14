class StockDataModel {
  String? symbol;
  String? name;
  double? currentPrice;
  double? change;
  double? changePercent;
  double? volume;
  double? marketCap;
  double? previousClose;
  double? dayHigh;
  double? dayLow;

  StockDataModel({
    this.symbol,
    this.name,
    this.currentPrice,
    this.change,
    this.changePercent,
    this.volume,
    this.marketCap,
    this.previousClose,
    this.dayHigh,
    this.dayLow,
  });

  factory StockDataModel.fromJson(Map<String, dynamic> json) {
    return StockDataModel(
      symbol: json['symbol'],
      name: json['name'],
      currentPrice: json['currentPrice']?.toDouble(),
      change: json['change']?.toDouble(),
      changePercent: json['changePercent']?.toDouble(),
      volume: json['volume']?.toDouble(),
      marketCap: json['marketCap']?.toDouble(),
      previousClose: json['previousClose']?.toDouble(),
      dayHigh: json['dayHigh']?.toDouble(),
      dayLow: json['dayLow']?.toDouble(),
    );
  }
}
