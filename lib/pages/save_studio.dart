import 'package:flutter/material.dart';
import '../models/studio.dart';
import '../services/studio.dart';
import '../widgets/main_navigation_bar.dart';

class SaveStudioPage extends StatefulWidget {
  final Studio? studio;

  const SaveStudioPage({super.key, this.studio});

  @override
  State<SaveStudioPage> createState() => _SaveStudioPageState();
}

class _SaveStudioPageState extends State<SaveStudioPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _name;
  int? _seat;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.studio != null) {
      setState(() {
        _name = widget.studio!.name;
        _seat = widget.studio!.seat;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _onSubmit(BuildContext context) async {
    int? studioId;
    Studio studio = Studio(
      id: widget.studio?.id,
      name: _name!,
      seat: _seat!,
    );

    if (widget.studio != null) {
      studioId = await StudioService().updateStudio(studio);
    } else {
      studioId = await StudioService().createStudio(studio);
    }

    if (studioId > 0) {
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
        title: const Text('Tambah Studio'),
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
                      initialValue: _name,
                      decoration: const InputDecoration(
                        labelText: 'Nama',
                        hintText: 'Masukkan nama',
                      ),
                      keyboardType: TextInputType.text,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan nama';
                        }
                        return null;
                      },
                      onSaved: (value) => _name = value,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue: _seat != null ? _seat.toString() : '',
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Kursi',
                        hintText: 'Masukkan jumlah kursi',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon masukkan jumlah kursi';
                        }
                        return null;
                      },
                      onSaved: (value) => _seat = int.parse(value!),
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
