class DetailOrder {
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

  String bookerName;
  String filmTitle;
  String scheduleTime;
  String? adminName;

  DetailOrder({
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
    required this.bookerName,
    required this.filmTitle,
    required this.scheduleTime,
    this.adminName,
  });

  factory DetailOrder.fromMap(Map<String, dynamic> map) {
    return DetailOrder(
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
      bookerName: map['booker_name'],
      filmTitle: map['film_title'],
      scheduleTime: map['schedule_time'],
      adminName: map['admin_name'],
    );
  }
}
