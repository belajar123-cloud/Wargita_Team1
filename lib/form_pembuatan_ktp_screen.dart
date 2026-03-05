import 'package:flutter/material.dart';

/// PAGE 1 – FORM PEMBUATAN KTP
class FormPembuatanKtpScreen extends StatefulWidget {
  const FormPembuatanKtpScreen({super.key});

  @override
  State<FormPembuatanKtpScreen> createState() => _FormPembuatanKtpScreenState();
}

class _FormPembuatanKtpScreenState extends State<FormPembuatanKtpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _ttlController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _rtController = TextEditingController();
  final TextEditingController _rwController = TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kelurahanController = TextEditingController();
  final TextEditingController _kewarganegaraanController =
      TextEditingController();

  String? _jenisKelamin;
  String? _agama;
  String? _golDarah;
  String? _statusPerkawinan;

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _ttlController.dispose();
    _alamatController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    _kecamatanController.dispose();
    _kelurahanController.dispose();
    _kewarganegaraanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // ======= BACKGROUND BIRU LEBAR DI ATAS =======
          Container(
            height: 230, // atur tinggi biru sesuai selera
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0072FF), Color(0xFF00C6FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ======= KONTEN DI ATAS BACKGROUND =======
          SafeArea(
            child: Column(
              children: [
                // Top bar: back + title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Row(
                    children: const [
                      BackButton(color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Form Pembuatan KTP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Card putih berisi form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
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
                            const SizedBox(height: 10),

                            _label('NIK'),
                            _field(
                              controller: _nikController,
                              hint: 'Isi NIK dengan benar...',
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 10),

                            _label('Tempat dan Tanggal Lahir'),
                            _field(
                              controller: _ttlController,
                              hint: 'Isi wilayah tempat dan tanggal lahir...',
                            ),
                            const SizedBox(height: 10),

                            _label('Jenis Kelamin   Agama   Gol. Darah'),
                            Row(
                              children: [
                                Expanded(
                                  child: _dropdown(
                                    value: _jenisKelamin,
                                    hint: 'pilih jenis kelamin...',
                                    items: const ['Laki-laki', 'Perempuan'],
                                    onChanged: (v) =>
                                        setState(() => _jenisKelamin = v),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _dropdown(
                                    value: _agama,
                                    hint: 'Pilih status agama...',
                                    items: const [
                                      'Islam',
                                      'Kristen',
                                      'Katolik',
                                      'Hindu',
                                      'Budha',
                                      'Konghucu',
                                    ],
                                    onChanged: (v) =>
                                        setState(() => _agama = v),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _dropdown(
                                    value: _golDarah,
                                    hint: 'Isi gol. darah...',
                                    items: const ['A', 'B', 'AB', 'O'],
                                    onChanged: (v) =>
                                        setState(() => _golDarah = v),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            _label('Alamat Lengkap'),
                            _field(
                              controller: _alamatController,
                              hint: 'Isi alamat lengkap rumah...',
                              maxLines: 2,
                            ),
                            const SizedBox(height: 10),

                            _label('RT    RW    Status Perkawinan'),
                            Row(
                              children: [
                                Expanded(
                                  child: _field(
                                    controller: _rtController,
                                    hint: 'Isi wilayah RT...',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _field(
                                    controller: _rwController,
                                    hint: 'Isi wilayah RW...',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _dropdown(
                                    value: _statusPerkawinan,
                                    hint: 'Isi status perkawinan...',
                                    items: const [
                                      'Belum Kawin',
                                      'Kawin',
                                      'Cerai Hidup',
                                      'Cerai Mati',
                                    ],
                                    onChanged: (v) =>
                                        setState(() => _statusPerkawinan = v),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            _label('Kecamatan   Kelurahan'),
                            Row(
                              children: [
                                Expanded(
                                  child: _field(
                                    controller: _kecamatanController,
                                    hint: 'Kecamatan',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _field(
                                    controller: _kelurahanController,
                                    hint: 'Kelurahan',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            _label('Kewarganegaraan'),
                            _field(
                              controller: _kewarganegaraanController,
                              hint: 'Isi kewarganegaraan...',
                            ),
                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2E37FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                onPressed: _onSubmit,
                                child: const Text(
                                  'Kirim Permohonan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
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
        ],
      ),
      bottomNavigationBar: const _BottomNavIdentitasSelected(),
    );
  }

  // ================= WIDGET KECIL FORM =================

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Wajib diisi';
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFE5E5E5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE5E5E5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      hint: Text(
        hint,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      icon: const Icon(Icons.arrow_drop_down),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(fontSize: 12)),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PengajuanKtpBerhasilScreen(
          namaLengkap: _namaController.text.trim(),
          nik: _nikController.text.trim(),
          ttl: _ttlController.text.trim(),
          jenisKelamin: _jenisKelamin ?? '-',
          agama: _agama ?? '-',
          golDarah: _golDarah ?? '-',
          alamat: _alamatController.text.trim(),
          rt: _rtController.text.trim(),
          rw: _rwController.text.trim(),
          statusPerkawinan: _statusPerkawinan ?? '-',
          kecamatan: _kecamatanController.text.trim(),
          kelurahan: _kelurahanController.text.trim(),
          kewarganegaraan: _kewarganegaraanController.text.trim(),
        ),
      ),
    );
  }
}

/// BOTTOM NAV – Identitas aktif (bar putih saja, tanpa item)
class _BottomNavIdentitasSelected extends StatelessWidget {
  const _BottomNavIdentitasSelected();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black12,
            offset: Offset(0, -1),
          ),
        ],
      ),
      // child Row(...) sudah dihapus
    );
  }
}

/// PAGE 2 – PENGAJUAN BERHASIL DIKIRIM
class PengajuanKtpBerhasilScreen extends StatelessWidget {
  final String namaLengkap;
  final String nik;
  final String ttl;
  final String jenisKelamin;
  final String agama;
  final String golDarah;
  final String alamat;
  final String rt;
  final String rw;
  final String statusPerkawinan;
  final String kecamatan;
  final String kelurahan;
  final String kewarganegaraan;

  const PengajuanKtpBerhasilScreen({
    super.key,
    required this.namaLengkap,
    required this.nik,
    required this.ttl,
    required this.jenisKelamin,
    required this.agama,
    required this.golDarah,
    required this.alamat,
    required this.rt,
    required this.rw,
    required this.statusPerkawinan,
    required this.kecamatan,
    required this.kelurahan,
    required this.kewarganegaraan,
  });

  @override
  Widget build(BuildContext context) {
    final tanggalPengajuan =
        '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, 'Pengajuan Berhasil Dikirim'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _row('Nama lengkap', namaLengkap),
                          _row('NIK', nik),
                          _row('Tempat dan Tanggal Lahir', ttl),
                          _row('Jenis Kelamin', jenisKelamin),
                          _row('Agama', agama),
                          _row('Gol. Darah', golDarah),
                          _row('Alamat Lengkap', alamat),
                          _row('RT/RW', '$rt / $rw'),
                          _row('Status Perkawinan', statusPerkawinan),
                          _row('Kecamatan', kecamatan),
                          _row('Kelurahan', kelurahan),
                          _row('Kewarganegaraan', kewarganegaraan),
                          _row('Tanggal Pengajuan', tanggalPengajuan),
                          const SizedBox(height: 8),
                          const Text(
                            'Status Pengajuan :',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Permohonan sedang di verifikasi, proses estimasi '
                            'membutuhkan waktu 3–6 hari kerja.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E37FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () {
                          // sementara kembali ke page sebelumnya
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cek Notifikasi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomNavIdentitasSelected(),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0072FF), Color(0xFF00C6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
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
