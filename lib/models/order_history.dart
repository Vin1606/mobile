class OrderHistory {
  int id;
  String userName;
  int ticket;
  int totalPrice;
  String status;
  String filmTitle;
  String scheduleTime;

  OrderHistory({
    required this.id,
    required this.userName,
    required this.ticket,
    required this.totalPrice,
    required this.status,
    required this.filmTitle,
    required this.scheduleTime,
  });

  factory OrderHistory.fromMap(Map<String, dynamic> map) {
    return OrderHistory(
      id: map['order_id'],
      userName: map['user_name'],
      ticket: map['ticket'],
      totalPrice: map['total_price'],
      status: map['status'],
      filmTitle: map['film_title'],
      scheduleTime: map['schedule_time'],
    );
  }
}
