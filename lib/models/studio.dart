class Studio {
  int? id;
  String name;
  int seat;

  Studio({
    this.id,
    required this.name,
    required this.seat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'seat': seat,
    };
  }

  factory Studio.fromMap(Map<String, dynamic> map) {
    return Studio(
      id: map['id'],
      name: map['name'],
      seat: map['seat'],
    );
  }
}
