// lib/screens/form_permohonan_pindah_domisili_screen.dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

/// =======================================================
/// FORM PERMOHONAN PINDAH DOMISILI (DESAIN MIRIP FORM KTP)
///  - Header gradasi biru
///  - Card putih rounded
///  - Input pill abu-abu
///  - Tombol di dalam card (seperti screenshot)
/// =======================================================

class FormPermohonanPindahDomisiliScreen extends StatefulWidget {
  const FormPermohonanPindahDomisiliScreen({super.key});

  @override
  State<FormPermohonanPindahDomisiliScreen> createState() =>
      _FormPermohonanPindahDomisiliScreenState();
}

class _FormPermohonanPindahDomisiliScreenState
    extends State<FormPermohonanPindahDomisiliScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0; // 0 = step1, 1 = step2

  // Form keys
  final GlobalKey<FormState> _formKeyStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStep2 = GlobalKey<FormState>();

  // ---------- STEP 1 ----------
  final TextEditingController _namaKepalaController = TextEditingController();
  final TextEditingController _nikKepalaController = TextEditingController();
  final TextEditingController _alasanPindahController = TextEditingController();
  final TextEditingController _namaAnggotaController = TextEditingController();
  final TextEditingController _nikAnggotaController = TextEditingController();

  String? _jumlahAnggotaIkut;
  String? _statusAnggota;

  // ---------- STEP 2 (ALAMAT ASAL) ----------
  final TextEditingController _alamatAsalController = TextEditingController();
  final TextEditingController _rtAsalController = TextEditingController();
  final TextEditingController _rwAsalController = TextEditingController();
  final TextEditingController _kelurahanAsalController =
      TextEditingController();
  final TextEditingController _kecamatanAsalController =
      TextEditingController();
  final TextEditingController _kabupatenAsalController =
      TextEditingController();
  final TextEditingController _provinsiAsalController = TextEditingController();

  // ---------- STEP 2 (ALAMAT TUJUAN) ----------
  final TextEditingController _alamatTujuanController = TextEditingController();
  final TextEditingController _rtTujuanController = TextEditingController();
  final TextEditingController _rwTujuanController = TextEditingController();
  final TextEditingController _kelurahanTujuanController =
      TextEditingController();
  final TextEditingController _kecamatanTujuanController =
      TextEditingController();
  final TextEditingController _kabupatenTujuanController =
      TextEditingController();
  final TextEditingController _provinsiTujuanController =
      TextEditingController();

  // ---------- DOKUMEN ----------
  PlatformFile? _fileKtp;
  PlatformFile? _fileKk;

  // ---------- THEME CONST ----------
  static const Color _bg = Color(0xFFF5F5F5);
  static const Color _primaryBtn = Color(0xFF2E37FF);
  static const Color _pillFill = Color(0xFFE9E9E9);
  static const List<Color> _grad = [Color(0xFF0072FF), Color(0xFF00C6FF)];

  @override
  void dispose() {
    _pageController.dispose();

    _namaKepalaController.dispose();
    _nikKepalaController.dispose();
    _alasanPindahController.dispose();
    _namaAnggotaController.dispose();
    _nikAnggotaController.dispose();

    _alamatAsalController.dispose();
    _rtAsalController.dispose();
    _rwAsalController.dispose();
    _kelurahanAsalController.dispose();
    _kecamatanAsalController.dispose();
    _kabupatenAsalController.dispose();
    _provinsiAsalController.dispose();

    _alamatTujuanController.dispose();
    _rtTujuanController.dispose();
    _rwTujuanController.dispose();
    _kelurahanTujuanController.dispose();
    _kecamatanTujuanController.dispose();
    _kabupatenTujuanController.dispose();
    _provinsiTujuanController.dispose();

    super.dispose();
  }

  Future<void> _pickDokumen(String jenis) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: true,
    );
    if (result == null) return;

    setState(() {
      final file = result.files.single;
      if (jenis == 'ktp') {
        _fileKtp = file;
      } else if (jenis == 'kk') {
        _fileKk = file;
      }
    });
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _onNextOrSubmit() {
    if (_currentStep == 0) {
      if (!(_formKeyStep1.currentState?.validate() ?? false)) return;
      _goToStep(1);
    } else {
      if (!(_formKeyStep2.currentState?.validate() ?? false)) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PengajuanPindahDomisiliBerhasilScreen(
            namaKepala: _namaKepalaController.text.trim(),
            nikKepala: _nikKepalaController.text.trim(),
            alasanPindah: _alasanPindahController.text.trim(),
            alamatAsal: _alamatAsalController.text.trim(),
            alamatTujuan: _alamatTujuanController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // Top gradient background (seperti screenshot)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 210,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: _grad,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [_buildStep1(), _buildStep2()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= TOP BAR (mirip screenshot) =================
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 12, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              if (_currentStep == 0) {
                Navigator.pop(context);
              } else {
                _goToStep(0);
              }
            },
          ),
          const SizedBox(width: 2),
          const Expanded(
            child: Text(
              'Form Permohonan Pindah Domisili',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= CARD WRAPPER =================
  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  // ================= STEP INDICATOR (simple & rapi) =================
  Widget _stepIndicator() {
    return Row(
      children: [
        Expanded(
          child: _stepChip(
            active: _currentStep == 0,
            title: 'Step 1',
            subtitle: 'Data Keluarga',
            onTap: () => _goToStep(0),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _stepChip(
            active: _currentStep == 1,
            title: 'Step 2',
            subtitle: 'Alamat & Dokumen',
            onTap: () {
              // hanya boleh ke step 2 kalau step 1 valid
              if (_currentStep == 0) {
                if (!(_formKeyStep1.currentState?.validate() ?? false)) return;
              }
              _goToStep(1);
            },
          ),
        ),
      ],
    );
  }

  Widget _stepChip({
    required bool active,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEAF2FF) : const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? const Color(0xFF9CC6FF) : const Color(0xFFE0E0E0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: active ? const Color(0xFF0B57D0) : Colors.black54,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: active ? const Color(0xFF0B57D0) : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= STEP 1 =================
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: _card(
        child: Form(
          key: _formKeyStep1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _stepIndicator(),
              const SizedBox(height: 14),

              _label('Nama Kepala Keluarga'),
              _pillField(
                controller: _namaKepalaController,
                hint: 'Isi nama lengkap...',
              ),
              const SizedBox(height: 12),

              _label('NIK Kepala Keluarga'),
              _pillField(
                controller: _nikKepalaController,
                hint: 'Isi NIK dengan benar...',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              _label('Alasan Pindah'),
              _pillField(
                controller: _alasanPindahController,
                hint: 'Isi alasan dengan jelas...',
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              _label('Jumlah Anggota Keluarga yang Ikut Pindah'),
              _pillDropdown(
                value: _jumlahAnggotaIkut,
                hint: 'Pilih jumlah anggota...',
                items: const ['1', '2', '3', '4', '5+', 'Semua anggota'],
                onChanged: (v) => setState(() => _jumlahAnggotaIkut = v),
              ),
              const SizedBox(height: 12),

              _label('Nama Anggota Keluarga'),
              _pillField(
                controller: _namaAnggotaController,
                hint: 'Isi nama lengkap...',
              ),
              const SizedBox(height: 12),

              _label('NIK Anggota Keluarga'),
              _pillField(
                controller: _nikAnggotaController,
                hint: 'Isi NIK dengan benar...',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              _label('Status Anggota'),
              _pillDropdown(
                value: _statusAnggota,
                hint: 'Pilih status...',
                items: const [
                  'Kepala Keluarga',
                  'Istri',
                  'Anak',
                  'Orang Tua',
                  'Anggota Lain',
                ],
                onChanged: (v) => setState(() => _statusAnggota = v),
              ),

              const SizedBox(height: 18),

              _primaryButton(text: 'Next', onPressed: _onNextOrSubmit),
            ],
          ),
        ),
      ),
    );
  }

  // ================= STEP 2 =================
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: _card(
        child: Form(
          key: _formKeyStep2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _stepIndicator(),
              const SizedBox(height: 14),

              _sectionTitle('Alamat Asal'),
              _label('Alamat Lengkap'),
              _pillField(
                controller: _alamatAsalController,
                hint: 'Isi alamat dengan lengkap...',
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _labeledPillSmall(
                      label: 'RT',
                      child: _pillField(
                        controller: _rtAsalController,
                        hint: 'Isi RT...',
                        keyboardType: TextInputType.number,
                        dense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _labeledPillSmall(
                      label: 'RW',
                      child: _pillField(
                        controller: _rwAsalController,
                        hint: 'Isi RW...',
                        keyboardType: TextInputType.number,
                        dense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _labeledPillSmall(
                      label: 'Kelurahan',
                      child: _pillField(
                        controller: _kelurahanAsalController,
                        hint: 'Kelurahan',
                        dense: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _labeledPillSmall(
                      label: 'Kecamatan',
                      child: _pillField(
                        controller: _kecamatanAsalController,
                        hint: 'Kecamatan',
                        dense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _labeledPillSmall(
                      label: 'Kabupaten',
                      child: _pillField(
                        controller: _kabupatenAsalController,
                        hint: 'Kabupaten',
                        dense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _labeledPillSmall(
                      label: 'Provinsi',
                      child: _pillField(
                        controller: _provinsiAsalController,
                        hint: 'Provinsi',
                        dense: true,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _sectionTitle('Alamat Tujuan'),

              _label('Alamat Lengkap'),
              _pillField(
                controller: _alamatTujuanController,
                hint: 'Isi alamat dengan lengkap...',
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _labeledPillSmall(
                      label: 'RT',
                      child: _pillField(
                        controller: _rtTujuanController,
                        hint: 'Isi RT...',
                        keyboardType: TextInputType.number,
                        dense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _labeledPillSmall(
                      label: 'RW',
                      child: _pillField(
                        controller: _rwTujuanController,
                        hint: 'Isi RW...',
                        keyboardType: TextInputType.number,
                        dense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _labeledPillSmall(
                      label: 'Kelurahan',
                      child: _pillField(
                        controller: _kelurahanTujuanController,
                        hint: 'Kelurahan',
                        dense: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _labeledPillSmall(
                      label: 'Kecamatan',
                      child: _pillField(
                        controller: _kecamatanTujuanController,
                        hint: 'Kecamatan',
                        dense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _labeledPillSmall(
                      label: 'Kabupaten',
                      child: _pillField(
                        controller: _kabupatenTujuanController,
                        hint: 'Kabupaten',
                        dense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _labeledPillSmall(
                      label: 'Provinsi',
                      child: _pillField(
                        controller: _provinsiTujuanController,
                        hint: 'Provinsi',
                        dense: true,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _sectionTitle('Upload Dokumen'),

              Row(
                children: [
                  Expanded(
                    child: _docPill(
                      label: 'KTP',
                      icon: Icons.credit_card,
                      file: _fileKtp,
                      onTap: () => _pickDokumen('ktp'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _docPill(
                      label: 'Kartu\nKeluarga',
                      icon: Icons.featured_play_list_outlined,
                      file: _fileKk,
                      onTap: () => _pickDokumen('kk'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Unggah KTP & Kartu Keluarga untuk mendukung permohonan pindah.',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),

              const SizedBox(height: 18),
              _primaryButton(
                text: 'Kirim Permohonan',
                onPressed: _onNextOrSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= UI HELPERS (mirip screenshot) =================
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w800,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _labeledPillSmall({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _pillField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool dense = false,
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
        fillColor: _pillFill,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: dense ? 10 : 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _pillDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: _pillFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
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
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e, style: const TextStyle(fontSize: 12)),
            ),
          )
          .toList(),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Wajib dipilih';
        return null;
      },
      onChanged: onChanged,
    );
  }

  Widget _docPill({
    required String label,
    required IconData icon,
    required PlatformFile? file,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE3E3E3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black87),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    file?.name ?? 'Pilih file...',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: file == null ? Colors.black45 : Colors.green[700],
                      fontWeight: file == null
                          ? FontWeight.w500
                          : FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _primaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryBtn,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// =======================================================
/// HALAMAN BERHASIL DIKIRIM (tetap, tapi dibuat lebih “card style”)
/// =======================================================
class PengajuanPindahDomisiliBerhasilScreen extends StatelessWidget {
  final String namaKepala;
  final String nikKepala;
  final String alasanPindah;
  final String alamatAsal;
  final String alamatTujuan;

  const PengajuanPindahDomisiliBerhasilScreen({
    super.key,
    required this.namaKepala,
    required this.nikKepala,
    required this.alasanPindah,
    required this.alamatAsal,
    required this.alamatTujuan,
  });

  static const Color _bg = Color(0xFFF5F5F5);
  static const Color _primaryBtn = Color(0xFF2E37FF);
  static const List<Color> _grad = [Color(0xFF0072FF), Color(0xFF00C6FF)];

  @override
  Widget build(BuildContext context) {
    final tanggalPengajuan =
        '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 210,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: _grad,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 6, 12, 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 2),
                      const Expanded(
                        child: Text(
                          'Pengajuan Berhasil Dikirim',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
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
                              _row('Nama kepala keluarga', namaKepala),
                              _row('NIK kepala keluarga', nikKepala),
                              _row('Alasan pindah', alasanPindah),
                              _row('Alamat Asal', alamatAsal),
                              _row('Alamat Tujuan', alamatTujuan),
                              _row('Tanggal Pengajuan', tanggalPengajuan),
                              _row('Status Pengajuan', 'Sedang diverifikasi'),
                              const SizedBox(height: 10),
                              const Text(
                                'Permohonan sedang diverifikasi petugas, proses biasanya membutuhkan waktu 3–6 hari kerja.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryBtn,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/notifications');
                            },
                            child: const Text(
                              'Cek Notifikasi',
                              style: TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              '$label :',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              value,
              style: const TextStyle(fontSize: 12.5, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
