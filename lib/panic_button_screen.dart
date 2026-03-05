import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';

class PanicButtonScreen extends StatefulWidget {
  const PanicButtonScreen({super.key});

  @override
  State<PanicButtonScreen> createState() => _PanicButtonScreenState();
}

class _PanicButtonScreenState extends State<PanicButtonScreen> {
  final supabase = Supabase.instance.client;

  // Daftar layanan darurat
  final List<Map<String, dynamic>> emergencyServices = [
    {
      'name': 'Damkar',
      'desc': 'Kebakaran / penyelamatan',
      'phone': '081234567890',
      'icon': FontAwesomeIcons.fireExtinguisher,
      'color': Colors.red,
    },
    {
      'name': 'Ambulance',
      'desc': 'Kecelakaan / gawat darurat',
      'phone': '081234567891',
      'icon': FontAwesomeIcons.ambulance,
      'color': Colors.blue,
    },
    {
      'name': 'Dokter / Puskesmas',
      'desc': 'Konsultasi medis cepat',
      'phone': '081234567892',
      'icon': FontAwesomeIcons.userDoctor,
      'color': Colors.green,
    },
    {
      'name': 'Polisi',
      'desc': 'Kriminal / konflik',
      'phone': '081234567893',
      'icon': FontAwesomeIcons.shieldHalved,
      'color': Colors.indigo,
    },
  ];

  // ==============================
  // INIT REALTIME LISTENER
  // ==============================

  @override
  void initState() {
    super.initState();

    supabase
        .channel('public:sos_reports')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'sos_reports',
          callback: (payload) {
            if (mounted) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("🚨 DARURAT!"),
                  content: const Text("Ada warga membutuhkan bantuan segera!"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            }
          },
        )
        .subscribe();
  }

  // ==============================
  // KIRIM SOS KE SUPABASE
  // ==============================

  Future<void> _sendSOSReport(String serviceName) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await supabase.from('sos_reports').insert({
        'user_name': 'Widya',
        'phone': '08123456789',
        'latitude': position.latitude,
        'longitude': position.longitude,
        'emergency_type': serviceName,
        'status': 'active',
      });

      print("SOS berhasil dikirim");
    } catch (e) {
      print("Error kirim SOS: $e");
    }
  }

  // ==============================
  // TELEPON
  // ==============================

  void _makePhoneCall(String phone, String serviceName) async {
    _sendSOSReport(serviceName);

    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  // ==============================
  // WHATSAPP
  // ==============================

  void _openWhatsApp(String phone, String serviceName) async {
    _sendSOSReport(serviceName);

    final Uri url = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  // ==============================
  // UI
  // ==============================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panic Button'),
        backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Tekan tombol di bawah untuk menghubungi layanan darurat.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: emergencyServices.length,
                itemBuilder: (context, index) {
                  final service = emergencyServices[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                service['icon'],
                                color: service['color'],
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                service['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            service['desc'],
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _makePhoneCall(
                                    service['phone'],
                                    service['name'],
                                  ),
                                  icon: const Icon(Icons.phone),
                                  label: const Text('Telepon'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _openWhatsApp(
                                    service['phone'],
                                    service['name'],
                                  ),
                                  icon: const FaIcon(FontAwesomeIcons.whatsapp),
                                  label: const Text('WhatsApp'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
