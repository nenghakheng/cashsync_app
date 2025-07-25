class StockChecklistModel {
  String? id;
  String? note;
  bool? isChecked;

  // Relationship
  String? strategyId;
  String? stockId;

  StockChecklistModel({
    this.id,
    this.note,
    this.isChecked,
    this.strategyId,
    this.stockId,
  });

  factory StockChecklistModel.fromJson(Map<String, dynamic> json) {
    return StockChecklistModel(
      id: json['id'],
      note: json['note'],
      isChecked: json['isChecked'],
      strategyId: json['strategyId'],
      stockId: json['stockId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'note': note,
      'isChecked': isChecked,
      'strategyId': strategyId,
      'stockId': stockId,
    };
  }
}
