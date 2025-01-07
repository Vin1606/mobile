import 'package:flutter/material.dart';
import '../models/order_history.dart';
import '../utils/format_date.dart';
import '../services/order_seat.dart';
import '../models/order_seat.dart';

class TicketPage extends StatefulWidget {
  final OrderHistory orderHistory;

  const TicketPage({super.key, required this.orderHistory});

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  late Future<List<OrderSeat>> _orderSeats;

  @override
  void initState() {
    super.initState();
    _orderSeats =
        OrderSeatService().getOrderSeatsByOrderId(widget.orderHistory.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiket Nonton'),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 400,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(color: Colors.blueAccent, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 30.0,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Tiket Nonton',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black54,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTicketDetail('Film :', widget.orderHistory.filmTitle),
                  _buildTicketDetail('Nama :', widget.orderHistory.userName),
                  _buildTicketDetail(
                      'Tanggal :',
                      formatDate(widget.orderHistory.scheduleTime,
                          showTime: false)),
                  _buildTicketDetail(
                      'Waktu :',
                      formatDate(widget.orderHistory.scheduleTime,
                          onlyTime: true)),
                  const SizedBox(height: 10.0),
                  FutureBuilder<List<OrderSeat>>(
                    future: _orderSeats,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('Tidak ada kursi yang dipesan.');
                      }

                      final orderSeats = snapshot.data!;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: orderSeats.map((seat) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              'Kursi: ${seat.seat}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () => _printTicket(context),
                    child: const Text('Cetak Tiket'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  void _printTicket(BuildContext context) {
    print('Tiket dicetak: ${widget.orderHistory.filmTitle}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Tiket untuk ${widget.orderHistory.filmTitle} telah dicetak'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
