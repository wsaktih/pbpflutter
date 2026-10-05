import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_background.dart';
import '../widgets/circular_profile_avatar.dart';
import '../widgets/cyber_login_card.dart';
import 'home_page.dart';

/// Halaman Login Kreatif: Digital Identity & Access Terminal
/// Tidak template, mengusung konsep kartu akses interaktif pengunjung & terminal portofolio.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _navigateToHome(BaseUser user) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            HomePage(currentUser: user),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic);
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.94, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 960;

    return Scaffold(
      body: AnimatedBackground(
        showGrid: true,
        showParticles: true,
        showOrbs: true,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: isDesktop
                  ? _buildDesktopLayout(context)
                  : _buildMobileLayout(context),
            ),
          ),
        ),
      ),
    );
  }

  /// Tampilan Desktop: Dua Kolom (Branding & Identity di kiri, Terminal Login di kanan)
  Widget _buildDesktopLayout(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1180),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Kolom Kiri: Branding Developer & Showcase Matkul PBO
          Expanded(
            flex: 5,
            child: _buildBrandingColumn(),
          ),

          const SizedBox(width: 60),

          // Kolom Kanan: Kartu Akses Cyber Login
          Expanded(
            flex: 5,
            child: Center(
              child: CyberLoginCard(
                onLoginSuccess: _navigateToHome,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Tampilan Mobile / Layar Kecil: Vertikal Bertingkat
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildBrandingColumn(isMobile: true),
        const SizedBox(height: 36),
        CyberLoginCard(
          onLoginSuccess: _navigateToHome,
        ),
      ],
    );
  }

  /// Kolom Branding, Profil Lingkaran & Sorotan PBO
  Widget _buildBrandingColumn({bool isMobile = false}) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Foto Profil Berbentuk Lingkaran Mini dengan Glow di Login Page
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProfileAvatar(
              radius: 36,
              imageUrl:
                  'assets/images/profile.jpeg',
            ),
            const SizedBox(width: 18),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.terminal_rounded, size: 13, color: AppColors.secondary),
                        SizedBox(width: 6),
                        Text(
                          'PORTFOLIO ACCESS GATEWAY',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondaryLight,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Wishang',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    'Informatics Engineer',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // Headline Menawan & Elegan
        Text(
          'Arsitektur Kode Bersih\n& Portofolio Interaktif.',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            fontSize: isMobile ? 32 : 46,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -1.0,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'Selamat datang di ruang portofolio digital berbasis Flutter Web. '
          'Platform ini mengintegrasikan seluruh capaian proyek',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
