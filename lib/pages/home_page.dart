import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/portfolio_service.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_background.dart';
import '../widgets/circular_profile_avatar.dart';
import '../widgets/nav_bar.dart';
import '../widgets/project_card.dart';
import '../widgets/profile_3d_inspector_dialog.dart';
import '../widgets/certificate_showcase.dart';
import '../widgets/typewriter_text.dart';
import '../widgets/social_media_hub_dialog.dart';
import '../widgets/glb_3d_character_viewer.dart';
import 'mahasiswa_page.dart';

/// Halaman Home (Portofolio Digital & Laboratorium PBO)
/// Memadukan konsep estetika minimalis elegan, foto lingkaran berputar,
/// dan ListView.builder interaktif.
class HomePage extends StatefulWidget {
  final BaseUser currentUser;

  const HomePage({
    super.key,
    required this.currentUser,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _pboKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();

  PortfolioCategory _selectedCategory = PortfolioCategory.all;
  late List<PortfolioItem> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = PortfolioService.getAllItems();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _filterProjects(PortfolioCategory category) {
    setState(() {
      _selectedCategory = category;
      _filteredItems = PortfolioService.getItemsByCategory(category);
    });
  }

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      body: AnimatedBackground(
        showGrid: true,
        showParticles: true,
        showOrbs: true,
        child: Column(
          children: [
            // Top Navigation Bar
            NavBar(
              currentUser: widget.currentUser,
              onScrollToAbout: () => _scrollTo(_aboutKey),
              onScrollToPbo: () => _scrollTo(_pboKey),
              onScrollToProjects: () => _scrollTo(_projectsKey),
            ),

            // Konten Utama Scrollable
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Section 1: Hero Section dengan Foto Berbentuk Lingkaran
                    Container(
                      key: _aboutKey,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1100),
                          child: isDesktop
                              ? _buildDesktopHero(context)
                              : _buildMobileHero(context),
                        ),
                      ),
                    ),

                    // Section 2: Galeri Sertifikat & Lisensi Kompetensi Profesional
                    Container(
                      key: _pboKey,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1100),
                          child: const CertificateShowcaseSection(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Section 3: Katalog Proyek & Tugas Kuliah menggunakan ListView.builder
                    Container(
                      key: _projectsKey,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1100),
                          child: _buildProjectsListBuilderSection(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Footer
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Hero Section untuk Layar Desktop
  Widget _buildDesktopHero(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // FOTO PROFIL 3D SPASIAL INTERAKTIF DENGAN TILT PERSPEKTIF & SATELIT ORBIT
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProfileAvatar(
              radius: 104,
              imageUrl:
                  'assets/images/profile.jpeg',
              showOrbitBadges: true,
              use3DAvatarAsset: true,
              enable3DTilt: true,
              enableIdleFloat: true,
            ),
            const SizedBox(height: 16),
            // Tombol Inspeksi 3D
            OutlinedButton.icon(
              onPressed: () => Profile3DInspectorDialog.show(context),
              icon: const Icon(Icons.view_in_ar_rounded, size: 16, color: AppColors.secondaryLight),
              label: const Text('Inspeksi 3D Holo'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: AppColors.secondary.withOpacity(0.5)),
                backgroundColor: AppColors.bgSurface.withOpacity(0.6),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.touch_app_rounded, size: 12, color: AppColors.textMuted),
                SizedBox(width: 4),
                Text(
                  'Geser kursor untuk tilt 3D • Klik avatar',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(width: 48),

        // Teks Informasi Profil
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'Halo, Saya ',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.8,
                    ),
                  ),
                  TypewriterText(
                    texts: const [
                      'Wishang 👋',
                      'Flutter Developer 🚀',
                      'Software Architect 💻',
                    ],
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: AppColors.secondary,
                      letterSpacing: -0.8,
                    ),
                    cursor: '|',
                  ),
                ],
              ),

              const SizedBox(height: 6),

              const Text(
                'Software Engineer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryLight,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Mahasiswa Teknik Informatika yang berdedikasi membangun perangkat lunak '
                'berkualitas tinggi.',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 24),

              // Tombol Call-to-Action (Profil 3D Holo & Media Sosial Terpadu)
              _buildHeroActionButtons(isMobile: false),
            ],
          ),
        ),

        const SizedBox(width: 36),

        // MODEL 3D GLB ASLI (.glb) (Ukuran Lebih Kecil & Compact di Samping Bagian Tentang)
        const Glb3DCharacterViewer(
          glbAssetPath: 'assets/models/character.glb',
          width: 215,
          height: 295,
          autoRotate: true,
        ),
      ],
    );
  }

  /// Hero Section untuk Layar Mobile
  Widget _buildMobileHero(BuildContext context) {
    return Column(
      children: [
        // FOTO PROFIL 3D SPASIAL MOBILE
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProfileAvatar(
              radius: 80,
              imageUrl:
                  'assets/images/profile.jpeg',
              showOrbitBadges: true,
              use3DAvatarAsset: true,
              enable3DTilt: true,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Profile3DInspectorDialog.show(context),
              icon: const Icon(Icons.view_in_ar_rounded, size: 15, color: AppColors.secondaryLight),
              label: const Text('Inspeksi 3D Holo'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: AppColors.secondary.withOpacity(0.5)),
                backgroundColor: AppColors.bgSurface.withOpacity(0.6),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'Halo, Saya ',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            TypewriterText(
              texts: const [
                'Wishang 👋',
                'Flutter Dev 🚀',
                'Software Architect 💻',
              ],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: AppColors.secondary,
              ),
              cursor: '|',
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Flutter Mobile Architect',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryLight,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Portofolio digital mengintegrasikan implementasi nyata Mata Kuliah Pemrograman '
          'Berorientasi Objek (PBO) dengan antarmuka Flutter Web minimalis elegan.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
        ),
        const SizedBox(height: 20),

        // MODEL 3D GLB ASLI (.glb) (Mobile - Ukuran Lebih Kecil & Compact)
        const Glb3DCharacterViewer(
          glbAssetPath: 'assets/models/character.glb',
          width: 180,
          height: 255,
          autoRotate: true,
        ),

        const SizedBox(height: 22),
        _buildHeroActionButtons(isMobile: true),
      ],
    );
  }



  /// =========================================================================
  /// ACTION BUTTONS HERO: PROFIL 3D HOLO, GITHUB & SOSIAL MEDIA
  /// =========================================================================
  Widget _buildHeroActionButtons({required bool isMobile}) {
    return Wrap(
      spacing: isMobile ? 8 : 12,
      runSpacing: isMobile ? 8 : 10,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // 1. Profil 3D Holo (Tombol Utama)
        ElevatedButton.icon(
          onPressed: () => Profile3DInspectorDialog.show(context),
          icon: Icon(Icons.view_in_ar_rounded, size: isMobile ? 16 : 18),
          label: const Text('Profil 3D Holo'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.black,
            elevation: 4,
            shadowColor: AppColors.secondary.withOpacity(0.4),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 22,
              vertical: isMobile ? 12 : 15,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: isMobile ? 12.5 : 14,
            ),
          ),
        ),

        // 2. Hub Media Sosial & Tautan (Menyatukan GitHub, LinkedIn, Instagram, Email menjadi 1 tombol)
        ElevatedButton.icon(
          onPressed: () => SocialMediaHubDialog.show(context),
          icon: Icon(Icons.hub_rounded, size: isMobile ? 16 : 18, color: AppColors.secondary),
          label: const Text('Sosial Media & Tautan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E293B),
            foregroundColor: Colors.white,
            side: BorderSide(color: AppColors.secondary.withOpacity(0.55)),
            elevation: 3,
            shadowColor: AppColors.secondary.withOpacity(0.2),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 22,
              vertical: isMobile ? 12 : 15,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: isMobile ? 12.5 : 14,
            ),
          ),
        ),

        // 3. Katalog Mahasiswa (ListView.builder, Functions & Setter/Getter)
        ElevatedButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MahasiswaPage(currentUser: widget.currentUser),
            ),
          ),
          icon: Icon(Icons.school_rounded, size: isMobile ? 16 : 18, color: const Color(0xFF00A3FF)),
          label: const Text('Katalog Mahasiswa'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F172A),
            foregroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFF00A3FF), width: 1.2),
            elevation: 3,
            shadowColor: const Color(0xFF00A3FF).withOpacity(0.25),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 20,
              vertical: isMobile ? 12 : 15,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: isMobile ? 12.5 : 14,
            ),
          ),
        ),
      ],
    );
  }

  /// =========================================================================
  /// FITUR 3: LISTVIEW.BUILDER UNTUK DAFTAR PROYEK & TUGAS KULIAH
  /// =========================================================================
  Widget _buildProjectsListBuilderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul Bagian
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.code_rounded, color: AppColors.secondary, size: 24),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PORTFOLIO SHOWCASE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'Koleksi Proyek & Tugas Akademik',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Filter Bar (Tabs)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: PortfolioCategory.values.map((cat) {
              final isSelected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FilterChip(
                  selected: isSelected,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        cat.icon,
                        size: 15,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(cat.label),
                    ],
                  ),
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                  backgroundColor: AppColors.bgSurface,
                  selectedColor: AppColors.primary,
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.glassBorder,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (val) {
                    _filterProjects(cat);
                  },
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 24),

        // PENGGUNAAN LISTVIEW.BUILDER (Vertical List Builder untuk Proyek)
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _filteredItems.length,
          itemBuilder: (context, index) {
            final item = _filteredItems[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ProjectCard(
                item: item,
                index: index,
              ),
            );
          },
        ),
      ],
    );
  }



  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: const BoxDecoration(
        color: AppColors.bgDark,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2026 Portofolio Mahasiswa',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              Text(
                'Minimalist Elegant Architecture',
                style: TextStyle(fontSize: 12, color: AppColors.secondaryLight),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
