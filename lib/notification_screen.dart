import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _NotifItem(
            title: 'Permohonan KK dikirim',
            subtitle: 'Permohonan KK kamu sedang diproses oleh Kelurahan.',
            time: 'Baru saja',
          ),
          _NotifItem(
            title: 'Permohonan KTP-el selesai',
            subtitle: 'Silakan ambil KTP-el di kantor Kelurahan.',
            time: 'Kemarin',
          ),
          _NotifItem(
            title: 'Update data keluarga',
            subtitle: 'Data anggota keluarga berhasil diperbarui.',
            time: '2 hari lalu',
          ),
        ],
      ),
    );
  }
}

class _NotifItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;

  const _NotifItem({
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFEEF3FF),
          child: Icon(Icons.notifications, color: Color(0xFF0072FF)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(subtitle),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
