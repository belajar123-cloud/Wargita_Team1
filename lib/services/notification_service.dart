import 'package:flutter/material.dart';

class NotificationService {
  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'title': 'Notifikasi 1',
        'body': 'Ini adalah notifikasi pertama',
        'isNew': true,
      },
      {
        'title': 'Notifikasi 2',
        'body': 'Ini adalah notifikasi kedua',
        'isNew': false,
      },
      {
        'title': 'Notifikasi 3',
        'body': 'Ini adalah notifikasi ketiga',
        'isNew': true,
      },
    ];
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _service = NotificationService();
  late Future<List<Map<String, dynamic>>> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = _service.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: const Color.from(
          alpha: 1,
          red: 0.208,
          green: 0.541,
          blue: 0.816,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada notifikasi'));
          }

          final notifications = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              bool isNew = notification['isNew'] ?? false;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isNew ? Colors.teal[50] : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.notifications, color: Colors.white),
                  ),
                  title: Text(
                    notification['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isNew ? Colors.teal[900] : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    notification['body'],
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: isNew
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Baru',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )
                      : null,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${notification['title']} diklik!'),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: NotificationScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
