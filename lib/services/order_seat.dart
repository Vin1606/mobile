import '../models/order_seat.dart';
import 'db.dart';

class OrderSeatService {
  final DatabaseService _dbService = DatabaseService();

  Future<int> createOrderSeat(OrderSeat orderSeat) async {
    final db = await _dbService.database;
    return await db.insert('order_seats', orderSeat.toMap());
  }

  Future<List<OrderSeat>> getOrderSeats(int? userId) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db
        .query('order_seats', where: 'user_id = ?', whereArgs: [userId]);
    return maps.map((map) => OrderSeat.fromMap(map)).toList();
  }

  Future<OrderSeat?> getOrderSeatById(int id) async {
    final db = await _dbService.database;
    final maps =
        await db.query('order_seats', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return OrderSeat.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateOrderSeat(OrderSeat orderSeat) async {
    final db = await _dbService.database;
    return await db.update(
      'order_seats',
      orderSeat.toMap(),
      where: 'id = ?',
      whereArgs: [orderSeat.id],
    );
  }

  Future<int> deleteOrderSeat(int id) async {
    final db = await _dbService.database;
    return await db.delete('order_seats', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<String>> getUnavailableSeats(int filmId, int scheduleId) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT seat FROM order_seats
      INNER JOIN orders ON orders.id = order_seats.order_id
      WHERE orders.film_id = ? AND orders.schedule_id = ?
    ''', [filmId, scheduleId]);

    return maps.map((map) => map['seat'] as String).toList();
  }

  Future<void> createBatchOrderSeats(int orderId, List<String> seats) async {
    final db = await _dbService.database;

    await db.transaction((txn) async {
      for (String seat in seats) {
        final orderSeat = OrderSeat(
          orderId: orderId,
          seat: seat,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
        );

        await txn.insert('order_seats', orderSeat.toMap());
      }
    });
  }

  Future<List<OrderSeat>> getOrderSeatsByOrderId(int orderId) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db
        .query('order_seats', where: 'order_id = ?', whereArgs: [orderId]);

    // Tambahkan log untuk melihat hasil query
    print(
        'Order ID: $orderId, Seats: ${maps.length}'); // Log jumlah kursi yang diambil

    return maps.map((map) => OrderSeat.fromMap(map)).toList();
  }
}
