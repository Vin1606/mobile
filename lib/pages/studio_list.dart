import 'package:flutter/material.dart';
import '../models/studio.dart';
import '../services/studio.dart';
import '../widgets/studio_card.dart';

class StudioListPage extends StatefulWidget {
  const StudioListPage({super.key});

  @override
  State<StudioListPage> createState() => _StudioListPageState();
}

class _StudioListPageState extends State<StudioListPage> {
  List<Studio> _studios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudios();
  }

  Future<void> _loadStudios() async {
    final studios = await StudioService().getStudios();

    setState(() {
      _studios = studios;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Studio'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _studios.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.movie,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Film belum tersedia',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _studios.length,
                  itemBuilder: (context, index) {
                    return StudioCard(studio: _studios[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12.0);
                  },
                ),
    );
  }
}
