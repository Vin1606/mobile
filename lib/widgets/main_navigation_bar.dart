import 'package:flutter/material.dart';
import '../models/session.dart';
import '../services/user.dart';
import '../pages/home.dart';
import '../pages/history.dart';
import '../pages/profile.dart';
import '../pages/save_film.dart';
import '../pages/save_studio.dart';
import '../pages/studio_list.dart';
import 'dart:async';

class MainNavigationBar extends StatefulWidget {
  final int? index;

  const MainNavigationBar({super.key, this.index});

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  int _currentIndex = 0;
  bool _isAdmin = false;
  Color _selectedColor = Colors.blue;
  late Timer _timer;

  final List<Widget> _pages = [
    const HomePage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      setState(() {
        _currentIndex = widget.index!;
      });
    }
    _isAdminCheck();
    _startColorBlinking();
  }

  void _startColorBlinking() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _selectedColor =
            _selectedColor == Colors.blue ? Colors.red : Colors.blue;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _isAdminCheck() async {
    final Session session = await UserService().getSession();

    setState(() {
      _isAdmin = session.isAdmin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      appBar: _isAdmin
          ? AppBar(
              toolbarHeight: 120,
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              title: Row(
                children: [
                  Image.asset(
                    'assets/img/logobks.png', // Ganti dengan path logo Anda
                    height: 70, // Sesuaikan tinggi logo
                  ),
                  const SizedBox(width: 8), // Jarak antara logo dan teks
                ],
              ),
              backgroundColor: const Color.fromARGB(255, 3, 3, 3),
            )
          : null,
      drawer: _isAdmin
          ? Drawer(
              backgroundColor: Colors.black,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    height: 100.0, // Ubah tinggi sesuai kebutuhan
                    child: const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 1, 49, 132),
                      ),
                      child: Center(
                        child: Text(
                          'Menu Admin',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(50.0),
                    child: Image(
                      image: AssetImage('assets/img/logobks.png'),
                      width: 100,
                      height: 100,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.add, color: Colors.white),
                    title: const Text('Tambah Film',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SaveFilmPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.add_box, color: Colors.white),
                    title: const Text('Tambah Studio',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SaveStudioPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.list, color: Colors.white),
                    title: const Text('Daftar Studio',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StudioListPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history, color: Colors.white),
                    title: const Text('Daftar Pesanan',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const HistoryPage(allUsers: true),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: _selectedColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
