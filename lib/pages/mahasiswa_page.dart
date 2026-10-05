import 'package:flutter/material.dart';
import '../models/mahasiswa_model.dart';
import '../models/user_model.dart';
import '../theme/app_colors.dart';

class MahasiswaPage extends StatefulWidget {
  final BaseUser currentUser;

  const MahasiswaPage({
    super.key,
    required this.currentUser,
  });

  @override
  State<MahasiswaPage> createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  late List<MahasiswaModel> _daftarMahasiswa;
  String _searchQuery = '';
  bool _onlyCumLaude = false;

  @override
  void initState() {
    super.initState();
    _initDataset();
  }

  // ===========================================================================
  // FITUR 2 — FUNCTIONS (FUNGSI & METODE)
  // ===========================================================================

  /// Function 1 — Inisialisasi dataset awal mahasiswa
  void _initDataset() {
    _daftarMahasiswa = [
      MahasiswaModel(
        nim: '2024010001',
        nama: 'Budi Santoso',
        email: 'budi.santoso@kampus.ac.id',
        jurusan: 'Teknik Informatika',
        semester: 6,
        ipk: 3.92,
        totalSks: 110,
        keahlian: ['Flutter', 'Dart', 'PBO', 'REST API'],
        nilaiMataKuliah: {
          'Pemrograman Berorientasi Objek': 95.0,
          'Struktur Data': 90.0,
          'Basis Data': 88.0,
        },
      ),
      MahasiswaModel(
        nim: '2024010002',
        nama: 'Siti Rahayu',
        email: 'siti.rahayu@kampus.ac.id',
        jurusan: 'Sistem Informasi',
        semester: 5,
        ipk: 3.75,
        totalSks: 95,
        keahlian: ['UI/UX Design', 'Figma', 'Flutter'],
        nilaiMataKuliah: {
          'Pemrograman Berorientasi Objek': 91.0,
          'Desain Sistem': 93.0,
          'Basis Data': 85.0,
        },
      ),
      MahasiswaModel(
        nim: '2024010003',
        nama: 'Wishang',
        email: 'wishang@kampus.ac.id',
        jurusan: 'Teknik Informatika',
        semester: 7,
        ipk: 3.85,
        totalSks: 128,
        keahlian: ['Dart', 'Go', 'DevOps', 'Clean Architecture'],
        nilaiMataKuliah: {
          'Pemrograman Berorientasi Objek': 97.0,
          'Rekayasa Perangkat Lunak': 94.0,
          'Jaringan Komputer': 89.0,
        },
      ),
      MahasiswaModel(
        nim: '2024010004',
        nama: 'Dewi Permata',
        email: 'dewi.permata@kampus.ac.id',
        jurusan: 'Sistem Informasi',
        semester: 4,
        ipk: 3.40,
        totalSks: 72,
        keahlian: ['Python', 'Data Science', 'SQL'],
        nilaiMataKuliah: {
          'Pemrograman Berorientasi Objek': 82.0,
          'Statistika': 87.0,
          'Basis Data': 80.0,
        },
      ),
      MahasiswaModel(
        nim: '2024010005',
        nama: 'Rizky Pratama',
        email: 'rizky.pratama@kampus.ac.id',
        jurusan: 'Teknik Informatika',
        semester: 3,
        ipk: 2.90,
        totalSks: 52,
        keahlian: ['Java', 'C++', 'Algoritma'],
        nilaiMataKuliah: {
          'Pemrograman Berorientasi Objek': 75.0,
          'Matematika Diskrit': 70.0,
          'Algoritma': 72.0,
        },
      ),
    ];
  }

  /// Function 2 — Hitung rata-rata IPK seluruh mahasiswa (menggunakan getter .ipk)
  double hitungRataRataIpk(List<MahasiswaModel> list) {
    if (list.isEmpty) return 0.0;
    final total = list.fold(0.0, (sum, m) => sum + m.ipk);
    return total / list.length;
  }

  /// Function 3 — Hitung persentase mahasiswa Cum Laude (menggunakan getter .isCumLaude)
  double hitungPersenCumLaude(List<MahasiswaModel> list) {
    if (list.isEmpty) return 0.0;
    final cumLaudeCount = list.where((m) => m.isCumLaude).length;
    return (cumLaudeCount / list.length) * 100.0;
  }

  /// Function 4 — Filter daftar berdasarkan pencarian & toggle Cum Laude
  List<MahasiswaModel> filterList() {
    return _daftarMahasiswa.where((m) {
      final q = _searchQuery.toLowerCase();
      final cocok = m.nama.toLowerCase().contains(q) ||
          m.nim.toLowerCase().contains(q) ||
          m.jurusan.toLowerCase().contains(q);
      final cumLaudeCheck = _onlyCumLaude ? m.isCumLaude : true;
      return cocok && cumLaudeCheck;
    }).toList();
  }

  /// Function 5 — Tambah mahasiswa baru ke list
  void _tambahMahasiswa({
    required String nim,
    required String nama,
    required String email,
    required String jurusan,
    required int semester,
    required double ipk,
    required int totalSks,
  }) {
    try {
      final mahasiswaBaru = MahasiswaModel(
        nim: nim,
        nama: nama,
        email: email,
        jurusan: jurusan,
        semester: semester,
        ipk: ipk,
        totalSks: totalSks,
      );
      setState(() => _daftarMahasiswa.insert(0, mahasiswaBaru));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Mahasiswa ${mahasiswaBaru.nama} berhasil ditambahkan!'),
          backgroundColor: AppColors.accent,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Gagal menambahkan: $e'),
          backgroundColor: AppColors.accentRose,
        ),
      );
    }
  }

  /// Function 6 — Update IPK & Semester menggunakan SETTER MahasiswaModel
  void _updateMahasiswaViaSetter(
    MahasiswaModel m, {
    required double ipkBaru,
    required int semesterBaru,
  }) {
    try {
      setState(() {
        m.ipk = ipkBaru;           // SETTER: set ipk(double value) — validasi 0.0 - 4.0
        m.semester = semesterBaru; // SETTER: set semester(int value) — validasi 1 - 14
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🎉 Data [${m.nim}] diperbarui via Setter. '
            'IPK: ${m.ipkFormatted} — ${m.predikatKelulusan}',
          ),
          backgroundColor: AppColors.secondary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Validasi Setter gagal: $e'),
          backgroundColor: AppColors.accentRose,
        ),
      );
    }
  }

  /// Function 7 — Hapus mahasiswa dari list
  void _hapusMahasiswa(int index) {
    final nama = _daftarMahasiswa[index].nama;
    setState(() => _daftarMahasiswa.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🗑️ Mahasiswa "$nama" dihapus dari katalog.'),
        backgroundColor: AppColors.bgCard,
      ),
    );
  }

  // ===========================================================================
  // BUILD METHOD UTAMA
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    final filtered = filterList();            // Function 4
    final rataIpk = hitungRataRataIpk(_daftarMahasiswa);  // Function 2
    final persenCL = hitungPersenCumLaude(_daftarMahasiswa); // Function 3

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildStatistikBar(rataIpk, persenCL),
          _buildCleanHeaderBanner(),
          Expanded(
            child: _buildListBuilderContent(filtered),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTambahDialog(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add_rounded, color: Colors.white),
        label: const Text(
          'Tambah Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // APP BAR
  // ---------------------------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.bgSurface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
        tooltip: 'Kembali',
      ),
      title: const Row(
        children: [
          Icon(Icons.school_rounded, color: AppColors.primary, size: 22),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              'Katalog Mahasiswa',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: AppColors.textMuted),
          tooltip: 'Reset data mahasiswa',
          onPressed: () {
            setState(() {
              _initDataset();
              _searchQuery = '';
              _onlyCumLaude = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('♻️ Dataset direset ke kondisi awal.')),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER BANNER (CLEAN & MODERN)
  // ---------------------------------------------------------------------------
  Widget _buildCleanHeaderBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: const Icon(Icons.school_rounded, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Katalog Akademik Mahasiswa',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Kelola profil, riwayat IPK, dan data mahasiswa secara terstruktur.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STATISTIK BAR
  // ---------------------------------------------------------------------------
  Widget _buildStatistikBar(double rataIpk, double persenCL) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withOpacity(0.7),
        border: const Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildStatChip(
              'Total Mahasiswa',
              '${_daftarMahasiswa.length}',
              Icons.people_rounded,
              AppColors.primary,
            ),
            const SizedBox(width: 12),
            _buildStatChip(
              'Rata-rata IPK',
              rataIpk.toStringAsFixed(2),
              Icons.bar_chart_rounded,
              AppColors.accent,
            ),
            const SizedBox(width: 12),
            _buildStatChip(
              'Cum Laude',
              '${persenCL.toStringAsFixed(0)}%',
              Icons.emoji_events_rounded,
              AppColors.secondary,
            ),
            const SizedBox(width: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Hanya Cum Laude:',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(width: 6),
                Switch(
                  value: _onlyCumLaude,
                  activeColor: AppColors.secondary,
                  onChanged: (val) => setState(() => _onlyCumLaude = val),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
              Text(
                value,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // FITUR 1 — LISTVIEW.BUILDER
  // ===========================================================================
  Widget _buildListBuilderContent(List<MahasiswaModel> items) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: TextField(
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Cari nama, NIM, atau jurusan...',
              hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textMuted),
                      onPressed: () => setState(() => _searchQuery = ''),
                    )
                  : null,
              filled: true,
              fillColor: AppColors.bgSurface,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.glassBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.glassBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
        ),

        // Info Jumlah Item
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(
            children: [
              const Icon(Icons.list_alt_rounded, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'ListView.builder — ${items.length} mahasiswa ditampilkan',
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ),

        // ListView.builder
        Expanded(
          child: items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted),
                      const SizedBox(height: 12),
                      const Text(
                        'Tidak ada data yang cocok.',
                        style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => setState(() {
                          _searchQuery = '';
                          _onlyCumLaude = false;
                        }),
                        child: const Text('Reset Filter'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final mahasiswa = items[index];
                    final fullIndex = _daftarMahasiswa.indexOf(mahasiswa);
                    return _AnimatedCardEntrance(
                      index: index,
                      child: _buildMahasiswaCard(mahasiswa, fullIndex),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // KARTU MAHASISWA (CLEAN & MODERN) — menggunakan GETTER dari MahasiswaModel
  // ---------------------------------------------------------------------------
  Widget _buildMahasiswaCard(MahasiswaModel m, int fullIndex) {
    // FITUR 3: Mengakses data via GETTER (bukan field langsung)
    final nim          = m.nim;               // getter .nim
    final nama         = m.nama;              // getter .nama
    final email        = m.email;             // getter .email
    final jurusan      = m.jurusan;           // getter .jurusan
    final semester     = m.semester;          // getter .semester
    final ipkFmt       = m.ipkFormatted;      // computed getter .ipkFormatted
    final predikat     = m.predikatKelulusan; // computed getter .predikatKelulusan
    final isCumLaude   = m.isCumLaude;        // computed getter .isCumLaude
    final sisaSks      = m.sisaSksLulus;      // computed getter .sisaSksLulus
    final keahlianList = m.keahlian;          // getter .keahlian (unmodifiable list)

    final statusColor = isCumLaude ? const Color(0xFFF59E0B) : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCumLaude
              ? const Color(0xFFF59E0B).withOpacity(0.5)
              : AppColors.glassBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar, Nama, NIM, Cum Laude, Menu
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: statusColor.withOpacity(0.18),
                  child: Text(
                    nama.isNotEmpty ? nama[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                      color: statusColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              nama,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isCumLaude) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B).withOpacity(0.18),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.5)),
                              ),
                              child: const Text(
                                '🏆 Cum Laude',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFF59E0B),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'NIM: $nim  •  $jurusan',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Action Menu
                PopupMenuButton<String>(
                  color: AppColors.bgCard,
                  icon: const Icon(Icons.more_vert_rounded, color: AppColors.textMuted),
                  onSelected: (val) {
                    if (val == 'edit') _showEditDialog(m);
                    if (val == 'laporan') _showLaporanDialog(m);
                    if (val == 'hapus') _hapusMahasiswa(fullIndex);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('✏️  Edit via Setter')),
                    PopupMenuItem(value: 'laporan', child: Text('📊  Lihat Laporan')),
                    PopupMenuItem(
                      value: 'hapus',
                      child: Text('🗑️  Hapus', style: TextStyle(color: AppColors.accentRose)),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(color: AppColors.glassBorder, height: 1),
            const SizedBox(height: 12),

            // Info Akademik Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _infoChip('Sem. $semester', Icons.calendar_today_rounded, AppColors.primaryLight),
                _infoChip('IPK $ipkFmt', Icons.grade_rounded, statusColor),
                _infoChip(predikat, Icons.military_tech_rounded, statusColor),
                _infoChip('Sisa SKS: $sisaSks', Icons.checklist_rounded, AppColors.accentAmber),
              ],
            ),

            const SizedBox(height: 10),

            // Email
            Row(
              children: [
                const Icon(Icons.email_rounded, size: 13, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    email,
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Keahlian (dari getter .keahlian)
            Wrap(
              spacing: 6,
              runSpacing: 5,
              children: keahlianList
                  .take(4)
                  .map((skill) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                        ),
                        child: Text(
                          skill,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 12),

            // Tombol Aksi Cepat
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _showLaporanDialog(m),
                  icon: const Icon(Icons.bar_chart_rounded, size: 14),
                  label: const Text('Laporan', style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.glassBorder),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showEditDialog(m),
                  icon: const Icon(Icons.edit_rounded, size: 14),
                  label: const Text('Edit Setter', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DIALOG: Tambah Mahasiswa
  // ---------------------------------------------------------------------------
  void _showTambahDialog() {
    final nimCtrl = TextEditingController();
    final namaCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final jurusanCtrl = TextEditingController(text: 'Teknik Informatika');
    final semCtrl = TextEditingController(text: '1');
    final ipkCtrl = TextEditingController(text: '3.00');
    final sksCtrl = TextEditingController(text: '20');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('➕ Tambah Mahasiswa Baru',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogField(nimCtrl, 'NIM', 'Misal: 2024010006'),
                _dialogField(namaCtrl, 'Nama Lengkap', 'Misal: Rina Sari'),
                _dialogField(emailCtrl, 'Email', 'nama@kampus.ac.id'),
                _dialogField(jurusanCtrl, 'Jurusan', 'Teknik Informatika'),
                _dialogField(semCtrl, 'Semester', '1 - 14',
                    keyboardType: TextInputType.number),
                _dialogField(ipkCtrl, 'IPK', '0.00 - 4.00',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                _dialogField(sksCtrl, 'Total SKS', 'Misal: 20',
                    keyboardType: TextInputType.number),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(ctx);
              _tambahMahasiswa(
                nim: nimCtrl.text,
                nama: namaCtrl.text,
                email: emailCtrl.text,
                jurusan: jurusanCtrl.text,
                semester: int.tryParse(semCtrl.text) ?? 1,
                ipk: double.tryParse(ipkCtrl.text) ?? 0.0,
                totalSks: int.tryParse(sksCtrl.text) ?? 0,
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DIALOG: Edit Mahasiswa via SETTER
  // ---------------------------------------------------------------------------
  void _showEditDialog(MahasiswaModel m) {
    final ipkCtrl = TextEditingController(text: m.ipkFormatted); // getter
    final semCtrl = TextEditingController(text: '${m.semester}'); // getter

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('✏️ Edit Data: ${m.nama}', // getter .nama
            style: const TextStyle(fontWeight: FontWeight.w800)),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Perubahan diproses via SETTER dengan validasi otomatis.\n'
                'IPK: 0.00 – 4.00 | Semester: 1 – 14',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 14),
              _dialogField(ipkCtrl, 'IPK Baru', '0.00 - 4.00',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true)),
              _dialogField(semCtrl, 'Semester Baru', '1 - 14',
                  keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
            onPressed: () {
              Navigator.pop(ctx);
              _updateMahasiswaViaSetter(
                m,
                ipkBaru: double.tryParse(ipkCtrl.text) ?? m.ipk,
                semesterBaru: int.tryParse(semCtrl.text) ?? m.semester,
              );
            },
            child: const Text('Simpan via Setter',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DIALOG: Laporan Mahasiswa
  // ---------------------------------------------------------------------------
  void _showLaporanDialog(MahasiswaModel m) {
    final laporan = m.evaluasiKelayakanSkripsi(); // method dari MahasiswaModel

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('📊 Laporan Akademik: ${m.nama}',
            style: const TextStyle(fontWeight: FontWeight.w800)),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _laporanRow('NIM', m.nim),
                _laporanRow('Jurusan', m.jurusan),
                _laporanRow('Email', m.email),
                _laporanRow('Semester', '${m.semester}'),
                _laporanRow('IPK', '${m.ipkFormatted} — ${m.predikatKelulusan}'),
                _laporanRow('Total SKS', '${m.totalSks} SKS (Sisa: ${m.sisaSksLulus})'),
                _laporanRow('Progress Lulus', '${m.persentaseKelulusan.toStringAsFixed(1)}%'),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Text(
                    laporan,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondary,
                        height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _laporanRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _dialogField(
    TextEditingController ctrl,
    String label,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          filled: true,
          fillColor: AppColors.bgCard,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.glassBorder)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.glassBorder)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary)),
        ),
      ),
    );
  }
}

// =============================================================================
// WIDGET ANIMASI RINGAN: Slide + Fade Entrance per Kartu
// =============================================================================
class _AnimatedCardEntrance extends StatefulWidget {
  final int index;
  final Widget child;

  const _AnimatedCardEntrance({
    required this.index,
    required this.child,
  });

  @override
  State<_AnimatedCardEntrance> createState() => _AnimatedCardEntranceState();
}

class _AnimatedCardEntranceState extends State<_AnimatedCardEntrance>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: 40 * (widget.index % 8)), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}
