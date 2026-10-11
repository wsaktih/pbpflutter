import '../models/portfolio_item.dart';

class PortfolioService {
  static final List<PortfolioItem> _items = [
    SecurityAiProjectItem(
      id: 'proj-phishguard',
      title: 'PhishGuard AI - Deteksi Tautan Phishing Cerdas',
      shortDescription:
          'Platform analisis keamanan siber bertenaga AI untuk memindai dan mendeteksi tautan atau URL phishing mencurigakan secara real-time.',
      detailedDescription:
          'Aplikasi full-stack deteksi ancaman phishing berbasis Next.js (App Router) dan TypeScript. Mengintegrasikan antarmuka web modern dengan REST API backend untuk pemindaian payload, reputasi tautan, dan deteksi domain berbahaya guna melindungi pengguna dari serangan rekayasa sosial.',
      projectOutput:
          'Web Scanner Interaktif & REST API Analisis URL Berbahaya Real-Time (Live di Vercel)',
      categories: [
        PortfolioCategory.cybersecurity,
        PortfolioCategory.webDev,
        PortfolioCategory.aiEngineering,
      ],
      techStack: ['Next.js', 'TypeScript', 'Tailwind CSS', 'REST API', 'Vercel'],
      dateCreated: 'Agustus 2026',
      repoUrl: 'https://github.com/wsaktih/phishguard-ai',
      liveUrl: 'https://phishguard-ai-vert.vercel.app',
      threatDomain: 'Deteksi Phishing & Keamanan Web',
      aiModelUsed: 'Threat Intelligence Heuristics & Classifier API',
      isFeatured: true,
    ),
    SecurityAiProjectItem(
      id: 'proj-netvision',
      title: 'NetVision - AI Network Traffic & Intrusion Detection',
      shortDescription:
          'Sistem inspeksi paket lalu lintas jaringan dan deteksi anomali (NIDS) bertenaga machine learning dengan lapisan Explainable AI (SHAP).',
      detailedDescription:
          'Solusi rekayasa AI dan keamanan jaringan berbasis Python. Menangkap lalu lintas paket secara real-time, mengekstraksi 23 fitur jaringan, melatih model offline Scikit-Learn (Random Forest), serta mengintegrasikan lapisan Explainable AI (XAI) melalui SHAP untuk menyajikan transparansi alasan logis di balik setiap klasifikasi ancaman siber.',
      projectOutput:
          'Pipeline Inspeksi Paket Jaringan dengan Model Deteksi Anomali & Lapisan Explainable AI (SHAP)',
      categories: [
        PortfolioCategory.cybersecurity,
        PortfolioCategory.aiEngineering,
      ],
      techStack: ['Python', 'Scikit-Learn', 'SHAP (XAI)', 'Network Capture', 'Docker'],
      dateCreated: 'Agustus 2026',
      repoUrl: 'https://github.com/wsaktih/netvision',
      threatDomain: 'Network Intrusion Detection System (NIDS)',
      aiModelUsed: 'Scikit-Learn Random Forest + SHAP Explainability Layer',
      isFeatured: true,
    ),
    SoftwareAppItem(
      id: 'proj-pbpflutter',
      title: 'Portofolio Digital & 3D Interactive Showroom',
      shortDescription:
          'Aplikasi portofolio digital interaktif mutakhir dengan tema kosmik gelap, integrasi model 3D spasial (.glb), dan arsitektur OOP modular.',
      detailedDescription:
          'Aplikasi multi-platform berbasis Flutter dan Dart yang mengimplementasikan arsitektur berorientasi objek secara komprehensif. Menampilkan integrasi model 3D interaktif yang responsif terhadap pergerakan kursor, simulasi kosmik partikel dengan CustomPainter, serta showcase sertifikat dan katalog proyek.',
      projectOutput:
          'Aplikasi Multi-Platform (Web & Mobile) Interaktif dengan Rendering Model 3D Spasial (.glb)',
      categories: [
        PortfolioCategory.mobileDev,
        PortfolioCategory.webDev,
      ],
      techStack: ['Flutter', 'Dart 3', '3D GLB', 'CustomPainter', 'Material 3'],
      dateCreated: 'September 2026',
      repoUrl: 'https://github.com/wsaktih/pbpflutter',
      platform: 'Cross-Platform (Web & Mobile)',
      framework: 'Flutter 3.x & Dart',
      totalStars: 52,
      isFeatured: true,
    ),
  ];

  static List<PortfolioItem> getAllItems() {
    return List.unmodifiable(_items);
  }

  static List<PortfolioItem> getItemsByCategory(PortfolioCategory category) {
    if (category == PortfolioCategory.all) {
      return getAllItems();
    }
    return _items.where((item) => item.belongsToCategory(category)).toList();
  }

  static PortfolioItem? getById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }
}
