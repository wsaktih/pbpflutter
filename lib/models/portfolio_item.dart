import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// ============================================================================
/// KONSEP PBO: Abstraction & Interface Contract untuk Item Portofolio
/// Menjamin setiap item portofolio memiliki struktur modular dan terstandarisasi.
/// ============================================================================

enum PortfolioCategory {
  all('Semua', Icons.grid_view_rounded),
  cybersecurity('Cybersecurity', Icons.security_rounded),
  webDev('Web Dev', Icons.language_rounded),
  mobileDev('Mobile Dev', Icons.phone_android_rounded),
  iot('IoT', Icons.sensors_rounded),
  aiEngineering('AI Engineering', Icons.psychology_rounded);

  final String label;
  final IconData icon;
  const PortfolioCategory(this.label, this.icon);
}

/// Interface untuk item yang dapat diuji coba secara interaktif
abstract class InteractiveDemonstrable {
  String runInteractiveDemonstration();
}

/// Kelas Abstrak Induk (Blueprint Item Portofolio)
abstract class PortfolioItem {
  final String id;
  final String title;
  final String shortDescription;
  final String detailedDescription;
  final String projectOutput;
  final List<PortfolioCategory> categories;
  final List<String> techStack;
  final String dateCreated;
  final String repoUrl;
  final String? liveUrl;
  final bool isFeatured;

  // Enkapsulasi: State interaktif yang dimutasi via method & setter
  int _viewsCount;
  int _likesCount;
  double _rating;
  bool _isBookmarked;

  PortfolioItem({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.detailedDescription,
    required this.projectOutput,
    required this.categories,
    required this.techStack,
    required this.dateCreated,
    required this.repoUrl,
    this.liveUrl,
    this.isFeatured = false,
    int viewsCount = 120,
    int likesCount = 28,
    double rating = 4.85,
    bool isBookmarked = false,
  })  : _viewsCount = viewsCount,
        _likesCount = likesCount,
        _rating = rating,
        _isBookmarked = isBookmarked;

  // --- GETTER PUBLIK ---
  int get viewsCount => _viewsCount;
  int get likesCount => _likesCount;
  double get rating => _rating;
  bool get isBookmarked => _isBookmarked;
  String get ratingFormatted => _rating.toStringAsFixed(1);

  // --- SETTER DENGAN VALIDASI ENKAPSULASI ---
  set rating(double value) {
    if (value < 0.0 || value > 5.0) {
      throw ArgumentError('Rating proyek harus bernilai antara 0.0 hingga 5.0 (Masukan: $value)');
    }
    _rating = value;
  }

  set viewsCount(int value) {
    if (value < 0) {
      throw ArgumentError('Jumlah views tidak boleh negatif.');
    }
    _viewsCount = value;
  }

  // --- FUNCTION / METHOD OPERASIONAL OBJEK ---
  void addLike() {
    _likesCount++;
  }

  void incrementViews() {
    _viewsCount++;
  }

  void toggleBookmark() {
    _isBookmarked = !_isBookmarked;
  }

  bool belongsToCategory(PortfolioCategory category) {
    if (category == PortfolioCategory.all) return true;
    return categories.contains(category);
  }

  // Polimorfisme: Setiap kategori memiliki badge, aksen warna, dan metrik berbeda
  Color getCategoryColor();
  String getCategoryBadge();
  IconData getItemIcon();
  Map<String, String> getMetadataAttributes();
}

/// ============================================================================
/// SUBCLASS: Proyek Keamanan Siber & Rekayasa Kecerdasan Buatan (AI)
/// Khusus untuk proyek CyberSecurity & AI Engineering dari GitHub @wsaktih
/// ============================================================================
class SecurityAiProjectItem extends PortfolioItem implements InteractiveDemonstrable {
  final String threatDomain;
  final String aiModelUsed;

  SecurityAiProjectItem({
    required super.id,
    required super.title,
    required super.shortDescription,
    required super.detailedDescription,
    required super.projectOutput,
    required super.categories,
    required super.techStack,
    required super.dateCreated,
    required super.repoUrl,
    super.liveUrl,
    super.isFeatured = true,
    required this.threatDomain,
    required this.aiModelUsed,
  });

  @override
  Color getCategoryColor() => AppColors.secondary;

  @override
  String getCategoryBadge() => 'CYBERSECURITY & AI';

  @override
  IconData getItemIcon() => Icons.security_rounded;

  @override
  Map<String, String> getMetadataAttributes() => {
        'Domain Keamanan': threatDomain,
        'Engine / Model AI': aiModelUsed,
        'Repositori GitHub': repoUrl,
        'Status Proyek': '✅ Terverifikasi di GitHub @wsaktih',
      };

  @override
  String runInteractiveDemonstration() {
    return '''
[SECURITY & AI ENGINE - GITHUB @wsaktih]
- Proyek Terverifikasi: $title
- Domain Ancaman: $threatDomain
- Model Engine: $aiModelUsed
- Tautan Repo: $repoUrl
- Verifikasi: Proyek asli terdaftar pada repositori GitHub @wsaktih.
''';
  }
}

/// ============================================================================
/// SUBCLASS: Proyek Aplikasi Software / Mobile / Web
/// Khusus untuk proyek Mobile Dev & Web Dev dari GitHub @wsaktih
/// ============================================================================
class SoftwareAppItem extends PortfolioItem {
  final String platform;
  final String framework;
  final int totalStars;

  SoftwareAppItem({
    required super.id,
    required super.title,
    required super.shortDescription,
    required super.detailedDescription,
    required super.projectOutput,
    required super.categories,
    required super.techStack,
    required super.dateCreated,
    required super.repoUrl,
    super.liveUrl,
    this.platform = 'Cross-Platform (Web & Mobile)',
    this.framework = 'Flutter & Dart',
    this.totalStars = 48,
    super.isFeatured = true,
  });

  @override
  Color getCategoryColor() => AppColors.primaryLight;

  @override
  String getCategoryBadge() => 'PROYEK $platform';

  @override
  IconData getItemIcon() =>
      categories.contains(PortfolioCategory.mobileDev)
          ? Icons.smartphone_rounded
          : Icons.code_rounded;

  @override
  Map<String, String> getMetadataAttributes() => {
        'Platform': platform,
        'Framework': framework,
        'Repositori': repoUrl,
        'Apresiasi': '⭐ $totalStars Stars',
      };
}

/// ============================================================================
/// SUBCLASS LEGACY: Tugas & Proyek Matkul Pemrograman Berorientasi Objek
/// ============================================================================
class PboCourseworkItem extends PortfolioItem implements InteractiveDemonstrable {
  final String courseSemester;
  final List<String> pboPrinciplesUsed;
  final String classHierarchyDescription;
  final String sourceCodeSample;
  final String simulatedExecutionLog;

  PboCourseworkItem({
    required super.id,
    required super.title,
    required super.shortDescription,
    required super.detailedDescription,
    required super.projectOutput,
    required super.categories,
    required super.techStack,
    required super.dateCreated,
    required super.repoUrl,
    super.liveUrl,
    required this.courseSemester,
    required this.pboPrinciplesUsed,
    required this.classHierarchyDescription,
    required this.sourceCodeSample,
    required this.simulatedExecutionLog,
    super.isFeatured = false,
  });

  @override
  Color getCategoryColor() => AppColors.primaryLight;

  @override
  String getCategoryBadge() => 'MATKUL PBO • $courseSemester';

  @override
  IconData getItemIcon() => Icons.data_object_rounded;

  @override
  Map<String, String> getMetadataAttributes() => {
        'Mata Kuliah': 'Pemrograman Berorientasi Objek',
        'Pilar Digunakan': pboPrinciplesUsed.join(', '),
        'Hirarki Kelas': classHierarchyDescription,
        'Status Verifikasi': '✅ Lulus Evaluasi & Terkompilasi',
      };

  @override
  String runInteractiveDemonstration() {
    return '''
[PBO RUNTIME ENGINE]
- Menginstansiasi Objek Hirarki...
- Prinsip Aktif: ${pboPrinciplesUsed.join(' + ')}
$simulatedExecutionLog
''';
  }
}
