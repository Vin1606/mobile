import 'package:bioskopks/utils/format_date.dart';
import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../models/film.dart';
import '../models/studio.dart';
import '../services/schedule.dart';
import '../services/film.dart';
import '../services/studio.dart';
import '../widgets/main_navigation_bar.dart';

class SaveSchedulePage extends StatefulWidget {
  final int? filmId;
  final Schedule? schedule;

  const SaveSchedulePage({super.key, this.filmId, this.schedule});

  @override
  State<SaveSchedulePage> createState() => _SaveSchedulePageState();
}

class _SaveSchedulePageState extends State<SaveSchedulePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _filmId;
  int? _studioId;
  String? _time = DateTime.now().toString();
  int? _price;
  String? _available = 'Tersedia';
  List<Film> _films = [];
  List<Studio> _studios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.filmId != null) {
      setState(() {
        _filmId = widget.filmId;
      });
    }
    if (widget.schedule != null) {
      setState(() {
        _filmId = widget.schedule!.filmId;
        _studioId = widget.schedule!.studioId;
        _time = widget.schedule!.time;
        _price = widget.schedule!.price;
        _available = widget.schedule!.available;
      });
    }
    _loadFilms();
    _loadStudios();
    setState(() {
      _isLoading = false;
    });
    print(_filmId);
  }

  Future<void> _loadFilms() async {
    final films = await FilmService().getFilms();

    setState(() {
      _films = films;
    });
  }

  Future<void> _loadStudios() async {
    final studios = await StudioService().getStudios();

    setState(() {
      _studios = studios;
    });
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(_time!),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      if (context.mounted) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(DateTime.parse(_time!)),
        );

        if (pickedTime != null) {
          setState(() {
            _time = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            ).toString();
          });
        }
      }
    }
  }

  Future<void> _onSubmit(BuildContext context) async {
    int? scheduleId;
    Schedule schedule = Schedule(
      id: widget.schedule?.id,
      filmId: _filmId!,
      studioId: _studioId!,
      time: _time!,
      price: _price!,
      available: _available!,
    );

    if (widget.schedule != null) {
      scheduleId = await ScheduleService().updateSchedule(schedule);
    } else {
      scheduleId = await ScheduleService().createSchedule(schedule);
    }

    if (scheduleId > 0) {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const MainNavigationBar(),
          ),
          (route) => false,
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan'),
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
        title: const Text('Tambah Jadwal Tayang'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Film'),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
                          value: widget.filmId != null && _films.isNotEmpty
                              ? widget.filmId.toString()
                              : null,
                          hint: const Text('Pilih film'),
                          items: _films.map((film) {
                            return DropdownMenuItem<String>(
                              value: film.id.toString(),
                              child: Text(film.title),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _filmId = int.parse(newValue!);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Studio'),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
                          value: _studioId != null && _studios.isNotEmpty
                              ? _studioId.toString()
                              : null,
                          hint: const Text('Pilih studio'),
                          items: _studios.map((studio) {
                            return DropdownMenuItem<String>(
                              value: studio.id.toString(),
                              child:
                                  Text('${studio.name}: ${studio.seat} kursi'),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _studioId = int.parse(newValue!);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Waktu'),
                    Text(formatDate(_time!)),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue: _price != null ? _price.toString() : '',
                      decoration: const InputDecoration(
                        labelText: 'Harga',
                        hintText: 'Masukkan harga',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan harga';
                        }
                        return null;
                      },
                      onSaved: (value) => _price = int.parse(value!),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Status'),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
                          value: _available,
                          hint: const Text('Pilih status'),
                          items: const [
                            DropdownMenuItem<String>(
                              value: 'Tersedia',
                              child: Text('Tersedia'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Penuh',
                              child: Text('Penuh'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Selesai',
                              child: Text('Selesai'),
                            ),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              _available = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32.0),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          _selectDateTime(context);
                        },
                        child: const Text('Atur Waktu Tayang'),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _onSubmit(context);
                          }
                        },
                        child: const Text('Simpan'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
