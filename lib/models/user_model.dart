import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// ============================================================================
/// KONSEP PBO (Pemrograman Berorientasi Objek) #1:
/// - Abstraksi (Abstract Class)
/// - Enkapsulasi (Private Fields + Getter/Setter)
/// - Polimorfisme (Overriding Method pada Subclass)
/// - Pewarisan (Inheritance)
/// ============================================================================

/// Kelas Abstrak sebagai blueprint seluruh entitas pengguna
abstract class BaseUser {
  // Enkapsulasi: Properti privat yang terlindungi
  final String _id;
  final String _username;
  String _displayName;
  String _avatarUrl;
  String _email;
  String _bio;
  final DateTime _loginTime;
  int _sessionMinutes;

  BaseUser({
    required String id,
    required String username,
    required String displayName,
    required String avatarUrl,
    String email = 'user@kampus.ac.id',
    String bio = 'Pengguna aktif sistem portofolio PBO',
    DateTime? loginTime,
    int sessionMinutes = 0,
  })  : _id = id,
        _username = username,
        _displayName = displayName,
        _avatarUrl = avatarUrl,
        _email = email,
        _bio = bio,
        _loginTime = loginTime ?? DateTime.now(),
        _sessionMinutes = sessionMinutes;

  // --- GETTER PUBLIK UNTUK MEMBACA DATA TERENKAPSULASI ---
  String get id => _id;
  String get username => _username;
  String get displayName => _displayName;
  String get avatarUrl => _avatarUrl;
  String get email => _email;
  String get bio => _bio;
  DateTime get loginTime => _loginTime;
  int get sessionMinutes => _sessionMinutes;

  // --- SETTER DENGAN VALIDASI ATURAN BISNIS (ENKAPSULASI) ---
  set displayName(String value) {
    final sanitized = value.trim();
    if (sanitized.isEmpty) {
      throw ArgumentError('Nama pengguna tidak boleh kosong.');
    }
    if (sanitized.length < 2) {
      throw ArgumentError('Nama pengguna minimal harus 2 karakter.');
    }
    _displayName = sanitized;
  }

  set avatarUrl(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('URL avatar tidak boleh kosong.');
    }
    _avatarUrl = value.trim();
  }

  set email(String value) {
    final sanitized = value.trim().toLowerCase();
    if (!sanitized.contains('@') || !sanitized.contains('.')) {
      throw ArgumentError('Format email tidak valid.');
    }
    _email = sanitized;
  }

  set bio(String value) {
    if (value.length > 250) {
      throw ArgumentError('Bio profil maksimal 250 karakter.');
    }
    _bio = value.trim();
  }

  // --- FUNCTION / METHOD INSTANCE ---
  void tambahDurasiSesi(int menit) {
    if (menit > 0) {
      _sessionMinutes += menit;
    }
  }

  // Polimorfisme: Metode abstrak yang wajib diimplementasikan ulang oleh subclass
  String getRoleTitle();
  String getClearanceLevel();
  Color getRoleColor();
  List<String> getPermissions();
  IconData getRoleIcon();

  // Metode konkret yang dapat digunakan oleh semua turunan
  String getFormattedSessionTime() {
    final hour = _loginTime.hour.toString().padLeft(2, '0');
    final minute = _loginTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute WIB';
  }

  // Desain Polimorfisme: representasi ringkasan profil
  String getProfileSummary() {
    return '$_displayName (${getRoleTitle()}) - Izin: ${getPermissions().length} Modul Aktif';
  }
}

/// ============================================================================
/// PEWARISAN & POLIMORFISME #1: Dosen / Evaluator Matkul PBO
/// ============================================================================
class AcademicEvaluatorUser extends BaseUser {
  final String university;
  final String courseTaught;

  AcademicEvaluatorUser({
    required super.id,
    required super.username,
    required super.displayName,
    required super.avatarUrl,
    this.university = 'Universitas Komputer & Informatika',
    this.courseTaught = 'Pemrograman Berorientasi Objek (PBO)',
    super.loginTime,
  });

  @override
  String getRoleTitle() => 'Dosen / Penilai Akademik PBO';

  @override
  String getClearanceLevel() => 'Level 5 (Full Source & Architecture Audit)';

  @override
  Color getRoleColor() => AppColors.accentRose;

  @override
  IconData getRoleIcon() => Icons.school_rounded;

  @override
  List<String> getPermissions() => [
        'Audit Enkapsulasi & Abstraksi',
        'Inspect Polymorphic Contracts',
        'Run Live PBO Interactive Simulator',
        'Beri Nilai & Review Kode',
      ];
}

/// ============================================================================
/// PEWARISAN & POLIMORFISME #2: Tech Recruiter / Client
/// ============================================================================
class RecruiterUser extends BaseUser {
  final String companyName;

  RecruiterUser({
    required super.id,
    required super.username,
    required super.displayName,
    required super.avatarUrl,
    this.companyName = 'Tech Venture / Software Studio',
    super.loginTime,
  });

  @override
  String getRoleTitle() => 'Tech Talent Recruiter';

  @override
  String getClearanceLevel() => 'Level 3 (Showcase & Contact Access)';

  @override
  Color getRoleColor() => AppColors.secondary;

  @override
  IconData getRoleIcon() => Icons.work_rounded;

  @override
  List<String> getPermissions() => [
        'Lihat Portofolio Lengkap',
        'Download CV & Resume',
        'Hubungi Langsung via Kontak',
        'Review Tech Stack & Metrik',
      ];
}

/// ============================================================================
/// PEWARISAN & POLIMORFISME #3: Fellow Developer / Tamu
/// ============================================================================
class DeveloperGuestUser extends BaseUser {
  final String favoriteLanguage;

  DeveloperGuestUser({
    required super.id,
    required super.username,
    required super.displayName,
    required super.avatarUrl,
    this.favoriteLanguage = 'Dart & Java',
    super.loginTime,
  });

  @override
  String getRoleTitle() => 'Tamu Pengunjung';

  @override
  String getClearanceLevel() => 'Level 2 (Guest Access)';

  @override
  Color getRoleColor() => AppColors.primary;

  @override
  IconData getRoleIcon() => Icons.person_outline_rounded;

  @override
  List<String> getPermissions() => [
        'Uji Coba Demo Interaktif PBO',
        'Jelajahi Repository & Source Code',
        'Simulasi List Builder',
        'Beri Feedback & Apresiasi',
      ];
}

/// ============================================================================
/// PEWARISAN & POLIMORFISME #4: Mahasiswa Pembuat Proyek & Author Portofolio
/// ============================================================================
class MahasiswaAuthorUser extends BaseUser {
  final String nim;
  final String programStudi;
  final double ipk;

  MahasiswaAuthorUser({
    required super.id,
    required super.username,
    required super.displayName,
    required super.avatarUrl,
    required this.nim,
    this.programStudi = 'Teknik Informatika (Konsentrasi Software Engineering)',
    this.ipk = 3.92,
    super.email,
    super.bio,
    super.loginTime,
  });

  @override
  String getRoleTitle() => 'Mahasiswa Pengembang & Author PBO';

  @override
  String getClearanceLevel() => 'Level Administrator (Master Source & Rubrik PBO)';

  @override
  Color getRoleColor() => AppColors.secondary;

  @override
  IconData getRoleIcon() => Icons.badge_rounded;

  @override
  List<String> getPermissions() => [
        'Akses Penuh Blueprint Model & Objek',
        'Uji Eksplorasi Setter & Getter Real-Time',
        'Ekspor & Unduh Dokumen Laporan PDF',
        'Kelola Proyek & Rubrik Penilaian',
      ];
}
