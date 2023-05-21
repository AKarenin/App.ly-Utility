

class Food {
  String name;
  bool isAvailable;
  int cost;

  Food(this.name, this.isAvailable, this.cost);

  factory Food.fromJson(Map<String, dynamic>? data) {
    final food = Food(
        data?['name'],
        data?['isAvailable'],
        data?['cost'],
    );

    return food;

  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "isAvailable": isAvailable,
      "cost": cost,
    };
  }
}