import 'dart:ui';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _agree = false;
  double _passwordStrength = 0;

  void _checkPassword(String value) {
    double strength = 0;
    if (value.length >= 6) strength += 0.3;
    if (value.contains(RegExp(r'[A-Z]'))) strength += 0.2;
    if (value.contains(RegExp(r'[0-9]'))) strength += 0.2;
    if (value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) strength += 0.3;

    setState(() {
      _passwordStrength = strength.clamp(0, 1);
    });
  }

  String get strengthText {
    if (_passwordStrength < 0.4) return "Lemah";
    if (_passwordStrength < 0.7) return "Sedang";
    return "Kuat";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// ===== BACKGROUND GRADIENT =====
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  const Text(
                    "Register Wargita",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ===== LOGO =====
                  Image.asset(
                    'assets/images/gambar.logo.jpeg',
                    height: 90,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Buat Akun Baru",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Buat akun untuk akses layanan warga dengan cepat dan aman.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 25),

                  /// ===== GLASS CARD =====
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _inputField(
                                controller: _name,
                                hint: "Full Name",
                                icon: Icons.person,
                                validator: (value) =>
                                    value!.isEmpty ? "Nama wajib diisi" : null,
                              ),
                              const SizedBox(height: 15),

                              _inputField(
                                controller: _email,
                                hint: "Email",
                                icon: Icons.email,
                                validator: (value) => value!.contains("@")
                                    ? null
                                    : "Email tidak valid",
                              ),
                              const SizedBox(height: 15),

                              _inputField(
                                controller: _phone,
                                hint: "Phone Number",
                                icon: Icons.phone,
                                validator: (value) =>
                                    value!.isEmpty ? "No HP wajib diisi" : null,
                              ),
                              const SizedBox(height: 15),

                              DropdownButtonFormField<String>(
                                dropdownColor: Colors.blue,
                                decoration: _inputDecoration(
                                  "Gender (optional)",
                                  Icons.people,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: "MALE",
                                    child: Text("Male"),
                                  ),
                                  DropdownMenuItem(
                                    value: "FEMALE",
                                    child: Text("Female"),
                                  ),
                                ],
                                onChanged: (val) {},
                              ),
                              const SizedBox(height: 15),

                              _inputField(
                                controller: _password,
                                hint: "Password",
                                icon: Icons.lock,
                                obscure: _obscurePass,
                                onChanged: _checkPassword,
                                validator: (value) => value!.length < 6
                                    ? "Password minimal 6 karakter"
                                    : null,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscurePass
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePass = !_obscurePass;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 6),

                              LinearProgressIndicator(
                                value: _passwordStrength,
                                backgroundColor: Colors.white24,
                                color: _passwordStrength < 0.4
                                    ? Colors.red
                                    : _passwordStrength < 0.7
                                    ? Colors.orange
                                    : Colors.green,
                              ),

                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  strengthText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),

                              _inputField(
                                controller: _confirmPassword,
                                hint: "Confirm Password",
                                icon: Icons.lock_reset,
                                obscure: _obscureConfirm,
                                validator: (value) => value != _password.text
                                    ? "Password tidak sama"
                                    : null,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscureConfirm
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirm = !_obscureConfirm;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 15),

                              Row(
                                children: [
                                  Checkbox(
                                    value: _agree,
                                    onChanged: (val) {
                                      setState(() => _agree = val ?? false);
                                    },
                                  ),
                                  const Expanded(
                                    child: Text(
                                      "Saya setuju dengan kebijakan layanan Wargita.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (!_agree) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Setujui kebijakan terlebih dahulu',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Registrasi Berhasil 🎉",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    "Create Account",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),

                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Sudah punya akun? Sign In",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(hint, icon).copyWith(suffixIcon: suffix),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.1),
      prefixIcon: Icon(icon, color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }
}
