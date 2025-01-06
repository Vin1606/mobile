class Order {
  int? id;
  int userId;
  int filmId;
  int scheduleId;
  int ticket;
  int totalPrice;
  String method;
  String? note;
  String? paymentProof;
  String status;
  int? confirmedBy;
  String? createdAt;
  String? updatedAt;

  Order({
    this.id,
    required this.userId,
    required this.filmId,
    required this.scheduleId,
    required this.ticket,
    required this.totalPrice,
    required this.method,
    this.note,
    this.paymentProof,
    required this.status,
    this.confirmedBy,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'film_id': filmId,
      'schedule_id': scheduleId,
      'ticket': ticket,
      'total_price': totalPrice,
      'method': method,
      'note': note,
      'payment_proof': paymentProof,
      'status': status,
      'confirmed_by': confirmedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      userId: map['user_id'],
      filmId: map['film_id'],
      scheduleId: map['schedule_id'],
      ticket: map['ticket'],
      totalPrice: map['total_price'],
      method: map['method'],
      note: map['note'],
      paymentProof: map['payment_proof'],
      status: map['status'],
      confirmedBy: map['confirmed_by'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}
