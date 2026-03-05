// lib/screens/perubahan_biodata_screen.dart
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wargita_app/notification_screen.dart';

class FormPerubahanBiodataScreen extends StatefulWidget {
  const FormPerubahanBiodataScreen({super.key});

  @override
  State<FormPerubahanBiodataScreen> createState() =>
      _FormPerubahanBiodataScreenState();
}

class _FormPerubahanBiodataScreenState
    extends State<FormPerubahanBiodataScreen> {
  final _formKey = GlobalKey<FormState>();

  // controller text
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

  // optional (kalau pilih "Lainnya")
  final TextEditingController _jenisKelaminLainController =
      TextEditingController();

  // dropdown value
  String? _jenisKelamin;
  String? _agama;
  String? _golDarah;
  String? _statusPerkawinan;

  final List<String> _listJenisKelamin = ['Laki-laki', 'Perempuan', 'Lainnya'];
  final List<String> _listAgama = [
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Buddha',
    'Konghucu',
  ];
  final List<String> _listGolDarah = ['A', 'B', 'AB', 'O'];
  final List<String> _listStatusPerkawinan = [
    'Belum Kawin',
    'Kawin',
    'Cerai Hidup',
    'Cerai Mati',
  ];

  // file yang dipilih
  PlatformFile? _aktaNikahFile;
  PlatformFile? _kartuKeluargaFile;

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
    _jenisKelaminLainController.dispose();
    super.dispose();
  }

  // ================= VALIDASI =================
  String? _validateNik(String? v) {
    final nik = (v ?? '').trim();
    if (nik.isEmpty) return 'Wajib diisi';
    if (nik.length != 16 || !RegExp(r'^[0-9]+$').hasMatch(nik)) {
      return 'NIK harus 16 digit angka';
    }
    return null;
  }

  // ================= FILE PICKERS =================
  Future<void> _pickAktaNikah() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: true,
    );
    if (!mounted) return;

    if (result != null && result.files.isNotEmpty) {
      setState(() => _aktaNikahFile = result.files.first);
    }
  }

  Future<void> _pickKartuKeluarga() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: true,
    );
    if (!mounted) return;

    if (result != null && result.files.isNotEmpty) {
      setState(() => _kartuKeluargaFile = result.files.first);
    }
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final jenisKelaminFinal = (_jenisKelamin == 'Lainnya')
        ? _jenisKelaminLainController.text.trim()
        : (_jenisKelamin ?? '');

    final data = BiodataApplicationData(
      namaLengkap: _namaController.text.trim(),
      nik: _nikController.text.trim(),
      tempatTanggalLahir: _ttlController.text.trim(),
      jenisKelamin: jenisKelaminFinal.isEmpty ? '-' : jenisKelaminFinal,
      agama: _agama ?? '-',
      golDarah: _golDarah ?? '-',
      alamatLengkap: _alamatController.text.trim(),
      rt: _rtController.text.trim(),
      rw: _rwController.text.trim(),
      statusPerkawinan: _statusPerkawinan ?? '-',
      kecamatan: _kecamatanController.text.trim(),
      kelurahan: _kelurahanController.text.trim(),
      kewarganegaraan: _kewarganegaraanController.text.trim(),
      tanggalPengajuan: DateTime.now(),
      statusPengajuan: 'Menunggu verifikasi',
      lampiranAktaNikah: _aktaNikahFile != null,
      lampiranKartuKeluarga: _kartuKeluargaFile != null,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BiodataSubmissionSuccessScreen(data: data),
      ),
    );
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF5F5F5),
        body: Stack(
          children: [
            // background gradient (biar card putih "nempel" seperti contoh)
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
                  // top bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 16, 10),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            'Form Perubahan Biodata',
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

                  // card putih (isi form)
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
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Nama lengkap'),
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
                                validator: _validateNik,
                              ),
                              const SizedBox(height: 12),

                              _label('Tempat dan tanggal lahir'),
                              _field(
                                controller: _ttlController,
                                hint: 'Isi wilayah tempat dan tanggal lahir...',
                              ),
                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  Expanded(child: _label('Jenis kelamin')),
                                  const SizedBox(width: 8),
                                  Expanded(child: _label('Agama')),
                                  const SizedBox(width: 8),
                                  Expanded(child: _label('Gol. darah')),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: _dropdown(
                                      value: _jenisKelamin,
                                      items: _listJenisKelamin,
                                      hint: 'Pilih...',
                                      onChanged: (v) =>
                                          setState(() => _jenisKelamin = v),
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? 'Wajib'
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _dropdown(
                                      value: _agama,
                                      items: _listAgama,
                                      hint: 'Pilih...',
                                      onChanged: (v) =>
                                          setState(() => _agama = v),
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? 'Wajib'
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _dropdown(
                                      value: _golDarah,
                                      items: _listGolDarah,
                                      hint: 'Pilih...',
                                      onChanged: (v) =>
                                          setState(() => _golDarah = v),
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? 'Wajib'
                                          : null,
                                    ),
                                  ),
                                ],
                              ),

                              if (_jenisKelamin == 'Lainnya') ...[
                                const SizedBox(height: 10),
                                _label('Jenis kelamin (tulis manual)'),
                                _field(
                                  controller: _jenisKelaminLainController,
                                  hint: 'Contoh: Laki-laki / Perempuan / dll',
                                  validator: (v) {
                                    if (_jenisKelamin == 'Lainnya' &&
                                        (v ?? '').trim().isEmpty) {
                                      return 'Wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                              ],

                              const SizedBox(height: 12),

                              _label('Alamat lengkap'),
                              _field(
                                controller: _alamatController,
                                hint: 'Isi alamat lengkap rumah...',
                                maxLines: 2,
                              ),
                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  Expanded(child: _label('RT')),
                                  const SizedBox(width: 8),
                                  Expanded(child: _label('RW')),
                                  const SizedBox(width: 8),
                                  Expanded(child: _label('Status perkawinan')),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: _field(
                                      controller: _rtController,
                                      hint: 'RT',
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(3),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _field(
                                      controller: _rwController,
                                      hint: 'RW',
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(3),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _dropdown(
                                      value: _statusPerkawinan,
                                      items: _listStatusPerkawinan,
                                      hint: 'Pilih...',
                                      onChanged: (v) =>
                                          setState(() => _statusPerkawinan = v),
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? 'Wajib'
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              _label('Kecamatan'),
                              _field(
                                controller: _kecamatanController,
                                hint: 'Kecamatan',
                              ),
                              const SizedBox(height: 12),

                              _label('Kelurahan'),
                              _field(
                                controller: _kelurahanController,
                                hint: 'Kelurahan',
                              ),
                              const SizedBox(height: 12),

                              _label('Kewarganegaraan'),
                              _field(
                                controller: _kewarganegaraanController,
                                hint: 'Kewarganegaraan',
                              ),

                              const SizedBox(height: 16),
                              _label('Upload dokumen pendukung (opsional)'),
                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  _docTile(
                                    label: 'Akta nikah',
                                    icon: Icons.description_outlined,
                                    file: _aktaNikahFile,
                                    onTap: _pickAktaNikah,
                                  ),
                                  const SizedBox(width: 10),
                                  _docTile(
                                    label: 'Kartu keluarga',
                                    icon: Icons.family_restroom_outlined,
                                    file: _kartuKeluargaFile,
                                    onTap: _pickKartuKeluarga,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _onSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2E37FF),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26),
                                    ),
                                  ),
                                  child: const Text(
                                    'Kirim Permohonan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
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
      ),
    );
  }

  // ================= UI HELPERS =================
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

  Widget _dropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE9E9E9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
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

  Widget _docTile({
    required String label,
    required IconData icon,
    required PlatformFile? file,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 92,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE9E9E9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 11),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (file != null) ...[
                const SizedBox(height: 6),
                Text(
                  file.name,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// MODEL DATA PERUBAHAN BIODATA
class BiodataApplicationData {
  final String namaLengkap;
  final String nik;
  final String tempatTanggalLahir;
  final String jenisKelamin;
  final String agama;
  final String golDarah;
  final String alamatLengkap;
  final String rt;
  final String rw;
  final String statusPerkawinan;
  final String kecamatan;
  final String kelurahan;
  final String kewarganegaraan;
  final DateTime tanggalPengajuan;
  final String statusPengajuan;
  final bool lampiranAktaNikah;
  final bool lampiranKartuKeluarga;

  BiodataApplicationData({
    required this.namaLengkap,
    required this.nik,
    required this.tempatTanggalLahir,
    required this.jenisKelamin,
    required this.agama,
    required this.golDarah,
    required this.alamatLengkap,
    required this.rt,
    required this.rw,
    required this.statusPerkawinan,
    required this.kecamatan,
    required this.kelurahan,
    required this.kewarganegaraan,
    required this.tanggalPengajuan,
    required this.statusPengajuan,
    required this.lampiranAktaNikah,
    required this.lampiranKartuKeluarga,
  });
}

/// SCREEN "Pengajuan Berhasil Dikirim" (Perubahan Biodata)
class BiodataSubmissionSuccessScreen extends StatelessWidget {
  final BiodataApplicationData data;

  const BiodataSubmissionSuccessScreen({super.key, required this.data});

  String _formatTanggal(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d-$m-$y';
  }

  String _lampiranText() {
    final list = <String>[];
    if (data.lampiranAktaNikah) list.add('Akta nikah');
    if (data.lampiranKartuKeluarga) list.add('Kartu keluarga');
    if (list.isEmpty) return '-';
    return list.join(', ');
  }

  @override
  Widget build(BuildContext context) {
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
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () => Navigator.pop(context),
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
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow('Nama lengkap', data.namaLengkap),
                            _infoRow('NIK', data.nik),
                            _infoRow(
                              'Tempat & tanggal lahir',
                              data.tempatTanggalLahir,
                            ),
                            _infoRow('Jenis kelamin', data.jenisKelamin),
                            _infoRow('Agama', data.agama),
                            _infoRow('Gol. darah', data.golDarah),
                            _infoRow('Alamat lengkap', data.alamatLengkap),
                            _infoRow('RT/RW', '${data.rt}/${data.rw}'),
                            _infoRow(
                              'Status perkawinan',
                              data.statusPerkawinan,
                            ),
                            _infoRow('Kecamatan', data.kecamatan),
                            _infoRow('Kelurahan', data.kelurahan),
                            _infoRow('Kewarganegaraan', data.kewarganegaraan),
                            _infoRow(
                              'Tanggal pengajuan',
                              _formatTanggal(data.tanggalPengajuan),
                            ),
                            _infoRow('Status pengajuan', data.statusPengajuan),
                            _infoRow('Lampiran', _lampiranText()),
                            const SizedBox(height: 10),
                            const Text(
                              'Permohonan sedang diverifikasi, proses estimasi membutuhkan waktu 3–6 hari kerja.',
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
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const NotificationScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2E37FF),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                ),
                                child: const Text(
                                  'Cek Notifikasi',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
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
      bottomNavigationBar: const _BottomNavIdentitasSelected(),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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

/// bottom bar putih (placeholder)
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
    );
  }
}
