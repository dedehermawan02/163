class Inventory {
  final String id;
  final String name;
  final int quantity;

  Inventory({required this.id, required this.name, required this.quantity});

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['_id'],
      name: json['name'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'quantity': quantity,
    };
  }
}
