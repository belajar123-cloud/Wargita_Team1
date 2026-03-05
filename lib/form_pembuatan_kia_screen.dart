import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wargita_app/notification_screen.dart';

/// =====================
/// PAGE 1 – FORM KIA
/// (DESAIN: header gradient + card putih)
/// =====================
class FormPembuatanKiaScreen extends StatefulWidget {
  const FormPembuatanKiaScreen({super.key});

  @override
  State<FormPembuatanKiaScreen> createState() => _FormPembuatanKiaScreenState();
}

class _FormPembuatanKiaScreenState extends State<FormPembuatanKiaScreen> {
  final _formKey = GlobalKey<FormState>();

  // controller form
  final TextEditingController _namaAnakController = TextEditingController();
  final TextEditingController _nikAnakController = TextEditingController();
  final TextEditingController _ttlAnakController = TextEditingController();
  final TextEditingController _namaOrtuController = TextEditingController();
  final TextEditingController _nikOrtuController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  String? _jenisKelamin;

  // dokumen
  PlatformFile? _fileAktaLahir;
  PlatformFile? _fileKk;
  PlatformFile? _fileFotoAnak;

  @override
  void dispose() {
    _namaAnakController.dispose();
    _nikAnakController.dispose();
    _ttlAnakController.dispose();
    _namaOrtuController.dispose();
    _nikOrtuController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  // ===== VALIDASI NIK: wajib 16 digit angka =====
  String? _validateNik(String? v) {
    final nik = (v ?? '').trim();
    if (nik.isEmpty) return 'Wajib diisi';
    if (nik.length != 16 || !RegExp(r'^[0-9]+$').hasMatch(nik)) {
      return 'NIK harus 16 digit angka';
    }
    return null;
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
      if (jenis == 'akta') {
        _fileAktaLahir = file;
      } else if (jenis == 'kk') {
        _fileKk = file;
      } else if (jenis == 'foto') {
        _fileFotoAnak = file;
      }
    });
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    // validasi dokumen wajib
    if (_fileAktaLahir == null || _fileKk == null || _fileFotoAnak == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon upload Akta Lahir, KK, dan Foto Anak.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PengajuanKiaBerhasilScreen(
          namaAnak: _namaAnakController.text.trim(),
          nikAnak: _nikAnakController.text.trim(),
          ttlAnak: _ttlAnakController.text.trim(),
          jenisKelamin: _jenisKelamin ?? '-',
          namaOrangTua: _namaOrtuController.text.trim(),
          nikOrangTua: _nikOrtuController.text.trim(),
          alamat: _alamatController.text.trim(),
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
            // header gradient background
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
                  // top bar (back + title)
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
                            'Form Pengajuan Pembuatan KIA',
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

                  // card putih isi form
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
                              _label('Nama lengkap anak'),
                              _field(
                                controller: _namaAnakController,
                                hint: 'Isi nama lengkap...',
                              ),
                              const SizedBox(height: 12),
                              _label('NIK anak'),
                              _field(
                                controller: _nikAnakController,
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
                                controller: _ttlAnakController,
                                hint: 'Isi wilayah tempat dan tanggal lahir...',
                              ),
                              const SizedBox(height: 12),
                              _label('Jenis kelamin'),
                              _dropdown(
                                value: _jenisKelamin,
                                hint: 'Pilih jenis kelamin...',
                                items: const ['Laki-laki', 'Perempuan'],
                                onChanged: (v) =>
                                    setState(() => _jenisKelamin = v),
                                validator: (v) {
                                  if ((v ?? '').trim().isEmpty)
                                    return 'Wajib dipilih';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              _label('Nama orang tua'),
                              _field(
                                controller: _namaOrtuController,
                                hint: 'Isi nama lengkap...',
                              ),
                              const SizedBox(height: 12),
                              _label('NIK orang tua'),
                              _field(
                                controller: _nikOrtuController,
                                hint: 'Isi NIK dengan benar...',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(16),
                                ],
                                validator: _validateNik,
                              ),
                              const SizedBox(height: 12),
                              _label('Alamat lengkap'),
                              _field(
                                controller: _alamatController,
                                hint: 'Isi alamat lengkap rumah...',
                                maxLines: 2,
                              ),
                              const SizedBox(height: 16),
                              _label('Upload dokumen pendukung'),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  _docTile(
                                    label: 'Akta lahir',
                                    icon: Icons.description_outlined,
                                    file: _fileAktaLahir,
                                    onTap: () => _pickDokumen('akta'),
                                  ),
                                  const SizedBox(width: 10),
                                  _docTile(
                                    label: 'Kartu keluarga',
                                    icon: Icons.featured_play_list_outlined,
                                    file: _fileKk,
                                    onTap: () => _pickDokumen('kk'),
                                  ),
                                  const SizedBox(width: 10),
                                  _docTile(
                                    label: 'Foto anak',
                                    icon: Icons.photo_camera_outlined,
                                    file: _fileFotoAnak,
                                    onTap: () => _pickDokumen('foto'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
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
                                  onPressed: _onSubmit,
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
      validator: validator ??
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
          horizontal: 16,
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

/// =====================
/// PAGE 2 – BERHASIL
/// (DESAIN: header gradient + card putih)
/// =====================
class PengajuanKiaBerhasilScreen extends StatelessWidget {
  final String namaAnak;
  final String nikAnak;
  final String ttlAnak;
  final String jenisKelamin;
  final String namaOrangTua;
  final String nikOrangTua;
  final String alamat;

  const PengajuanKiaBerhasilScreen({
    super.key,
    required this.namaAnak,
    required this.nikAnak,
    required this.ttlAnak,
    required this.jenisKelamin,
    required this.namaOrangTua,
    required this.nikOrangTua,
    required this.alamat,
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
                            _row('Nama lengkap anak', namaAnak),
                            _row('NIK anak', nikAnak),
                            _row('Tempat & tanggal lahir', ttlAnak),
                            _row('Jenis kelamin', jenisKelamin),
                            _row('Nama orang tua', namaOrangTua),
                            _row('NIK orang tua', nikOrangTua),
                            _row('Alamat lengkap', alamat),
                            _row('Tanggal pengajuan', tanggalPengajuan),
                            _row('Status pengajuan', 'Sedang diverifikasi'),
                            const SizedBox(height: 8),
                            const Text(
                              'Permohonan kamu sedang diverifikasi oleh petugas. '
                              'Proses biasanya membutuhkan waktu 3–6 hari kerja.',
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
      bottomNavigationBar: const _BottomNavIdentitasSelected(),
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

/// Bottom nav identitas aktif – tanpa item (hanya bar putih bawah)
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
