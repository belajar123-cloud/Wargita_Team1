import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<void> sendSOS() async {
  await supabase.from('sos_reports').insert({
    'user_name': 'Widya',
    'phone': '0812xxxx',
    'latitude': -5.12345,
    'longitude': 105.12345,
    'emergency_type': 'Kebakaran',
    'status': 'active',
  });
}
