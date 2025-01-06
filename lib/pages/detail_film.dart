import 'package:flutter/material.dart';
import '../models/film.dart';
import '../models/session.dart';
import '../models/detail_schedule.dart';
import '../pages/save_film.dart';
import '../pages/save_schedule.dart';
import '../services/schedule.dart';
import '../services/user.dart';
import '../services/film.dart';
import '../widgets/detail_schedule_card.dart';
import '../widgets/main_navigation_bar.dart';

class DetailFilmPage extends StatefulWidget {
  final Film film;

  const DetailFilmPage({super.key, required this.film});

  @override
  State<DetailFilmPage> createState() => _DetailFilmPageState();
}

class _DetailFilmPageState extends State<DetailFilmPage> {
  List<DetailSchedule> _detailSchedules = [];
  bool _isAdmin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
    _isAdminCheck();
  }

  Future<void> _loadSchedules() async {
    final detailSchedules =
        await ScheduleService().getDetailSchedule(widget.film.id!);

    setState(() {
      _detailSchedules = detailSchedules;
      _isLoading = false;
    });
  }

  Future<void> _isAdminCheck() async {
    final Session session = await UserService().getSession();

    setState(() {
      _isAdmin = session.isAdmin;
    });
  }

  Future<void> _onDelete() async {
    await FilmService().deleteFilm(widget.film.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Film'),
        actions: _isAdmin
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SaveFilmPage(film: widget.film),
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
                              'Kamu ingin menghapus ${widget.film.title} dari daftar film?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                _onDelete();
                                Navigator.pushAndRemoveUntil<void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (context) =>
                                        const MainNavigationBar(),
                                  ),
                                  (route) => false,
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
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        widget.film.poster,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.broken_image,
                                size: 50, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  widget.film.rating,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                widget.film.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4.0),
              Text(
                '${widget.film.director} • ${widget.film.genre} • ${widget.film.duration} Menit',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Bahasa: ${widget.film.language}',
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Subtitle: ${widget.film.subtitle}',
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                widget.film.description,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Jadwal Tayang',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  _isAdmin
                      ? IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SaveSchedulePage(filmId: widget.film.id),
                              ),
                            );
                          },
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              const SizedBox(height: 10.0),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _detailSchedules.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_month,
                                size: 80,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Jadwal belum tersedia',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _detailSchedules.length,
                          itemBuilder: (context, index) {
                            return DetailScheduleCard(
                              detailSchedule: _detailSchedules[index],
                              isAdmin: _isAdmin,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 12.0);
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
