import 'package:flutter/material.dart';
import '../models/session.dart';
import '../services/user.dart';
import '../widgets/main_navigation_bar.dart';
import 'login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay(context);
  }

  Future<void> _navigateAfterDelay(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    final Session session = await UserService().getSession();
    final isLoggedIn = session.isLoggedIn;

    if (context.mounted) {
      Navigator.pushAndRemoveUntil<void>(
        context,
        MaterialPageRoute<void>(
          builder: (context) =>
              isLoggedIn ? const MainNavigationBar() : const LoginPage(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logobks.png',
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}
