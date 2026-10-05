import 'dart:convert';

/// ============================================================================
/// BLUEPRINT ENTITAS: MahasiswaModel (Model Blueprint Objek Mahasiswa)
/// ============================================================================
/// Mengimplementasikan prinsip Pemrograman Berorientasi Objek (PBO) murni:
/// 1. Enkapsulasi: Seluruh atribut dideklarasikan sebagai privat (_field)
/// 2. Getter: Akses baca terkontrol & komputasi status secara dinamis
/// 3. Setter: Validasi data ketat dengan pengecekan aturan bisnis (Business Logic)
/// 4. Functions/Methods: Operasi manipulasi status objek, kalkulasi IPK, dan evaluasi
/// 5. Multiple Constructors: Default, Named Constructor, & Factory Constructor
/// ============================================================================

class MahasiswaModel {
  // --- ATRIBUT TERENKAPSULASI (PRIVATE FIELDS) ---
  String _nim;
  String _nama;
  String _email;
  String _jurusan;
  int _semester;
  double _ipk;
  int _totalSks;
  final List<String> _keahlian;
  final Map<String, double> _nilaiMataKuliah;
  bool _isActive;
  DateTime _terakhirDiperbarui;

  /// 1. DEFAULT CONSTRUCTOR
  MahasiswaModel({
    required String nim,
    required String nama,
    required String email,
    String jurusan = 'Teknik Informatika',
    int semester = 4,
    double ipk = 3.92,
    int totalSks = 84,
    List<String>? keahlian,
    Map<String, double>? nilaiMataKuliah,
    bool isActive = true,
    DateTime? terakhirDiperbarui,
  })  : _nim = nim,
        _nama = nama,
        _email = email,
        _jurusan = jurusan,
        _semester = semester,
        _ipk = ipk,
        _totalSks = totalSks,
        _keahlian = keahlian ?? ['Dart', 'Flutter', 'PBO (OOP)', 'Clean Architecture'],
        _nilaiMataKuliah = nilaiMataKuliah ??
            {
              'PBO-201': 95.0,
              'MOB-301': 92.5,
              'DAT-202': 88.0,
              'WEB-103': 90.0,
            },
        _isActive = isActive,
        _terakhirDiperbarui = terakhirDiperbarui ?? DateTime.now();

  /// 2. NAMED CONSTRUCTOR: Inisialisasi mahasiswa baru
  MahasiswaModel.freshman({
    required String nim,
    required String nama,
    required String email,
    String jurusan = 'Teknik Informatika',
  })  : _nim = nim,
        _nama = nama,
        _email = email,
        _jurusan = jurusan,
        _semester = 1,
        _ipk = 0.0,
        _totalSks = 0,
        _keahlian = ['Algoritma Dasar'],
        _nilaiMataKuliah = {},
        _isActive = true,
        _terakhirDiperbarui = DateTime.now();

  /// 3. FACTORY CONSTRUCTOR: Blueprint default untuk demo portofolio
  factory MahasiswaModel.defaultStudent() {
    return MahasiswaModel(
      nim: '2024091001',
      nama: 'Wishang',
      email: 'wishang.dev@kampus.ac.id',
      jurusan: 'Teknik Informatika (Konsentrasi Software Engineering)',
      semester: 4,
      ipk: 3.92,
      totalSks: 84,
      keahlian: [
        'Dart & Flutter SDK',
        'PBO / Object-Oriented Architecture',
        'State Management (Bloc/Provider)',
        'REST API & JSON Serialization',
        'Clean Architecture & SOLID',
        'Git & CI/CD Pipelines',
      ],
      nilaiMataKuliah: {
        'Pemrograman Berorientasi Objek': 96.0,
        'Pemrograman Perangkat Bergerak': 94.0,
        'Struktur Data & Algoritma': 90.0,
        'Basis Data & SQL': 91.5,
        'Rekayasa Perangkat Lunak': 93.0,
      },
      isActive: true,
    );
  }

  /// 4. FACTORY CONSTRUCTOR: Deserialisasi JSON ke Objek (Blueprint parsing)
  factory MahasiswaModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaModel(
      nim: json['nim'] as String? ?? '00000000',
      nama: json['nama'] as String? ?? 'Mahasiswa Anonim',
      email: json['email'] as String? ?? 'anon@kampus.ac.id',
      jurusan: json['jurusan'] as String? ?? 'Teknik Informatika',
      semester: json['semester'] as int? ?? 1,
      ipk: (json['ipk'] as num?)?.toDouble() ?? 0.0,
      totalSks: json['totalSks'] as int? ?? 0,
      keahlian: (json['keahlian'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      nilaiMataKuliah: (json['nilaiMataKuliah'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
      isActive: json['isActive'] as bool? ?? true,
      terakhirDiperbarui: json['terakhirDiperbarui'] != null
          ? DateTime.tryParse(json['terakhirDiperbarui'] as String)
          : null,
    );
  }

  // ===========================================================================
  // PBO CONCEPT: GETTER (READ-ONLY ACCESS & COMPUTED PROPERTIES)
  // ===========================================================================

  String get nim => _nim;
  String get nama => _nama;
  String get email => _email;
  String get jurusan => _jurusan;
  int get semester => _semester;
  double get ipk => _ipk;
  int get totalSks => _totalSks;
  bool get isActive => _isActive;
  DateTime get terakhirDiperbarui => _terakhirDiperbarui;

  /// Getter unmodifiable list & map untuk menjaga integritas enkapsulasi
  List<String> get keahlian => List.unmodifiable(_keahlian);
  Map<String, double> get nilaiMataKuliah => Map.unmodifiable(_nilaiMataKuliah);

  /// Computed Getter: Memformat tampilan IPK menjadi 2 digit desimal
  String get ipkFormatted => _ipk.toStringAsFixed(2);

  /// Computed Getter: Menentukan predikat kelulusan berdasarkan aturan akademik
  String get predikatKelulusan {
    if (_ipk >= 3.80) return 'Dengan Pujian (Cum Laude)';
    if (_ipk >= 3.50) return 'Sangat Memuaskan';
    if (_ipk >= 3.00) return 'Memuaskan';
    if (_ipk >= 2.50) return 'Cukup';
    return 'Perlu Pembinaan Khusus';
  }

  /// Computed Getter: Pengecekan status Cum Laude
  bool get isCumLaude => _ipk >= 3.80;

  /// Computed Getter: Menghitung sisa SKS yang dibutuhkan menuju kelulusan S1 (Target 144 SKS)
  int get sisaSksLulus {
    const int targetSksKelulusan = 144;
    final sisa = targetSksKelulusan - _totalSks;
    return sisa > 0 ? sisa : 0;
  }

  /// Computed Getter: Persentase kelulusan akademik
  double get persentaseKelulusan {
    const int targetSksKelulusan = 144;
    final persentase = (_totalSks / targetSksKelulusan) * 100.0;
    return persentase > 100.0 ? 100.0 : persentase;
  }

  /// Computed Getter: Ringkasan identitas akademik
  String get ringkasanProfil => '$_nama ($_nim) - Sem. $_semester | IPK: $ipkFormatted ($predikatKelulusan)';

  // ===========================================================================
  // PBO CONCEPT: SETTER (MUTASI STATUS TERVALIDASI & LOGIKA BISNIS)
  // ===========================================================================

  /// Setter IPK dengan validasi ketat rentang 0.00 s/d 4.00
  set ipk(double value) {
    if (value < 0.0 || value > 4.0) {
      throw ArgumentError(
        'Validasi Enkapsulasi Gagal: Nilai IPK harus berada dalam rentang 0.00 hingga 4.00 (Nilai masukan: $value)',
      );
    }
    _ipk = value;
    _terakhirDiperbarui = DateTime.now();
  }

  /// Setter Semester dengan batas wajar perkuliahan (Semester 1 s/d 14)
  set semester(int value) {
    if (value < 1 || value > 14) {
      throw ArgumentError(
        'Validasi Enkapsulasi Gagal: Semester harus berada di antara semester 1 hingga 14 (Nilai masukan: $value)',
      );
    }
    _semester = value;
    _terakhirDiperbarui = DateTime.now();
  }

  /// Setter Nama dengan pembersihan whitespace dan larangan string kosong
  set nama(String value) {
    final sanitized = value.trim();
    if (sanitized.isEmpty) {
      throw ArgumentError('Validasi Enkapsulasi Gagal: Nama mahasiswa tidak boleh kosong.');
    }
    if (sanitized.length < 3) {
      throw ArgumentError('Validasi Enkapsulasi Gagal: Nama mahasiswa minimal terdiri dari 3 karakter.');
    }
    _nama = sanitized;
    _terakhirDiperbarui = DateTime.now();
  }

  /// Setter NIM dengan verifikasi format dan panjang karakter minimal
  set nim(String value) {
    final sanitized = value.trim();
    if (sanitized.length < 8) {
      throw ArgumentError(
        'Validasi Enkapsulasi Gagal: Format NIM minimal 8 digit karakter (Nilai masukan: $value)',
      );
    }
    _nim = sanitized;
    _terakhirDiperbarui = DateTime.now();
  }

  /// Setter Email dengan validasi pola email standar
  set email(String value) {
    final sanitized = value.trim().toLowerCase();
    if (!sanitized.contains('@') || !sanitized.contains('.')) {
      throw ArgumentError('Validasi Enkapsulasi Gagal: Format email "$value" tidak valid.');
    }
    _email = sanitized;
    _terakhirDiperbarui = DateTime.now();
  }

  /// Setter Jurusan
  set jurusan(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Validasi Enkapsulasi Gagal: Program studi tidak boleh kosong.');
    }
    _jurusan = value.trim();
    _terakhirDiperbarui = DateTime.now();
  }

  /// Setter Status Aktif
  set isActive(bool value) {
    _isActive = value;
    _terakhirDiperbarui = DateTime.now();
  }

  // ===========================================================================
  // PBO CONCEPT: FUNCTIONS / METHODS (FUNGSI OPERASIONAL OBJEK)
  // ===========================================================================

  /// Method: Menambahkan SKS dengan verifikasi nilai positif
  void tambahSks(int sksTambahan) {
    if (sksTambahan <= 0) {
      throw ArgumentError('SKS tambahan harus berupa bilangan bulat positif (> 0).');
    }
    _totalSks += sksTambahan;
    _terakhirDiperbarui = DateTime.now();
  }

  /// Method: Menambahkan keahlian baru ke dalam list privat (mencegah duplikasi)
  bool tambahKeahlian(String skill) {
    final cleanSkill = skill.trim();
    if (cleanSkill.isEmpty) return false;
    if (_keahlian.any((item) => item.toLowerCase() == cleanSkill.toLowerCase())) {
      return false; // Sudah terdaftar
    }
    _keahlian.add(cleanSkill);
    _terakhirDiperbarui = DateTime.now();
    return true;
  }

  /// Method: Menghapus keahlian dari daftar
  bool hapusKeahlian(String skill) {
    final result = _keahlian.remove(skill);
    if (result) {
      _terakhirDiperbarui = DateTime.now();
    }
    return result;
  }

  /// Method: Mencatat nilai mata kuliah baru dan mengkalkulasi ulang rata-rata nilai
  void catatNilaiMataKuliah(String mataKuliah, double nilai) {
    if (nilai < 0.0 || nilai > 100.0) {
      throw ArgumentError('Nilai mata kuliah harus bernilai antara 0.0 sampai 100.0 (Input: $nilai)');
    }
    _nilaiMataKuliah[mataKuliah.trim()] = nilai;
    _terakhirDiperbarui = DateTime.now();
  }

  /// Method: Menghitung rata-rata nilai seluruh mata kuliah yang telah terinput
  double hitungRataRataNilai() {
    if (_nilaiMataKuliah.isEmpty) return 0.0;
    final total = _nilaiMataKuliah.values.reduce((a, b) => a + b);
    return total / _nilaiMataKuliah.length;
  }

  /// Method: Evaluasi syarat pengambilan skripsi (Minimal Semester 7 & SKS >= 120 & IPK >= 2.75)
  String evaluasiKelayakanSkripsi() {
    final List<String> kendala = [];
    if (_semester < 7) kendala.add('Semester belum mencapai batas minimal (Minimal Sem. 7, saat ini Sem. $_semester)');
    if (_totalSks < 120) kendala.add('Total SKS belum mencukupi (Minimal 120 SKS, saat ini $_totalSks SKS)');
    if (_ipk < 2.75) kendala.add('IPK belum mencukupi standar kelulusan skripsi (Minimal 2.75, saat ini $ipkFormatted)');

    if (kendala.isEmpty) {
      return '✅ MEMENUHI SYARAT: Mahasiswa telah memenuhi seluruh kriteria untuk mendaftar Sidang Proposal & Skripsi.';
    } else {
      return '⚠️ BELUM MEMENUHI SYARAT:\n• ${kendala.join('\n• ')}';
    }
  }

  /// Method: Serialisasi Objek ke JSON String (berguna untuk laporan dan export data)
  Map<String, dynamic> toJson() {
    return {
      'nim': _nim,
      'nama': _nama,
      'email': _email,
      'jurusan': _jurusan,
      'semester': _semester,
      'ipk': _ipk,
      'totalSks': _totalSks,
      'keahlian': _keahlian,
      'nilaiMataKuliah': _nilaiMataKuliah,
      'isActive': _isActive,
      'terakhirDiperbarui': _terakhirDiperbarui.toIso8601String(),
    };
  }

  String toJsonString() => jsonEncode(toJson());

  /// Method: Clone / Copy with untuk manipulasi objek secara immutable
  MahasiswaModel copyWith({
    String? nim,
    String? nama,
    String? email,
    String? jurusan,
    int? semester,
    double? ipk,
    int? totalSks,
    List<String>? keahlian,
    Map<String, double>? nilaiMataKuliah,
    bool? isActive,
  }) {
    return MahasiswaModel(
      nim: nim ?? _nim,
      nama: nama ?? _nama,
      email: email ?? _email,
      jurusan: jurusan ?? _jurusan,
      semester: semester ?? _semester,
      ipk: ipk ?? _ipk,
      totalSks: totalSks ?? _totalSks,
      keahlian: keahlian ?? List.from(_keahlian),
      nilaiMataKuliah: nilaiMataKuliah ?? Map.from(_nilaiMataKuliah),
      isActive: isActive ?? _isActive,
      terakhirDiperbarui: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'MahasiswaModel(nim: $_nim, nama: $_nama, semester: $_semester, ipk: $ipkFormatted, sks: $_totalSks)';
  }
}
