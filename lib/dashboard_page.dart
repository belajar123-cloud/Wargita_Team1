import 'package:flutter/material.dart';
import 'form_permohonan_pindah_domisili_screen.dart';
import 'form_pembuatan_ktp_screen.dart';
import 'form_pembuatan_kia_screen.dart';
import 'form_pembuatan_akta_kelahiran_screen.dart';
import 'form_pembuatan_akta_kematian_screen.dart';
import 'form_pembuatan_kartu_keluarga.dart';
import 'panic_button_screen.dart';
import 'notification_screen.dart';
import 'faq_screen.dart';
import 'profile_screen.dart';
import 'riwayat_kelurahan_section.dart';
import 'perubahan_biodata_screen.dart';
import 'form_jemput_bola_ktp_el_screen.dart';
import 'identitas_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final PageController _bannerController = PageController(
    viewportFraction: 0.9,
  );

  final List<String> _bannerImages = const [
    'assets/images/banner3.kelurahan.jpeg',
    'assets/images/banner2.kelurahan.jpeg',
    'assets/images/banner1.kelurahan.jpeg',
  ];

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = "Warga Wargita";

    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvoked: (didPop) {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHome(userEmail),

            /// ✅ FAQ diperbaiki supaya kembali ke Home
            FaqScreen(
              onBack: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            RiwayatKelurahanSection(
              onBack: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),

            const IdentitasScreen(),

            ProfileScreen(
              onBack: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  // ================= HOME PAGE =================
  Widget _buildHome(String userEmail) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(userEmail),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildServicesGrid(),
                  _buildSOSSection(),
                  const SizedBox(height: 24),
                  _buildBanner(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(String userEmail) {
    return SizedBox(
      height: 210,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0072FF), Color(0xFF00C6FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/logo.wargita.jpeg',
                      height: 56,
                      width: 56,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Selamat Datang di Wargita',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          userEmail,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
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

  // ================= GRID MENU =================
  Widget _buildServicesGrid() {
    final services = [
      {
        "title": "Pencetakan KIA",
        "icon": Icons.badge_outlined,
        "page": const FormPembuatanKiaScreen(),
      },
      {
        "title": "Akta Kelahiran",
        "icon": Icons.child_care_outlined,
        "page": const FormPembuatanAktaKelahiranScreen(),
      },
      {
        "title": "Akta Kematian",
        "icon": Icons.description_outlined,
        "page": const FormPembuatanAktaKematianScreen(),
      },
      {
        "title": "Pencetakan KTP-el",
        "icon": Icons.credit_card,
        "page": const FormPembuatanKtpScreen(),
      },
      {
        "title": "Pencetakan KK",
        "icon": Icons.family_restroom,
        "page": const FormKartuKeluargaScreen(),
      },
      {
        "title": "Perubahan Biodata",
        "icon": Icons.edit_outlined,
        "page": const FormPerubahanBiodataScreen(),
      },
      {
        "title": "Pindah Domisili",
        "icon": Icons.home_outlined,
        "page": const FormPermohonanPindahDomisiliScreen(),
      },
      {
        "title": "Jemput Bola KTP-el",
        "icon": Icons.local_shipping_outlined,
        "page": const FormJemputBolaKtpElScreen(),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.85,
        crossAxisSpacing: 10,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (context, index) {
        return ServiceCard(
          title: services[index]["title"] as String,
          icon: services[index]["icon"] as IconData,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => services[index]["page"] as Widget,
              ),
            );
          },
        );
      },
    );
  }

  // ================= SOS =================
  Widget _buildSOSSection() {
    return Column(
      children: [
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PanicButtonScreen()),
            );
          },
          child: const Column(
            children: [
              Icon(Icons.sos, size: 40, color: Colors.red),
              SizedBox(height: 6),
              Text(
                "Panic Button",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= BANNER =================
  Widget _buildBanner() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi & Pengumuman',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _bannerImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(_bannerImages[index], fit: BoxFit.cover),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ================= BOTTOM NAV =================
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      selectedItemColor: const Color(0xFF0072FF),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'FAQ'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        BottomNavigationBarItem(
          icon: Icon(Icons.info_outline),
          label: 'Identitas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profil',
        ),
      ],
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ServiceCard({
    required this.title,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 32, color: const Color(0xFF0072FF)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
