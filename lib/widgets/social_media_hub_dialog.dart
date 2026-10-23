import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// Item Model untuk Sosial Media & Tautan
class SocialProfile {
  final String platform;
  final String handle;
  final String url;
  final IconData icon;
  final Color brandColor;
  final String description;

  const SocialProfile({
    required this.platform,
    required this.handle,
    required this.url,
    required this.icon,
    required this.brandColor,
    required this.description,
  });
}

/// Dialog Terpadu Hub Sosial Media & Tautan Profil
/// Menyatukan seluruh profil sosial media (GitHub, LinkedIn, Instagram, TikTok) dalam satu jendela interaktif.
class SocialMediaHubDialog extends StatelessWidget {
  const SocialMediaHubDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => const SocialMediaHubDialog(),
    );
  }

  static const List<SocialProfile> _profiles = [
    SocialProfile(
      platform: 'GitHub',
      handle: '@wsaktih',
      url: 'https://github.com/wsaktih',
      icon: Icons.code_rounded,
      brandColor: Colors.white,
      description: 'Repositori project, tugas, dan karya rekayasa software.',
    ),
    SocialProfile(
      platform: 'Instagram',
      handle: '@wishangskt',
      url: 'https://instagram.com/wishangskt',
      icon: Icons.camera_alt_rounded,
      brandColor: Color(0xFFE1306C),
      description: 'Sosial media pribadi.',
    ),
    SocialProfile(
      platform: 'TikTok',
      handle: '@wshngskt',
      url: 'https://tiktok.com/@wshngskt_',
      icon: Icons.music_note_rounded,
      brandColor: Color(0xFFEE1D52),
      description: 'Sosial media pribadi.',
    ),
  ];

  void _copyToClipboard(BuildContext context, SocialProfile profile) {
    Clipboard.setData(ClipboardData(text: profile.url));
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(profile.icon, color: profile.brandColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Tautan berhasil disalin!',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.bgCard,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.secondary.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.15),
                  blurRadius: 40,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Dialog
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    border: Border(bottom: BorderSide(color: AppColors.glassBorder.withOpacity(0.5))),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.hub_rounded, color: AppColors.secondary, size: 20),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HUB TAUTAN & SOSIAL MEDIA',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: AppColors.secondary,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Terhubung dengan Wishang',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                        tooltip: 'Tutup',
                      ),
                    ],
                  ),
                ),

                // Daftar Kartu Profil Terpadu
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: _profiles.map((profile) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildProfileCard(context, profile),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, SocialProfile profile) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgDark.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: profile.brandColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Icon Platform
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: profile.brandColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: profile.brandColor.withOpacity(0.4)),
            ),
            child: Icon(profile.icon, color: profile.brandColor, size: 20),
          ),
          const SizedBox(width: 14),

          // Detail Platform & Handle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      profile.platform,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      profile.handle,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: profile.brandColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  profile.description,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Tombol Salin Tautan
          ElevatedButton.icon(
            onPressed: () => _copyToClipboard(context, profile),
            icon: const Icon(Icons.copy_rounded, size: 14),
            label: const Text('Salin Link'),
            style: ElevatedButton.styleFrom(
              backgroundColor: profile.brandColor.withOpacity(0.15),
              foregroundColor: Colors.white,
              elevation: 0,
              side: BorderSide(color: profile.brandColor.withOpacity(0.5)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
