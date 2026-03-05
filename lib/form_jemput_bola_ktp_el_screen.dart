import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'notification_screen.dart';

/// =======================================================
/// FORM JEMPUT BOLA KTP-el (DESAIN SEPERTI CONTOH)
//  - Header gradient
//  - Form di dalam card putih rounded
//  - Tombol di dalam card
/// =======================================================

class FormJemputBolaKtpElScreen extends StatefulWidget {
  const FormJemputBolaKtpElScreen({super.key});

  @override
  State<FormJemputBolaKtpElScreen> createState() =>
      _FormJemputBolaKtpElScreenState();
}

class _FormJemputBolaKtpElScreenState extends State<FormJemputBolaKtpElScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _alasanController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _alamatController.dispose();
    _alasanController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JemputBolaKtpElBerhasilScreen(
          nama: _namaController.text.trim(),
          nik: _nikController.text.trim(),
          alamat: _alamatController.text.trim(),
          alasan: _alasanController.text.trim(),
          telepon: _teleponController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF5F5F5),
        body: Stack(
          children: [
            // Background header gradient (seperti contoh)
            Container(
              height: 170,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0072FF), Color(0xFF00C6FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Top bar (back + title)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 16, 10),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            'Form Jemput Bola KTP',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Body scroll + Card putih
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Nama Lengkap'),
                              _field(
                                controller: _namaController,
                                hint: 'Isi nama lengkap...',
                              ),
                              const SizedBox(height: 12),

                              _label('NIK'),
                              _field(
                                controller: _nikController,
                                hint: 'Isi NIK dengan benar...',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(16),
                                ],
                                validator: (v) {
                                  final value = (v ?? '').trim();
                                  if (value.isEmpty) return 'NIK wajib diisi';
                                  if (value.length != 16)
                                    return 'NIK harus 16 digit';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              _label('Alamat Lengkap'),
                              _field(
                                controller: _alamatController,
                                hint: 'Isi alamat lengkap rumah...',
                                maxLines: 2,
                                keyboardType: TextInputType.multiline,
                              ),
                              const SizedBox(height: 12),

                              _label('Alasan membutuhkan jemput bola'),
                              _field(
                                controller: _alasanController,
                                hint: 'Isi alasan dengan jelas...',
                                maxLines: 3,
                                keyboardType: TextInputType.multiline,
                              ),
                              const SizedBox(height: 12),

                              _label('No. Telepon'),
                              _field(
                                controller: _teleponController,
                                hint: 'Isi dengan benar...',
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(15),
                                ],
                                validator: (v) {
                                  final value = (v ?? '').trim();
                                  if (value.isEmpty) {
                                    return 'Nomor telepon wajib diisi';
                                  }
                                  if (value.length < 9) {
                                    return 'Nomor telepon terlalu pendek';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),

                              // Tombol di dalam card (seperti contoh)
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2E37FF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: _submit,
                                  child: const Text(
                                    'Kirim Permohonan',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              // ruang bawah biar aman dengan home indicator
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== helper =====
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator:
          validator ??
          (v) {
            if (v == null || v.trim().isEmpty) return 'Wajib diisi';
            return null;
          },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFE9E9E9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// =======================================================
/// HALAMAN BERHASIL DIKIRIM
/// =======================================================

class JemputBolaKtpElBerhasilScreen extends StatelessWidget {
  final String nama;
  final String nik;
  final String alamat;
  final String alasan;
  final String telepon;

  const JemputBolaKtpElBerhasilScreen({
    super.key,
    required this.nama,
    required this.nik,
    required this.alamat,
    required this.alasan,
    required this.telepon,
  });

  @override
  Widget build(BuildContext context) {
    final tanggalPengajuan =
        '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          Container(
            height: 170,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0072FF), Color(0xFF00C6FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 16, 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Pengajuan Berhasil Dikirim',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _row('Nama lengkap', nama),
                            _row('NIK', nik),
                            _row('Alamat lengkap', alamat),
                            _row('Alasan membutuhkan jemput bola', alasan),
                            _row('No. Telepon', telepon),
                            _row('Tanggal Pengajuan', tanggalPengajuan),
                            _row('Status pengajuan', 'Sedang diverifikasi'),
                            const SizedBox(height: 8),
                            const Text(
                              'Permohonan kamu sedang di verifikasi oleh petugas, '
                              'proses biasanya membutuhkan waktu 3–6 hari kerja.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2E37FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const NotificationScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Cek Notifikasi',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              '$label :',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
