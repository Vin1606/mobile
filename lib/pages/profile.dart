import 'package:bioskopks/models/session.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../pages/splash.dart';
import '../services/user.dart';
import '../widgets/main_navigation_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User? _user;
  String? _name;
  String? _email;
  String? _password;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final Session session = await UserService().getSession();
    final user = await UserService().getUserById(session.userId);

    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  void _onLogout() {
    UserService().logout();

    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(builder: (context) => const SplashPage()),
    );
  }

  Future<void> _onUpdate(BuildContext context) async {
    try {
      final isUpdated = await UserService().updateUser(User(
        id: _user!.id,
        name: _name!.isNotEmpty ? _name! : _user!.name,
        email: _email!.isNotEmpty ? _email! : _user!.email,
        password: _password!.isNotEmpty ? _password! : _user!.password,
        isAdmin: _user!.isAdmin,
        createdAt: _user!.createdAt,
        updatedAt: DateTime.now().toString(),
      ));

      if (isUpdated > 0) {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const MainNavigationBar(index: 2),
            ),
            (route) => false,
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Terjadi kesalahan saat memperbarui profil'),
              margin: EdgeInsets.all(16.0),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Terjadi masalah: $e'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.asset(
                          'assets/img/default-photo.png',
                          width: 150.0,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        initialValue: _user!.name,
                        decoration: const InputDecoration(
                          labelText: 'Nama',
                          hintText: 'Masukkan nama',
                        ),
                        keyboardType: TextInputType.name,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon masukkan nama';
                          }
                          return null;
                        },
                        onSaved: (value) => setState(() {
                          _name = value;
                        }),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        initialValue: _user!.email,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Masukkan email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon masukkan email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Mohon masukkan email yang valid';
                          }
                          return null;
                        },
                        onSaved: (value) => setState(() {
                          _email = value;
                        }),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Kata Sandi',
                          hintText: 'Masukkan kata sandi',
                        ),
                        obscureText: true,
                        onSaved: (value) => setState(() {
                          _password = value;
                        }),
                      ),
                      const SizedBox(height: 32.0),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _onUpdate(context);
                            }
                          },
                          child: const Text('Perbarui Profil'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _onLogout,
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Keluar'),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
