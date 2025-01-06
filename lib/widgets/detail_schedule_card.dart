import 'package:flutter/material.dart';
import '../models/detail_schedule.dart';
import '../models/schedule.dart';
import '../utils/format_price.dart';
import '../utils/format_date.dart';
import '../pages/order.dart';
import '../pages/save_schedule.dart';
import '../services/schedule.dart';
import '../widgets/main_navigation_bar.dart';

class DetailScheduleCard extends StatelessWidget {
  final DetailSchedule detailSchedule;
  final bool isAdmin;

  const DetailScheduleCard({
    super.key,
    required this.detailSchedule,
    this.isAdmin = false,
  });

  Future<void> _onDelete(BuildContext context) async {
    await ScheduleService().deleteSchedule(detailSchedule.scheduleId);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                detailSchedule.available,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              detailSchedule.studioName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formatDate(detailSchedule.time),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formatPrice(detailSchedule.price),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: detailSchedule.available == 'Tersedia'
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderPage(detailSchedule: detailSchedule),
                          ),
                        );
                      }
                    : null,
                child: const Text('Pesan Tiket'),
              ),
            ),
            isAdmin
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SaveSchedulePage(
                                filmId: detailSchedule.filmId,
                                schedule: Schedule(
                                  id: detailSchedule.scheduleId,
                                  filmId: detailSchedule.filmId,
                                  studioId: detailSchedule.studioId,
                                  time: detailSchedule.time,
                                  price: detailSchedule.price,
                                  available: detailSchedule.available,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Hapus'),
                                content: Text(
                                    'Kamu ingin menghapus ${detailSchedule.filmTitle} - ${formatDate(detailSchedule.time)} dari daftar jadwal tayang?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _onDelete(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MainNavigationBar(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Hapus',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
