import 'package:flutter/material.dart';
import '../models/film.dart';
import '../services/film.dart';
import '../widgets/main_navigation_bar.dart';

class SaveFilmPage extends StatefulWidget {
  final Film? film;

  const SaveFilmPage({super.key, this.film});

  @override
  State<SaveFilmPage> createState() => _SaveFilmPageState();
}

class _SaveFilmPageState extends State<SaveFilmPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  String? _director;
  String? _rating;
  String? _language;
  String? _subtitle;
  String? _trailer;
  String? _poster;
  String? _genre;
  int? _duration;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.film != null) {
      setState(() {
        _title = widget.film!.title;
        _description = widget.film!.description;
        _director = widget.film!.director;
        _rating = widget.film!.rating;
        _language = widget.film!.language;
        _subtitle = widget.film!.subtitle;
        _trailer = widget.film!.trailer;
        _poster = widget.film!.poster;
        _genre = widget.film!.genre;
        _duration = widget.film!.duration;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _onSubmit(BuildContext context) async {
    int? filmId;
    Film film = Film(
      id: widget.film?.id,
      title: _title!,
      description: _description!,
      director: _director!,
      rating: _rating!,
      language: _language!,
      subtitle: _subtitle!,
      trailer: _trailer!,
      poster: _poster!,
      genre: _genre!,
      duration: _duration!,
    );

    if (widget.film != null) {
      filmId = await FilmService().updateFilm(film);
    } else {
      filmId = await FilmService().createFilm(film);
    }

    if (filmId > 0) {
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
        title: const Text('Tambah Film'),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      initialValue: _title,
                      decoration: const InputDecoration(
                        labelText: 'Judul',
                        hintText: 'Masukkan judul',
                      ),
                      keyboardType: TextInputType.text,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan judul';
                        }
                        return null;
                      },
                      onSaved: (value) => _title = value,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue: _description,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi',
                        hintText: 'Masukkan deskripsi',
                      ),
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan deskripsi';
                        }
                        return null;
                      },
                      onSaved: (value) => _description = value,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue: _director,
                      decoration: const InputDecoration(
                        labelText: 'Sutradara',
                        hintText: 'Masukkan sutradara',
                      ),
                      keyboardType: TextInputType.text,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan sutradara';
                        }
                        return null;
                      },
                      onSaved: (value) => _director = value,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue: _rating,
                      decoration: const InputDecoration(
                        labelText: 'Rating',
                        hintText: 'Masukkan rating',
                      ),
                      keyboardType: TextInputType.text,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan rating';
                        }
                        return null;
                      },
                      onSaved: (value) => _rating = value,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue: _language,
                      decoration: const InputDecoration(
                        labelText: 'Bahasa',
                        hintText: 'Masukkan bahasa',
                      ),
                      keyboardType: TextInputType.text,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan bahasa';
                        }
                        return null;
                      },
                      onSaved: (value) => _language = value,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue: _subtitle,
                      decoration: const InputDecoration(
                        labelText: 'Subtitle',
                        hintText: 'Masukkan subtitle',
                      ),
                      keyboardType: TextInputType.text,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan subtitle';
                        }
                        return null;
                      },
                      onSaved: (value) => _subtitle = value,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue: _trailer,
                      decoration: const InputDecoration(
                        labelText: 'Tautan Trailer',
                        hintText: 'Masukkan tautan trailer',
                      ),
                      keyboardType: TextInputType.url,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan tautan trailer';
                        }
                        return null;
                      },
                      onSaved: (value) => _trailer = value,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue: _poster,
                      decoration: const InputDecoration(
                        labelText: 'Tautan Poster',
                        hintText: 'Masukkan tautan poster',
                      ),
                      keyboardType: TextInputType.url,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan tautan poster';
                        }
                        return null;
                      },
                      onSaved: (value) => _poster = value,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue: _genre,
                      decoration: const InputDecoration(
                        labelText: 'Genre',
                        hintText: 'Masukkan genre',
                      ),
                      keyboardType: TextInputType.text,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan genre';
                        }
                        return null;
                      },
                      onSaved: (value) => _genre = value,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue:
                          _duration != null ? _duration.toString() : '',
                      decoration: const InputDecoration(
                        labelText: 'Durasi',
                        hintText: 'Masukkan durasi',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan durasi';
                        }
                        return null;
                      },
                      onSaved: (value) => _duration = int.tryParse(value!),
                    ),
                    const SizedBox(height: 32.0),
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
