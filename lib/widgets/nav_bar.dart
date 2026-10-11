import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../pages/login_page.dart';
import '../pages/mahasiswa_page.dart';
import 'profile_3d_inspector_dialog.dart';

class NavBar extends StatelessWidget {
  final BaseUser currentUser;
  final VoidCallback onScrollToPbo;
  final VoidCallback onScrollToProjects;
  final VoidCallback onScrollToAbout;

  const NavBar({
    super.key,
    required this.currentUser,
    required this.onScrollToPbo,
    required this.onScrollToProjects,
    required this.onScrollToAbout,
  });

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        title: const Text('Keluar dari Sesi?', style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text(
          'Anda sedang masuk sebagai ${currentUser.displayName} (${currentUser.getRoleTitle()}). Apakah ingin kembali ke gerbang login?',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AuthService().logout();
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => const LoginPage(),
                  transitionsBuilder: (context, a1, a2, child) =>
                      FadeTransition(opacity: a1, child: child),
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentRose),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.bgDark.withOpacity(0.8),
            border: const Border(bottom: BorderSide(color: AppColors.glassBorder, width: 1)),
          ),
          child: Row(
            children: [
              // Logo & Title
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'PBO',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Guest',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'Portfolio & OOP Laboratory',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              // Menu Navigasi Desktop
              if (isDesktop) ...[
                _buildNavLink('Tentang', onScrollToAbout),
                _buildNavLink('Sertifikat', onScrollToPbo),
                _buildNavLink('Koleksi Project', onScrollToProjects),
                _buildActionLink(
                  icon: Icons.view_in_ar_rounded,
                  label: 'Profil 3D Holo',
                  color: AppColors.secondaryLight,
                  isHighlighted: false,
                  onTap: () => Profile3DInspectorDialog.show(context),
                ),
                _buildActionLink(
                  icon: Icons.school_rounded,
                  label: 'Katalog Mahasiswa',
                  color: const Color(0xFF00A3FF),
                  isHighlighted: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MahasiswaPage(currentUser: currentUser)),
                  ),
                ),
                const SizedBox(width: 14),
              ],

              const SizedBox(width: 12),

              // Tombol Aksi Mobile (Profil 3D & Katalog Mahasiswa)
              if (!isDesktop) ...[
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MahasiswaPage(currentUser: currentUser)),
                  ),
                  icon: const Icon(Icons.school_rounded, color: Color(0xFF00A3FF), size: 20),
                  tooltip: 'Katalog Mahasiswa',
                ),
                IconButton(
                  onPressed: () => Profile3DInspectorDialog.show(context),
                  icon: const Icon(Icons.view_in_ar_rounded, color: AppColors.secondaryLight, size: 20),
                  tooltip: 'Inspeksi Profil 3D Hologram',
                ),
              ],

              // Tombol Keluar
              IconButton(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout_rounded, size: 20, color: AppColors.textMuted),
                tooltip: 'Keluar ke Halaman Login',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionLink({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isHighlighted ? color.withValues(alpha: 0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isHighlighted ? Border.all(color: color.withValues(alpha: 0.4)) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: isHighlighted ? Colors.white : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavLink(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
