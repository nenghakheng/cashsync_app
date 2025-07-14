class GrowingStockModel {
  String? symbol;
  String? name;
  double? currentPrice;
  double? weekGrowth;
  double? monthGrowth;
  double? yearGrowth;
  double? marketCap;

  GrowingStockModel({
    this.symbol,
    this.name,
    this.currentPrice,
    this.weekGrowth,
    this.monthGrowth,
    this.yearGrowth,
    this.marketCap,
  });

  factory GrowingStockModel.fromJson(Map<String, dynamic> json) {
    return GrowingStockModel(
      symbol: json['symbol'],
      name: json['name'],
      currentPrice: json['currentPrice']?.toDouble(),
      weekGrowth: json['weekGrowth']?.toDouble(),
      monthGrowth: json['monthGrowth']?.toDouble(),
      yearGrowth: json['yearGrowth']?.toDouble(),
      marketCap: json['marketCap']?.toDouble(),
    );
  }
}
