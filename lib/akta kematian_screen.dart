// lib/screens/form_pembuatan_akta_kematian_screen.dart
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FormPembuatanAktaKematianScreen extends StatefulWidget {
  const FormPembuatanAktaKematianScreen({super.key});

  @override
  State<FormPembuatanAktaKematianScreen> createState() =>
      _FormPembuatanAktaKematianScreenState();
}

class _FormPembuatanAktaKematianScreenState
    extends State<FormPembuatanAktaKematianScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ====== Data Almarhum & Pelapor
  final TextEditingController _namaAlmController = TextEditingController();
  final TextEditingController _nikAlmController = TextEditingController();
  final TextEditingController _ttlAlmController =
      TextEditingController(); // tempat & tgl lahir (teks)
  final TextEditingController _alamatAlmController = TextEditingController();

  String _jenisKelamin = 'Laki-laki';

  // tanggal wafat (dropdown)
  final TextEditingController _tglWafatController = TextEditingController();
  final TextEditingController _tempatWafatController = TextEditingController();

  String _lokasiMeninggal = 'Rumah';
  final TextEditingController _detailLokasiController = TextEditingController();

  final TextEditingController _namaPelaporController = TextEditingController();
  final TextEditingController _nikPelaporController = TextEditingController();
  final TextEditingController _hubunganPelaporController =
      TextEditingController();
  final TextEditingController _noHpPelaporController = TextEditingController();

  final TextEditingController _alamatPelaporController =
      TextEditingController();
  final TextEditingController _keteranganTambahanController =
      TextEditingController();

  // ====== File
  PlatformFile? _fileKK;
  PlatformFile? _fileKtpAlm;
  PlatformFile? _fileKtpPelapor;
  PlatformFile? _fileSuratKematian;

  // ====== UI Colors
  static const Color _blue1 = Color(0xFF0072FF);
  static const Color _blue2 = Color(0xFF00C6FF);

  // ==========================================================
  // DATE DROPDOWN (MANUAL) - Tahun 1950 sampai 2026
  // ==========================================================
  int? _wafatDay;
  int? _wafatMonth;
  int? _wafatYear;

  final List<int> _years1950to2026 = List<int>.generate(
    2026 - 1950 + 1,
    (i) => 1950 + i,
  );

  final List<Map<String, dynamic>> _monthsId = const [
    {"num": 1, "name": "Januari"},
    {"num": 2, "name": "Februari"},
    {"num": 3, "name": "Maret"},
    {"num": 4, "name": "April"},
    {"num": 5, "name": "Mei"},
    {"num": 6, "name": "Juni"},
    {"num": 7, "name": "Juli"},
    {"num": 8, "name": "Agustus"},
    {"num": 9, "name": "September"},
    {"num": 10, "name": "Oktober"},
    {"num": 11, "name": "November"},
    {"num": 12, "name": "Desember"},
  ];

  List<int> _daysFor(int year, int month) {
    final lastDay = DateTime(year, month + 1, 0).day;
    return List<int>.generate(lastDay, (i) => i + 1);
  }

  String _formatDdMmYyyy(int day, int month, int year) {
    final dd = day.toString().padLeft(2, '0');
    final mm = month.toString().padLeft(2, '0');
    return '$dd-$mm-$year';
  }

  void _syncTanggalWafatController() {
    if (_wafatDay != null && _wafatMonth != null && _wafatYear != null) {
      _tglWafatController.text = _formatDdMmYyyy(
        _wafatDay!,
        _wafatMonth!,
        _wafatYear!,
      );
    } else {
      _tglWafatController.text = '';
    }
  }

  int _maxDay(int year, int month) => DateTime(year, month + 1, 0).day;

  void _clampWafatDayIfNeeded() {
    final y = _wafatYear;
    final m = _wafatMonth;
    if (y == null || m == null || _wafatDay == null) return;
    final max = _maxDay(y, m);
    if (_wafatDay! > max) _wafatDay = max;
  }

  @override
  void initState() {
    super.initState();
    // Default isi ke tanggal hari ini (kalau masih dalam range 1950-2026)
    final now = DateTime.now();
    final yy = now.year.clamp(1950, 2026);
    _wafatYear = yy;
    _wafatMonth = now.month;
    _wafatDay = now.day.clamp(1, _maxDay(_wafatYear!, _wafatMonth!));
    _syncTanggalWafatController();
  }

  @override
  void dispose() {
    _namaAlmController.dispose();
    _nikAlmController.dispose();
    _ttlAlmController.dispose();
    _alamatAlmController.dispose();

    _tglWafatController.dispose();
    _tempatWafatController.dispose();
    _detailLokasiController.dispose();

    _namaPelaporController.dispose();
    _nikPelaporController.dispose();
    _hubunganPelaporController.dispose();
    _noHpPelaporController.dispose();
    _alamatPelaporController.dispose();
    _keteranganTambahanController.dispose();
    super.dispose();
  }

  // ====== File Picker
  Future<void> _pickFile({
    required void Function(PlatformFile? file) onPicked,
    List<String>? allowedExtensions,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: allowedExtensions == null ? FileType.any : FileType.custom,
      allowedExtensions: allowedExtensions,
      withData: false,
    );
    if (result == null || result.files.isEmpty) return;
    onPicked(result.files.single);
    setState(() {});
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final missing = <String>[];
    if (_fileKK == null) missing.add('Kartu Keluarga (KK)');
    if (_fileKtpAlm == null) missing.add('KTP Almarhum');
    if (_fileKtpPelapor == null) missing.add('KTP Pelapor');
    if (_fileSuratKematian == null) missing.add('Surat Keterangan Kematian');

    if (missing.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mohon unggah: ${missing.join(', ')}')),
      );
      return;
    }

    final payload = {
      "almarhum": {
        "nama": _namaAlmController.text.trim(),
        "nik": _nikAlmController.text.trim(),
        "jenis_kelamin": _jenisKelamin,
        "ttl": _ttlAlmController.text.trim(),
        "alamat": _alamatAlmController.text.trim(),
        "tgl_wafat": _tglWafatController.text.trim(),
        "tempat_wafat": _tempatWafatController.text.trim(),
        "lokasi_meninggal": _lokasiMeninggal,
        "detail_lokasi": _detailLokasiController.text.trim(),
      },
      "pelapor": {
        "nama": _namaPelaporController.text.trim(),
        "nik": _nikPelaporController.text.trim(),
        "hubungan": _hubunganPelaporController.text.trim(),
        "no_hp": _noHpPelaporController.text.trim(),
        "alamat": _alamatPelaporController.text.trim(),
      },
      "keterangan": _keteranganTambahanController.text.trim(),
      "files": {
        "kk": _fileKK?.name,
        "ktp_almarhum": _fileKtpAlm?.name,
        "ktp_pelapor": _fileKtpPelapor?.name,
        "surat_kematian": _fileSuratKematian?.name,
      },
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(Duration(milliseconds: 900));
    if (!mounted) return;
    Navigator.pop(context);

    // ignore: avoid_print
    print(payload);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const _SuccessAktaKematianScreen()),
    );
  }

  String? _required(String? v, {String label = 'Field'}) {
    if (v == null || v.trim().isEmpty) return '$label wajib diisi';
    return null;
  }

  String? _nikValidator(String? v, {String label = 'NIK'}) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return '$label wajib diisi';
    if (s.length != 16) return '$label harus 16 digit';
    if (!RegExp(r'^\d{16}$').hasMatch(s)) return '$label hanya angka';
    return null;
  }

  String? _phoneValidator(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'No. HP wajib diisi';
    if (s.length < 10) return 'No. HP terlalu pendek';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderLikePrevious(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
                child: Form(key: _formKey, child: _buildMainCard()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====== HEADER (mirip gambar sebelumnya)
  Widget _buildHeaderLikePrevious() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_blue1, _blue2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            ),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Form Pembuatan Akta Kematian',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.2,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 40), // supaya judul benar2 center
        ],
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Data Almarhum (gaya label + input abu)
          _label('Nama Almarhum'),
          _textField(
            controller: _namaAlmController,
            icon: Icons.person_outline,
            hint: 'Isi nama lengkap ...',
            validator: (v) => _required(v, label: 'Nama almarhum'),
          ),
          const SizedBox(height: 10),

          _label('NIK Almarhum'),
          _textField(
            controller: _nikAlmController,
            icon: Icons.badge_outlined,
            hint: '16 digit NIK ...',
            keyboardType: TextInputType.number,
            validator: (v) => _nikValidator(v, label: 'NIK almarhum'),
          ),
          const SizedBox(height: 10),

          _label('Jenis Kelamin'),
          _dropdownField(
            value: _jenisKelamin,
            icon: Icons.wc_outlined,
            items: const ['Laki-laki', 'Perempuan'],
            onChanged: (v) => setState(() => _jenisKelamin = v ?? 'Laki-laki'),
          ),
          const SizedBox(height: 10),

          _label('Tempat dan tanggal lahir'),
          _textField(
            controller: _ttlAlmController,
            icon: Icons.cake_outlined,
            hint: 'Contoh: Medan, 12-05-1990',
            validator: (v) => _required(v, label: 'Tempat & tanggal lahir'),
          ),
          const SizedBox(height: 10),

          _label('Alamat Almarhum (sesuai KK)'),
          _textField(
            controller: _alamatAlmController,
            icon: Icons.home_outlined,
            hint: 'Isi alamat lengkap ...',
            maxLines: 2,
            validator: (v) => _required(v, label: 'Alamat almarhum'),
          ),
          const SizedBox(height: 14),

          // ===== Data Kematian
          _sectionTitle('Data Kematian'),
          _label('Tanggal meninggal'),
          _tanggalWafatRowLikePrevious(),
          const SizedBox(height: 10),

          _label('Tempat meninggal'),
          _textField(
            controller: _tempatWafatController,
            icon: Icons.location_on_outlined,
            hint: 'Contoh: Medan',
            validator: (v) => _required(v, label: 'Tempat meninggal'),
          ),
          const SizedBox(height: 10),

          _label('Lokasi meninggal'),
          _dropdownField(
            value: _lokasiMeninggal,
            icon: Icons.local_hospital_outlined,
            items: const ['Rumah', 'Rumah Sakit', 'Lainnya'],
            onChanged: (v) {
              setState(() {
                _lokasiMeninggal = v ?? 'Rumah';
                _detailLokasiController.clear();
              });
            },
          ),
          if (_lokasiMeninggal != 'Rumah') ...[
            const SizedBox(height: 10),
            _label(
              _lokasiMeninggal == 'Rumah Sakit'
                  ? 'Nama Rumah Sakit'
                  : 'Detail lokasi lainnya',
            ),
            _textField(
              controller: _detailLokasiController,
              icon: Icons.description_outlined,
              hint: _lokasiMeninggal == 'Rumah Sakit'
                  ? 'Contoh: RS ABC'
                  : 'Contoh: panti / di perjalanan / dll',
              validator: (v) => _required(v, label: 'Detail lokasi'),
            ),
          ],
          const SizedBox(height: 14),

          // ===== Data Pelapor
          _sectionTitle('Data Pelapor'),
          _label('Nama pelapor'),
          _textField(
            controller: _namaPelaporController,
            icon: Icons.person_pin_outlined,
            hint: 'Isi nama lengkap ...',
            validator: (v) => _required(v, label: 'Nama pelapor'),
          ),
          const SizedBox(height: 10),

          _label('NIK pelapor'),
          _textField(
            controller: _nikPelaporController,
            icon: Icons.badge_outlined,
            hint: '16 digit NIK ...',
            keyboardType: TextInputType.number,
            validator: (v) => _nikValidator(v, label: 'NIK pelapor'),
          ),
          const SizedBox(height: 10),

          _label('Hubungan pelapor dengan almarhum'),
          _textField(
            controller: _hubunganPelaporController,
            icon: Icons.family_restroom_outlined,
            hint: 'Contoh: Anak / Istri / Suami / Orang Tua',
            validator: (v) => _required(v, label: 'Hubungan'),
          ),
          const SizedBox(height: 10),

          _label('No. HP pelapor'),
          _textField(
            controller: _noHpPelaporController,
            icon: Icons.phone_outlined,
            hint: 'Contoh: 0812xxxxxxx',
            keyboardType: TextInputType.phone,
            validator: _phoneValidator,
          ),
          const SizedBox(height: 10),

          _label('Alamat pelapor'),
          _textField(
            controller: _alamatPelaporController,
            icon: Icons.home_work_outlined,
            hint: 'Isi alamat lengkap ...',
            maxLines: 2,
            validator: (v) => _required(v, label: 'Alamat pelapor'),
          ),
          const SizedBox(height: 10),

          _label('Keterangan tambahan (opsional)'),
          _textField(
            controller: _keteranganTambahanController,
            icon: Icons.note_alt_outlined,
            hint: 'Tambahkan info bila diperlukan ...',
            maxLines: 3,
          ),
          const SizedBox(height: 14),

          // ===== Upload
          _sectionTitle('Upload dokumen pendukung'),
          const SizedBox(height: 8),
          _upload3TilesRow(),
          const SizedBox(height: 10),
          _uploadWideTile(),
          const SizedBox(height: 16),

          // ===== Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue1,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'Kirim Permohonan',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================
  // UI Helpers (mirip gambar)
  // ==========================
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 10, top: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13.8,
          fontWeight: FontWeight.w800,
          color: Colors.black87,
        ),
      ),
    );
  }

  InputDecoration _inputDec({required IconData icon, String? hint}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.black54, size: 20),
      filled: true,
      fillColor: const Color(0xFFEFEFEF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: _blue1, width: 1.2),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: _inputDec(icon: icon, hint: hint),
    );
  }

  Widget _dropdownField({
    required String value,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: onChanged,
      decoration: _inputDec(icon: icon, hint: null),
      items: items
          .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
          .toList(),
    );
  }

  // ==========================
  // Tanggal wafat (row 3 dropdown) - gaya abu + rounded
  // ==========================
  Widget _tanggalWafatRowLikePrevious() {
    final effectiveYear = _wafatYear ?? 2026;
    final effectiveMonth = _wafatMonth ?? 1;
    final days = _daysFor(effectiveYear, effectiveMonth);

    if (_wafatDay != null && _wafatDay! > days.length) {
      _wafatDay = days.length;
      _syncTanggalWafatController();
    }

    InputDecoration dec({required String hint, required IconData icon}) {
      return InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.black54, size: 18),
        filled: true,
        fillColor: const Color(0xFFEFEFEF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _blue1, width: 1.1),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<int>(
                initialValue: _wafatDay,
                isExpanded: true,
                decoration: dec(
                  hint: 'Tgl',
                  icon: Icons.calendar_today_outlined,
                ),
                items: days
                    .map(
                      (d) => DropdownMenuItem<int>(
                        value: d,
                        child: Text(d.toString().padLeft(2, '0')),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() => _wafatDay = v);
                  _syncTanggalWafatController();
                },
                validator: (v) => v == null ? 'Pilih tgl' : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<int>(
                initialValue: _wafatMonth,
                isExpanded: true,
                decoration: dec(hint: 'Bulan', icon: Icons.date_range_outlined),
                items: _monthsId
                    .map(
                      (m) => DropdownMenuItem<int>(
                        value: m["num"] as int,
                        child: Text(
                          m["name"] as String,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _wafatMonth = v;
                    _clampWafatDayIfNeeded();
                  });
                  _syncTanggalWafatController();
                },
                validator: (v) => v == null ? 'Pilih bln' : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<int>(
                initialValue: _wafatYear,
                isExpanded: true,
                decoration: dec(hint: 'Tahun', icon: Icons.event_outlined),
                items: _years1950to2026
                    .map(
                      (y) => DropdownMenuItem<int>(
                        value: y,
                        child: Text(y.toString()),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _wafatYear = v;
                    _clampWafatDayIfNeeded();
                  });
                  _syncTanggalWafatController();
                },
                validator: (v) => v == null ? 'Pilih thn' : null,
              ),
            ),
          ],
        ),
        if (_tglWafatController.text.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            'Tanggal dipilih: ${_tglWafatController.text}',
            style: const TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ],
    );
  }

  // ==========================
  // Upload tiles (3 kotak + 1 kotak lebar)
  // ==========================
  Widget _upload3TilesRow() {
    return Row(
      children: [
        Expanded(
          child: _uploadTileBox(
            title: 'KTP',
            subtitle: _fileKtpAlm?.name,
            icon: Icons.credit_card_outlined,
            picked: _fileKtpAlm != null,
            onTap: () => _pickFile(
              onPicked: (f) => _fileKtpAlm = f,
              allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
            ),
            onClear: () => setState(() => _fileKtpAlm = null),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _uploadTileBox(
            title: 'Kartu keluarga',
            subtitle: _fileKK?.name,
            icon: Icons.badge_outlined,
            picked: _fileKK != null,
            onTap: () => _pickFile(
              onPicked: (f) => _fileKK = f,
              allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
            ),
            onClear: () => setState(() => _fileKK = null),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _uploadTileBox(
            title: 'KTP pelapor',
            subtitle: _fileKtpPelapor?.name,
            icon: Icons.perm_identity_outlined,
            picked: _fileKtpPelapor != null,
            onTap: () => _pickFile(
              onPicked: (f) => _fileKtpPelapor = f,
              allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
            ),
            onClear: () => setState(() => _fileKtpPelapor = null),
          ),
        ),
      ],
    );
  }

  Widget _uploadWideTile() {
    return _uploadWideBox(
      title: 'Surat keterangan\nkematian',
      subtitle: _fileSuratKematian?.name,
      icon: Icons.medical_information_outlined,
      picked: _fileSuratKematian != null,
      onTap: () => _pickFile(
        onPicked: (f) => _fileSuratKematian = f,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      ),
      onClear: () => setState(() => _fileSuratKematian = null),
    );
  }

  Widget _uploadTileBox({
    required String title,
    required IconData icon,
    required bool picked,
    required VoidCallback onTap,
    required VoidCallback onClear,
    String? subtitle,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 82,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: picked ? _blue1.withValues(alpha: 0.25) : Colors.transparent,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    picked ? Icons.check_circle_outline : icon,
                    color: picked ? _blue1 : Colors.black54,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11.8,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  if (picked && (subtitle ?? '').isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (picked)
              Positioned(
                right: 0,
                top: 0,
                child: InkWell(
                  onTap: onClear,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Icon(Icons.close, size: 14),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _uploadWideBox({
    required String title,
    required IconData icon,
    required bool picked,
    required VoidCallback onTap,
    required VoidCallback onClear,
    String? subtitle,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 78,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: picked ? _blue1.withValues(alpha: 0.25) : Colors.transparent,
          ),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Icon(
                  picked ? Icons.check_circle_outline : icon,
                  color: picked ? _blue1 : Colors.black54,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12.2,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      if (picked && (subtitle ?? '').isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (picked)
              Positioned(
                right: 0,
                top: 0,
                child: InkWell(
                  onTap: onClear,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Icon(Icons.close, size: 14),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ====== SUCCESS SCREEN (tetap)
class _SuccessAktaKematianScreen extends StatelessWidget {
  const _SuccessAktaKematianScreen();

  static const Color _blue1 = Color(0xFF0072FF);
  static const Color _blue2 = Color(0xFF00C6FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, 18, 16, 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_blue1, _blue2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Row(
                children: const [
                  Icon(Icons.verified_outlined, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Pengajuan Berhasil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 14,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color(0xFFE7F1FF),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Icon(
                          Icons.check_circle_outline,
                          size: 44,
                          color: _blue1,
                        ),
                      ),
                      SizedBox(height: 14),
                      Text(
                        'Pengajuan Akta Kematian berhasil dikirim.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Silakan tunggu proses verifikasi.\nKamu akan mendapat notifikasi saat status berubah.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, height: 1.35),
                      ),
                      SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.notifications_none),
                          label: Text('Lihat Notifikasi'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _blue1,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Kembali'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
