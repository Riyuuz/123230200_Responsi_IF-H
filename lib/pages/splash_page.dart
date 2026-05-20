import 'package:flutter/material.dart';
import '../services/prefs_service.dart';
import '../theme.dart';
import 'login_page.dart';
import 'main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _scaleAnim =
        Tween<double>(begin: 0.7, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    _controller.forward();

    Future.delayed(const Duration(seconds: 2), _navigate);
  }

  Future<void> _navigate() async {
    final username = await PrefsService.getUsername();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            username != null ? const MainPage() : const LoginPage(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Shop Goat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Belanja mudah, kapan saja',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 48),
                const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
