import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'notification_screen.dart';

/// =======================================
/// PAGE 1 – FORM PEMBUATAN AKTE KELAHIRAN
/// (DESAIN: header gradient + card putih)
/// =======================================
class FormPembuatanAktaKelahiranScreen extends StatefulWidget {
  const FormPembuatanAktaKelahiranScreen({super.key});

  @override
  State<FormPembuatanAktaKelahiranScreen> createState() =>
      _FormPembuatanAktaKelahiranScreenState();
}

class _FormPembuatanAktaKelahiranScreenState
    extends State<FormPembuatanAktaKelahiranScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaAyahController = TextEditingController();
  final TextEditingController _namaIbuController = TextEditingController();
  final TextEditingController _namaAnakController = TextEditingController();
  final TextEditingController _tempatTanggalLahirController =
      TextEditingController();

  // file dokumen
  PlatformFile? _fileKtp;
  PlatformFile? _fileKk;
  PlatformFile? _fileAktaNikah;
  PlatformFile? _fileSuratRs;

  @override
  void dispose() {
    _namaAyahController.dispose();
    _namaIbuController.dispose();
    _namaAnakController.dispose();
    _tempatTanggalLahirController.dispose();
    super.dispose();
  }

  // ---------- PILIH DOKUMEN ----------
  Future<void> _pickDokumen(String jenis) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: true,
    );

    if (result == null) return;

    final file = result.files.single;
    setState(() {
      switch (jenis) {
        case 'ktp':
          _fileKtp = file;
          break;
        case 'kk':
          _fileKk = file;
          break;
        case 'akta_nikah':
          _fileAktaNikah = file;
          break;
        case 'surat_rs':
          _fileSuratRs = file;
          break;
      }
    });
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    // validasi dokumen (biar lebih “lengkap” dan logis)
    if (_fileKtp == null ||
        _fileKk == null ||
        _fileAktaNikah == null ||
        _fileSuratRs == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Mohon upload semua dokumen pendukung terlebih dahulu.',
          ),
        ),
      );
      return;
    }

    final tanggalPengajuan =
        '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PengajuanAktaKelahiranBerhasilScreen(
          namaAnak: _namaAnakController.text.trim(),
          tempatTanggalLahir: _tempatTanggalLahirController.text.trim(),
          namaAyah: _namaAyahController.text.trim(),
          namaIbu: _namaIbuController.text.trim(),
          tanggalPengajuan: tanggalPengajuan,
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
                            'Form Pembuatan Akte Kelahiran',
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
                              _label('Nama ayah'),
                              _field(
                                controller: _namaAyahController,
                                hint: 'Isi nama lengkap ...',
                              ),
                              const SizedBox(height: 12),

                              _label('Nama ibu'),
                              _field(
                                controller: _namaIbuController,
                                hint: 'Isi nama lengkap ...',
                              ),
                              const SizedBox(height: 12),

                              _label('Nama anak'),
                              _field(
                                controller: _namaAnakController,
                                hint: 'Isi nama lengkap ...',
                              ),
                              const SizedBox(height: 12),

                              _label('Tempat dan tanggal lahir'),
                              _field(
                                controller: _tempatTanggalLahirController,
                                hint: 'Isi wilayah tempat dan tanggal lahir...',
                              ),
                              const SizedBox(height: 18),

                              _label('Upload dokumen pendukung'),
                              const SizedBox(height: 10),

                              // baris 1: 3 dokumen
                              Row(
                                children: [
                                  _docTile(
                                    label: 'KTP',
                                    icon: Icons.credit_card,
                                    jenis: 'ktp',
                                    file: _fileKtp,
                                  ),
                                  const SizedBox(width: 8),
                                  _docTile(
                                    label: 'Kartu keluarga',
                                    icon: Icons.featured_play_list_outlined,
                                    jenis: 'kk',
                                    file: _fileKk,
                                  ),
                                  const SizedBox(width: 8),
                                  _docTile(
                                    label: 'Akta nikah',
                                    icon: Icons.favorite_border,
                                    jenis: 'akta_nikah',
                                    file: _fileAktaNikah,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // baris 2: 1 dokumen full
                              Row(
                                children: [
                                  Expanded(
                                    child: _docTile(
                                      label: 'Surat keterangan\nRumah sakit',
                                      icon: Icons.local_hospital,
                                      jenis: 'surat_rs',
                                      file: _fileSuratRs,
                                      isFull: true,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              // tombol di dalam card
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
      ),
    );
  }

  // ---------- helper UI ----------
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
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (v) {
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

  Widget _docTile({
    required String label,
    required IconData icon,
    required String jenis,
    required PlatformFile? file,
    bool isFull = false,
  }) {
    return Expanded(
      flex: isFull ? 1 : 1,
      child: InkWell(
        onTap: () => _pickDokumen(jenis),
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

/// =======================================
/// PAGE 2 – PENGAJUAN BERHASIL DIKIRIM
/// (DESAIN: header gradient + card putih)
/// =======================================
class PengajuanAktaKelahiranBerhasilScreen extends StatelessWidget {
  final String namaAnak;
  final String tempatTanggalLahir;
  final String namaAyah;
  final String namaIbu;
  final String tanggalPengajuan;

  const PengajuanAktaKelahiranBerhasilScreen({
    super.key,
    required this.namaAnak,
    required this.tempatTanggalLahir,
    required this.namaAyah,
    required this.namaIbu,
    required this.tanggalPengajuan,
  });

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
                            _row('Nama lengkap Anak', namaAnak),
                            _row('Tempat & Tanggal lahir', tempatTanggalLahir),
                            _row('Nama Ayah', namaAyah),
                            _row('Nama Ibu', namaIbu),
                            _row('Tanggal Pengajuan', tanggalPengajuan),
                            _row('Status pengajuan', 'Sedang diverifikasi'),
                            const SizedBox(height: 8),
                            const Text(
                              'Permohonan sedang di verifikasi, proses estimasi '
                              'membutuhkan waktu 3–6 hari kerja.',
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
