import 'package:flutter/material.dart';

class RiwayatKelurahanSection extends StatefulWidget {
  const RiwayatKelurahanSection({super.key, required Null Function() onBack});

  @override
  State<RiwayatKelurahanSection> createState() =>
      _RiwayatKelurahanSectionState();
}

class _RiwayatKelurahanSectionState extends State<RiwayatKelurahanSection> {
  final List<Map<String, String>> _riwayat = [
    {
      "judul": "Pengajuan Surat Domisili",
      "tanggal": "11 Feb 2025",
      "status": "Selesai",
    },
    {
      "judul": "Surat Pengantar KTP",
      "tanggal": "10 Feb 2025",
      "status": "Diproses",
    },
    {
      "judul": "Surat Keterangan Usaha",
      "tanggal": "08 Feb 2025",
      "status": "Ditolak",
    },
  ];

  String _search = "";

  @override
  Widget build(BuildContext context) {
    final filtered = _riwayat
        .where((e) => e["judul"]!.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: Container(
        color: const Color(0xFFF5F5F5),
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return _buildCard(filtered[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: const Text(
        "Riwayat Layanan",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ================= SEARCH =================
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (value) => setState(() => _search = value),
        decoration: InputDecoration(
          hintText: "Cari riwayat...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ================= CARD =================
  Widget _buildCard(Map<String, String> item) {
    final status = item["status"]!;
    final color = _statusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        leading: CircleAvatar(
          radius: 22,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(Icons.description_outlined, color: color),
        ),

        title: Text(
          item["judul"]!,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            item["tanggal"]!,
            style: const TextStyle(color: Colors.grey),
          ),
        ),

        trailing: _statusBadge(status, color),
      ),
    );
  }

  // ================= BADGE =================
  Widget _statusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // ================= EMPTY =================
  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "Belum ada riwayat",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // ================= COLOR HELPER =================
  Color _statusColor(String status) {
    switch (status) {
      case "Selesai":
        return Colors.green;
      case "Diproses":
        return Colors.orange;
      case "Ditolak":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
