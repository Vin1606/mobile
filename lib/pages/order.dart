import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/detail_schedule.dart';
import '../models/session.dart';
import '../services/order.dart';
import '../services/order_seat.dart';
import '../services/user.dart';
import '../utils/format_date.dart';
import '../utils/format_price.dart';
import '../widgets/main_navigation_bar.dart';

class OrderPage extends StatefulWidget {
  final DetailSchedule detailSchedule;

  const OrderPage({super.key, required this.detailSchedule});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<String> _unavailableSeats = [];
  List<String> _selectedSeats = [];
  String? _selectedMethod;
  int _ticketCount = 0;
  int _totalPrice = 0;
  Session? _session;

  @override
  void initState() {
    super.initState();
    _loadUnavailableSeats();
    _loadSession();
  }

  Future<void> _loadUnavailableSeats() async {
    final unavailableSeats = await OrderSeatService().getUnavailableSeats(
        widget.detailSchedule.filmId, widget.detailSchedule.scheduleId);

    setState(() {
      _unavailableSeats = unavailableSeats;
    });
  }

  Future<void> _loadSession() async {
    _session = await UserService().getSession();
  }

  Future<void> _onSubmit(BuildContext context) async {
    final Session session = await UserService().getSession();
    final orderId = await OrderService().createOrder(Order(
      userId: session.userId,
      filmId: widget.detailSchedule.filmId,
      scheduleId: widget.detailSchedule.scheduleId,
      ticket: _ticketCount,
      totalPrice: _totalPrice,
      method: _selectedMethod!,
      status: 'Menunggu Konfirmasi',
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
    ));

    if (orderId > 0) {
      OrderSeatService().createBatchOrderSeats(orderId, _selectedSeats);

      if (context.mounted) {
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const MainNavigationBar(index: 1),
          ),
          (route) => false,
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan saat membuat pesanan'),
            margin: EdgeInsets.all(16.0),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan Ticket'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nama Film',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.detailSchedule.filmTitle,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nama Studio',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.detailSchedule.studioName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Waktu Tayang',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formatDate(widget.detailSchedule.time),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Harga Per Ticket',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formatPrice(widget.detailSchedule.price),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: _selectedMethod,
                    hint: const Text('Pilih metode pembayaran'),
                    items: [
                      if (_session?.isAdmin == true)
                        const DropdownMenuItem<String>(
                          value: 'Cash',
                          child: Text('Cash'),
                        ),
                      const DropdownMenuItem<String>(
                        value: 'Transfer Bank',
                        child: Text('Transfer Bank'),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMethod = newValue;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jumlah Ticket',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Jumlah ticket yang akan dipesan',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _ticketCount = int.tryParse(value) ?? 0;
                        _totalPrice =
                            _ticketCount * widget.detailSchedule.price;
                        _selectedSeats = [];
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Harga',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formatPrice(_totalPrice),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  widget.detailSchedule.studioSeat,
                  (index) {
                    String seatLabel =
                        '${String.fromCharCode(65 + (index ~/ 8))}${(index % 8) + 1}';
                    bool isReserved = _unavailableSeats.contains(seatLabel);
                    bool isAvailable =
                        !isReserved && index < widget.detailSchedule.studioSeat;

                    return GestureDetector(
                      onTap: isAvailable
                          ? () {
                              setState(() {
                                if (_selectedSeats.contains(seatLabel)) {
                                  _selectedSeats.remove(seatLabel);
                                } else if (_selectedSeats.length <
                                    _ticketCount) {
                                  _selectedSeats.add(seatLabel);
                                }
                              });
                            }
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isReserved
                              ? Colors.grey
                              : _selectedSeats.contains(seatLabel)
                                  ? Colors.green
                                  : isAvailable
                                      ? Colors.blue
                                      : Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          seatLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _selectedSeats.isEmpty
                      ? null
                      : () {
                          _onSubmit(context);
                        },
                  child: const Text('Pesan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
