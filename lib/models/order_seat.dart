class OrderSeat {
  int? id;
  int orderId;
  String seat;
  String? createdAt;
  String? updatedAt;
  List<String> history = [];

  OrderSeat({
    this.id,
    required this.orderId,
    required this.seat,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'seat': seat,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory OrderSeat.fromMap(Map<String, dynamic> map) {
    return OrderSeat(
      id: map['id'],
      orderId: map['order_id'],
      seat: map['seat'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  String displaySeatInfo() {
    return 'Order ID: $orderId, Seat: $seat';
  }

  void addToHistory() {
    history.add(displaySeatInfo());
  }

  List<String> getHistory() {
    return history;
  }
}
