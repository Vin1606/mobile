class Schedule {
  int? id;
  int filmId;
  int studioId;
  String time;
  int price;
  String available;

  Schedule({
    this.id,
    required this.filmId,
    required this.studioId,
    required this.time,
    required this.price,
    required this.available,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'film_id': filmId,
      'studio_id': studioId,
      'time': time,
      'price': price,
      'available': available,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'],
      filmId: map['film_id'],
      studioId: map['studio_id'],
      time: map['time'],
      price: map['price'],
      available: map['available'],
    );
  }
}
