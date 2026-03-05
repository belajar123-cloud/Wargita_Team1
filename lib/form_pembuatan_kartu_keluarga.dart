import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FormKartuKeluargaScreen extends StatefulWidget {
  const FormKartuKeluargaScreen({super.key});

  @override
  State<FormKartuKeluargaScreen> createState() =>
      _FormKartuKeluargaScreenState();
}

class _FormKartuKeluargaScreenState extends State<FormKartuKeluargaScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0; // 0 = KK, 1 = A1, 2 = A2, 3 = A3, 4 = Ringkasan

  // data kepala keluarga
  String namaKepala = '';
  String nikKepala = '';
  String alamat = '';
  String kecamatan = '';
  String kelurahan = '';
  String rt = '';
  String rw = '';
  String pekerjaanKepala = '';
  String jumlahAnggota = '';

  // data anggota keluarga
  final List<_AnggotaKeluarga> anggota = List.generate(
    3,
    (_) => _AnggotaKeluarga(),
  );

  // ---------- FILE DOKUMEN YANG DIPILIH ----------
  PlatformFile? _fileKtp;
  PlatformFile? _fileAktaLahir;
  PlatformFile? _fileAktaNikah;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ---------- FUNGSI PILIH DOKUMEN ----------
  Future<void> _pickDokumen(String jenis) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: true,
    );

    if (result == null) return; // user batal pilih file

    setState(() {
      final file = result.files.single;
      if (jenis == 'ktp') {
        _fileKtp = file;
      } else if (jenis == 'akta_lahir') {
        _fileAktaLahir = file;
      } else if (jenis == 'akta_nikah') {
        _fileAktaNikah = file;
      }
    });
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextStep() {
    if (_currentStep < 4) {
      _goToStep(_currentStep + 1);
    }
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      body: Stack(
        children: [
          // ======= BACKGROUND BIRU LEBAR DI ATAS =======
          Container(
            height: 230, // atur tinggi biru sesuai kebutuhan
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ======= KONTEN DI ATAS BACKGROUND =======
          SafeArea(
            child: Column(
              children: [
                // TOP BAR: BACK + TITLE
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
                        'Form Pembuatan KK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                _buildStepIndicator(),
                const SizedBox(height: 8),

                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildPageKepalaKeluarga(),
                      _buildPageAnggota(0, 'Nama Anggota Keluarga 1'),
                      _buildPageAnggota(1, 'Nama Anggota Keluarga 2'),
                      _buildPageAnggota(2, 'Nama Anggota Keluarga 3'),
                      _buildPageRingkasan(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ---------------- STEP INDICATOR ----------------
  Widget _buildStepIndicator() {
    final labels = ['KK', 'A1', 'A2', 'A3', 'Ringkasan'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: const Offset(0, 4),
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(labels.length, (index) {
            final isActive = index == _currentStep;
            return Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  height: isActive ? 26 : 22,
                  width: isActive ? 26 : 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? const Color(0xFF0072FF)
                        : Colors.grey.shade300,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.black54,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 11,
                    color: isActive
                        ? const Color(0xFF0072FF)
                        : Colors.grey.shade600,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // ---------------- PAGE 1: KEPALA KELUARGA ----------------
  Widget _buildPageKepalaKeluarga() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderTile('Form Pembuatan Kartu Keluarga'),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Nama Kepala Keluarga',
              onChanged: (v) => namaKepala = v,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'NIK Kepala Keluarga',
              keyboardType: TextInputType.number,
              onChanged: (v) => nikKepala = v,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'Alamat Lengkap',
              maxLines: 2,
              onChanged: (v) => alamat = v,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'Kecamatan',
              onChanged: (v) => kecamatan = v,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'Kelurahan',
              onChanged: (v) => kelurahan = v,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'RT',
                    keyboardType: TextInputType.number,
                    onChanged: (v) => rt = v,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTextField(
                    label: 'RW',
                    keyboardType: TextInputType.number,
                    onChanged: (v) => rw = v,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'Pekerjaan',
              onChanged: (v) => pekerjaanKepala = v,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'Jumlah Anggota Keluarga',
              keyboardType: TextInputType.number,
              onChanged: (v) => jumlahAnggota = v,
            ),
            const SizedBox(height: 18),
            _buildDokumenRow(),
            const SizedBox(height: 20),
            _buildPrimaryButton(text: 'Lanjut', onPressed: _nextStep),
          ],
        ),
      ),
    );
  }

  // ---------------- PAGE 2-4: ANGGOTA ----------------
  Widget _buildPageAnggota(int index, String titleField) {
    final data = anggota[index];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderTile('Form Pembuatan Kartu Keluarga'),
            const SizedBox(height: 16),
            _buildTextField(label: titleField, onChanged: (v) => data.nama = v),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'NIK Anggota',
              keyboardType: TextInputType.number,
              onChanged: (v) => data.nik = v,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'NIK Kepala Keluarga',
              keyboardType: TextInputType.number,
              onChanged: (v) => nikKepala = v,
            ),
            const SizedBox(height: 10),
            _buildDropdown(
              label: 'Jenis Kelamin',
              value: data.jenisKelamin.isEmpty ? null : data.jenisKelamin,
              items: const ['Laki-laki', 'Perempuan'],
              onChanged: (v) => setState(() => data.jenisKelamin = v ?? ''),
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'Pekerjaan',
              onChanged: (v) => data.pekerjaan = v,
            ),
            const SizedBox(height: 10),
            _buildDropdown(
              label: 'Status',
              value: data.status.isEmpty ? null : data.status,
              items: const ['Kepala Keluarga', 'Istri', 'Anak', 'Lainnya'],
              onChanged: (v) => setState(() => data.status = v ?? ''),
            ),
            const SizedBox(height: 18),
            _buildDokumenRow(),
            const SizedBox(height: 20),
            _buildPrimaryButton(
              text: index == 2 ? 'Kirim Permohonan' : 'Lanjut',
              onPressed: () {
                if (index == 2) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Permohonan Terkirim'),
                      content: const Text(
                        'Data permohonan KK tersimpan secara lokal.\n'
                        'Nanti bisa disambungkan ke backend Wargita.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            _nextStep();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  _nextStep();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- PAGE 5: RINGKASAN ----------------
  Widget _buildPageRingkasan() {
    // siapkan data untuk card ringkasan
    final dataKk = {
      'namaKk': namaKepala,
      'nikKk': nikKepala,
      'alamat': alamat,
      'kecamatan': kecamatan,
      'kelurahan': kelurahan,
      'rtRw': '$rt / $rw',
      'jumlahAnggota': jumlahAnggota,
    };

    final anggotaSummary = anggota
        .map(
          (a) => {
            'nama': a.nama,
            'nik': a.nik,
            'jk': a.jenisKelamin,
            'pekerjaan': a.pekerjaan,
            'status': a.status,
          },
        )
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderTile('Form Pembuatan Kartu Keluarga'),
            const SizedBox(height: 16),
            const Text(
              'Data Pembuatan Kartu Keluarga',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),

            // kotak abu-abu besar berisi ringkasan (seperti desain Figma)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: KkSummaryCard(dataKk: dataKk, anggota: anggotaSummary),
            ),

            const SizedBox(height: 24),
            _buildPrimaryButton(
              text: 'Cek Notifikasi',
              onPressed: () {
                // arahkan ke halaman notifikasi (route sudah ada di main.dart)
                Navigator.pushNamed(context, '/notifications');
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- BOTTOM NAV ----------------
  Widget _buildBottomNav() {
    // Bar putih saja, tanpa item menu
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, -2),
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ],
      ),
    );
  }

  // ---------------- HELPER UI ----------------
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 6),
            spreadRadius: 1,
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildHeaderTile(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: items
                  .map(
                    (e) => DropdownMenuItem<String>(value: e, child: Text(e)),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDokumenRow() {
    Widget docButton(
      String text,
      IconData icon,
      String jenis,
      PlatformFile? file,
    ) {
      return Expanded(
        child: InkWell(
          onTap: () => _pickDokumen(jenis),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEDED),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(fontSize: 11),
                  textAlign: TextAlign.center,
                ),
                if (file != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    file.name,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        docButton('KTP', Icons.credit_card, 'ktp', _fileKtp),
        docButton(
          'Akta Lahir',
          Icons.description_outlined,
          'akta_lahir',
          _fileAktaLahir,
        ),
        docButton(
          'Akta Nikah',
          Icons.favorite_border,
          'akta_nikah',
          _fileAktaNikah,
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          backgroundColor: const Color(0xFF3B3BFF),
          elevation: 2,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ===== MODEL DATA ANGGOTA =====
class _AnggotaKeluarga {
  String nama = '';
  String nik = '';
  String jenisKelamin = '';
  String pekerjaan = '';
  String status = '';
}

// ---------- CARD RINGKASAN KK (KOTAK ABU-ABU) ----------
class KkSummaryCard extends StatelessWidget {
  final Map<String, String> dataKk;
  final List<Map<String, String>> anggota;

  const KkSummaryCard({super.key, required this.dataKk, required this.anggota});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(26),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Data KK',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),

            _buildSectionTitle('Kepala Keluarga'),
            _buildRow('Nama KK', dataKk['namaKk'] ?? '-'),
            _buildRow('NIK KK', dataKk['nikKk'] ?? '-'),
            _buildRow('Alamat', dataKk['alamat'] ?? '-'),
            _buildRow('Kecamatan', dataKk['kecamatan'] ?? '-'),
            _buildRow('Kelurahan', dataKk['kelurahan'] ?? '-'),
            _buildRow('RT/RW', dataKk['rtRw'] ?? '-'),
            _buildRow('Jumlah Anggota', dataKk['jumlahAnggota'] ?? '-'),
            const SizedBox(height: 12),

            for (int i = 0; i < anggota.length; i++) ...[
              _buildSectionTitle('Anggota ${i + 1}'),
              _buildRow('Nama', anggota[i]['nama'] ?? '-'),
              _buildRow('NIK', anggota[i]['nik'] ?? '-'),
              _buildRow('Jenis Kelamin', anggota[i]['jk'] ?? '-'),
              _buildRow('Pekerjaan', anggota[i]['pekerjaan'] ?? '-'),
              _buildRow('Status', anggota[i]['status'] ?? '-'),
              const SizedBox(height: 6),
            ],
          ],
        ),
      ),
    );
  }

  static Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  static Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
