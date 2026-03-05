import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  SupabaseClient get supabase => Supabase.instance.client;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ====== LOGIN EMAIL & PASSWORD (SUPABASE) ======
  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      _showSnack('Email tidak valid');
      return;
    }
    if (password.isEmpty) {
      _showSnack('Password wajib diisi');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await supabase.auth.signInWithPassword(email: email, password: password);

      if (!mounted) return;
      _showSnack('Login berhasil!');
      Navigator.pushReplacementNamed(context, '/dashboard');
    } on AuthException catch (e) {
      if (!mounted) return;
      _showSnack(e.message);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Terjadi error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ====== FUNGSI SIGN IN DENGAN GOOGLE ======
  Future<void> _signInWithGoogle() async {
    if (kIsWeb) {
      // Web: gunakan OAuth redirect flow
      try {
        final redirectTo = '${Uri.base.origin}/#/dashboard';
        await supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: redirectTo,
        );
      } catch (e) {
        _showSnack('Google OAuth web gagal: $e');
      }
      return;
    }

    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signIn();
      final googleUser = await googleSignIn.signInSilently();
      if (!mounted) return;

      if (googleUser == null) {
        _showSnack('Google Sign-In dibatalkan.');
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken != null) {
        await supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
        );
        if (!mounted) return;
        _showSnack('Login Google berhasil sebagai ${googleUser.email}');
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        _showSnack('ID Token Google kosong.');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnack('Google Sign-In gagal: $e');
    }
  }

  void _onForgotPassword() {
    // masih placeholder seperti sebelumnya, biar tidak mengubah flow aplikasi kamu
    _showSnack('Fitur lupa password belum dibuat');
  }

  @override
  Widget build(BuildContext context) {
    const bgTop = Color(0xFF0E3A8A);
    const bgMid = Color(0xFF1D4ED8);
    const bgBottom = Color(0xFF0B2C6B);
    const primary = Color.fromARGB(255, 94, 106, 121);

    return Scaffold(
      body: Stack(
        children: [
          // ===== Background Gradient
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [bgTop, bgMid, bgBottom],
              ),
            ),
            child: SizedBox.expand(),
          ),

          // ===== Accent circles
          const Positioned(
            top: -80,
            left: -60,
            child: _GlowCircle(size: 240, color: Colors.white10),
          ),
          const Positioned(
            bottom: -120,
            right: -80,
            child: _GlowCircle(size: 280, color: Color(0x14FFFFFF)),
          ),
          const Positioned(
            top: 160,
            right: -40,
            child: _GlowCircle(size: 140, color: Color(0x12FFFFFF)),
          ),

          // ===== Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),

                      // Logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.asset(
                          'assets/images/gambar1.logo.jpeg',
                          height: 86,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 14),

                      const Text(
                        'Welcome to Wargita',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Layanan digitalisasi warga yang cepat, rapi, dan aman.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          height: 1.35,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Glass Card
                      _GlassCard(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _NiceTextField(
                                controller: _emailController,
                                label: 'Email',
                                hint: 'contoh@email.com',
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: Icons.mail_rounded,
                                validator: (v) {
                                  final s = (v ?? '').trim();
                                  if (s.isEmpty) {
                                    return 'Email wajib diisi';
                                  }
                                  if (!s.contains('@')) {
                                    return 'Format email tidak valid';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              _NiceTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: 'Masukkan password',
                                prefixIcon: Icons.lock_rounded,
                                obscureText: _obscurePassword,
                                validator: (v) {
                                  final s = v ?? '';
                                  if (s.isEmpty) {
                                    return 'Password wajib diisi';
                                  }
                                  if (s.length < 6) {
                                    return 'Minimal 6 karakter';
                                  }
                                  return null;
                                },
                                suffix: IconButton(
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                                onFieldSubmitted: (_) {
                                  // enter -> login
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    _handleLogin();
                                  }
                                },
                              ),

                              const SizedBox(height: 8),

                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _onForgotPassword,
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white.withValues(
                                      alpha: 0.92,
                                    ),
                                  ),
                                  child: const Text('Forgot password?'),
                                ),
                              ),

                              const SizedBox(height: 6),

                              // Primary button
                              _GradientButton(
                                text: 'Login',
                                isLoading: _isLoading,
                                onPressed: () {
                                  if (_isLoading) {
                                    return;
                                  }
                                  if (!(_formKey.currentState?.validate() ??
                                      false)) {
                                    return;
                                  }
                                  _handleLogin();
                                },
                                gradient: const LinearGradient(
                                  colors: [primary, Color(0xFF93C5FD)],
                                ),
                              ),

                              const SizedBox(height: 14),

                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.white.withValues(
                                        alpha: 0.25,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      'or sign in with',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.80,
                                        ),
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.white.withValues(
                                        alpha: 0.25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Google (secondary)
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: OutlinedButton.icon(
                                  onPressed: _isLoading
                                      ? null
                                      : _signInWithGoogle,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.30,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  icon: Image.asset(
                                    'assets/images/gambar2.logo.jpeg',
                                    height: 20,
                                  ),
                                  label: const Text(
                                    'Sign in with Google',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Belum punya akun? ",
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.85,
                                      ),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: _isLoading
                                        ? null
                                        : () => Navigator.pushNamed(
                                            context,
                                            '/register',
                                          ),
                                    child: const Text(
                                      'Daftar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        'Dengan masuk, kamu menyetujui kebijakan layanan Wargita.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.70),
                          fontSize: 11.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            boxShadow: [
              BoxShadow(
                blurRadius: 24,
                offset: const Offset(0, 14),
                color: Colors.black.withValues(alpha: 0.20),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _NiceTextField extends StatelessWidget {
  const _NiceTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.validator,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.80)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.10),
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.white.withValues(alpha: 0.85),
        ),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.20)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.20)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF93C5FD), width: 1.6),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.text,
    required this.onPressed,
    required this.gradient,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback onPressed;
  final LinearGradient gradient;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: Colors.black.withValues(alpha: 0.18),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: const Color(0xFF0B2C6B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.2,
                  ),
                ),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
