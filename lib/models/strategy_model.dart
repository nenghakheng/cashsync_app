class StrategyModel {
  String? id;
  String? name;
  String? description;
  String? type;
  double? entryPrice;
  double? exitPrice;
  double? profits;
  double? losses;
  bool? isActive;

  // Relationship
  int? userId;

  StrategyModel({
    this.id,
    this.name,
    this.description,
    this.type,
    this.entryPrice,
    this.exitPrice,
    this.profits,
    this.losses,
    this.isActive,
    this.userId,
  });

  factory StrategyModel.fromJson(Map<String, dynamic> json) {
    return StrategyModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      entryPrice: json['entryPrice']?.toDouble(),
      exitPrice: json['exitPrice']?.toDouble(),
      profits: json['profits']?.toDouble(),
      losses: json['losses']?.toDouble(),
      isActive: json['isActive'],
      userId: json['userId'],
    );
  }
}
