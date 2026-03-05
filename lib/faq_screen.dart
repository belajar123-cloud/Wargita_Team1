import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const FaqScreen({super.key, this.onBack});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  String selectedRole = "Warga";
  final TextEditingController searchController = TextEditingController();

  final Map<String, List<Map<String, String>>> faqData = {
    "Warga": [
      {
        "question": "Apa itu Wargita?",
        "answer":
            "Wargita adalah aplikasi pelayanan digital untuk mempermudah pengajuan administrasi warga.",
      },
      {
        "question": "Bagaimana cara mendaftar akun Wargita?",
        "answer": "Silakan klik daftar dan isi data sesuai identitas Anda.",
      },
      {
        "question": "Bagaimana cara mengajukan pencetakan KTP-el?",
        "answer": "Masuk ke menu layanan, pilih KTP-el, lalu lengkapi dokumen.",
      },
      {
        "question": "Bagaimana cara melihat status pengajuan saya?",
        "answer": "Anda dapat melihat status di menu Riwayat Pengajuan.",
      },
      {
        "question": "Apa yang harus saya lakukan jika data salah?",
        "answer": "Silakan ajukan perbaikan data melalui menu layanan.",
      },
      {
        "question": "Apakah data saya aman di Wargita?",
        "answer": "Ya, sistem menggunakan keamanan dan enkripsi data.",
      },
    ],
    "Sekretaris": [
      {
        "question": "Apa tugas Sekretaris Kelurahan di aplikasi Wargita?",
        "answer":
            "Sekretaris bertugas memverifikasi pengajuan sebelum diteruskan.",
      },
      {
        "question": "Bagaimana cara melihat daftar pengajuan yang masuk?",
        "answer": "Masuk ke menu Pengajuan Masuk.",
      },
      {
        "question": "Apakah Sekretaris bisa mengembalikan pengajuan?",
        "answer": "Ya, jika data tidak lengkap dapat dikembalikan ke warga.",
      },
      {
        "question": "Bagaimana alur setelah memverifikasi?",
        "answer": "Pengajuan diteruskan ke Kepala Kelurahan untuk persetujuan.",
      },
    ],
    "Kepala": [
      {
        "question": "Apa peran Kepala Kelurahan di aplikasi Wargita?",
        "answer": "Kepala bertugas menyetujui atau menolak pengajuan.",
      },
      {
        "question": "Bagaimana cara menyetujui pengajuan?",
        "answer": "Buka detail pengajuan lalu klik tombol Setujui.",
      },
      {
        "question": "Apakah Kepala bisa menolak pengajuan?",
        "answer": "Ya, dapat memberikan catatan penolakan.",
      },
      {
        "question": "Apakah bisa melihat statistik layanan?",
        "answer": "Ya, tersedia dashboard statistik layanan.",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final filteredFaq = faqData[selectedRole]!
        .where(
          (item) => item["question"]!.toLowerCase().contains(
            searchController.text.toLowerCase(),
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "FAQ Wargita",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Pilih peran terlebih dahulu, lalu lihat pertanyaan yang sering muncul.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  _buildRoleSelector(),
                  const SizedBox(height: 16),
                  _buildSearchField(),
                  const SizedBox(height: 16),
                  ...filteredFaq.map(
                    (faq) => _buildFaqItem(faq["question"]!, faq["answer"]!),
                  ),
                  const SizedBox(height: 24),
                  _buildHelpSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 55, left: 16, right: 16, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (widget.onBack != null) {
                widget.onBack!(); // kembali ke Home (Dashboard)
              } else {
                Navigator.pop(context);
              }
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            "FAQ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ================= ROLE SELECTOR =================
  Widget _buildRoleSelector() {
    return Row(
      children: ["Warga", "Sekretaris", "Kepala"].map((role) {
        bool isSelected = selectedRole == role;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedRole = role;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1E88E5)
                    : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  if (isSelected)
                    const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(Icons.check, size: 16, color: Colors.white),
                    ),
                  Text(
                    role,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: searchController,
        onChanged: (_) => setState(() {}),
        decoration: const InputDecoration(
          hintText: "Cari pertanyaan (misal: KTP, KK, status)",
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEFF5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Butuh bantuan lebih lanjut?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Jika FAQ belum menjawab kebutuhan Anda, silakan hubungi petugas kelurahan melalui WhatsApp resmi.",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {},
              child: const Text(
                "Hubungi via WhatsApp",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
