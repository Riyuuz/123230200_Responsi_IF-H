import 'package:flutter/material.dart';
import '../services/prefs_service.dart';
import '../theme.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMsg;

  // Simple hardcoded credentials for demo
  static const _validUsers = {
    'admin': 'admin123',
    'user': 'user123',
    'emilys': 'emilyspass',
  };

  Future<void> _login() async {
    final username = _usernameCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() => _errorMsg = 'Username dan password wajib diisi!');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    final validPass = _validUsers[username];
    if (validPass != null && validPass == password) {
      await PrefsService.saveUsername(username);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
      }
    } else {
      setState(() {
        _errorMsg = 'Username atau password salah!';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Logo
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  size: 52,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to Shop Goat',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Masuk untuk melanjutkan belanja',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),

              // Card form
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Username field
                    TextFormField(
                      controller: _usernameCtrl,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        prefixIcon: const Icon(Icons.person_outline,
                            color: AppColors.primary),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: AppColors.primary),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onFieldSubmitted: (_) => _login(),
                    ),

                    if (_errorMsg != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMsg!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  text: 'Hint: gunakan ',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                  children: const [
                    TextSpan(
                      text: 'admin / admin123',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
