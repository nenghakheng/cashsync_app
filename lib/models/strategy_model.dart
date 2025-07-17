class StrategyModel {
  String? id;
  String? name;
  String? description;
  String? type;
  double? entryPrice;
  double? exitPrice;
  double? profits;
  double? losses;
  double? get profitLoss =>
      (entryPrice != null && exitPrice != null)
          ? exitPrice! - entryPrice!
          : null;
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'entryPrice': entryPrice,
      'exitPrice': exitPrice,
      'profits': profits,
      'losses': losses,
      'isActive': isActive,
      'userId': userId,
    };
  }
}
