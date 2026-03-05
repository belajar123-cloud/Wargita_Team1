import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'dashboard_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⚡ Inisialisasi Supabase
  await Supabase.initialize(
    url:
        'https://tmscczuqhnfkskikgwnv.supabase.co', // ganti dengan project URL kamu
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRtc2NjenVxaG5ma3NraWtnd252Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU3ODg5ODAsImV4cCI6MjA4MTM2NDk4MH0.qB6RFU_MHiaFw5nh9YIw2Q9vx2Wv7CDIwNuGIpONR14', // ganti dengan anon public key kamu
  );

  runApp(const MyApp());
}

// 🚀 MyApp sudah diubah menjadi StatefulWidget supaya bisa cek session async
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loading = true;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  // 🔹 Fungsi untuk cek apakah user sudah login
  Future<void> _checkSession() async {
    final session = Supabase.instance.client.auth.currentSession;
    setState(() {
      _loggedIn = session != null;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      // Sementara menunggu cek session
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: _loggedIn ? '/dashboard' : '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => DashboardScreen(), //
      },
    );
  }
}
