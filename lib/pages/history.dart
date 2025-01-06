import 'package:flutter/material.dart';
import '../models/order_history.dart';
import '../models/session.dart';
import '../services/order.dart';
import '../services/user.dart';
import '../widgets/history_card.dart';

class HistoryPage extends StatefulWidget {
  final bool? allUsers;

  const HistoryPage({super.key, this.allUsers});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<OrderHistory> _orderHistories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrderHistories();
  }

  Future<void> _loadOrderHistories() async {
    final Session session = await UserService().getSession();
    final orderHistories = await OrderService()
        .getOrderHistories(widget.allUsers == true ? null : session.userId);

    setState(() {
      _orderHistories = orderHistories;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.allUsers == true ? 'Daftar Pesanan' : 'Riwayat Pesanan'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _orderHistories.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tidak ada riwayat pemesanan',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _orderHistories.length,
                  itemBuilder: (context, index) {
                    return HistoryCard(orderHistory: _orderHistories[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12.0);
                  },
                ),
    );
  }
}
