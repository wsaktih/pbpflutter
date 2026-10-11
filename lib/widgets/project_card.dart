import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/portfolio_item.dart';
import '../theme/app_colors.dart';

/// Kartu Proyek Minimalis Elegan dengan Transisi Hover Halus
/// Menampilkan: Nama Project, Deskripsi Project, Output Project, Bahasa/Teknologi, serta Tautan Repositori GitHub & Demo.
class ProjectCard extends StatefulWidget {
  final PortfolioItem item;
  final int index;

  const ProjectCard({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  Future<void> _openExternalUrl(BuildContext context, String urlString) async {
    try {
      final uri = Uri.parse(urlString);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        _copyUrlToClipboard(context, urlString);
      }
    } catch (_) {
      if (context.mounted) {
        _copyUrlToClipboard(context, urlString);
      }
    }
  }

  void _copyUrlToClipboard(BuildContext context, String urlString) {
    Clipboard.setData(ClipboardData(text: urlString));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Tautan berhasil disalin: $urlString',
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.item.getCategoryColor();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -5.0 : 0.0),
        decoration: BoxDecoration(
          color: AppColors.bgSurface.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered ? color : color.withOpacity(0.35),
            width: _isHovered ? 1.6 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(_isHovered ? 0.25 : 0.08),
              blurRadius: _isHovered ? 26 : 16,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris Atas: Indeks Proyek & Badge Kategori & Tanggal
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.item.getItemIcon(), size: 14, color: color),
                      const SizedBox(width: 6),
                      Text(
                        'Project #${widget.index + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: color,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.bgDark,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Text(
                    widget.item.getCategoryBadge(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  widget.item.dateCreated,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 1. NAMA PROJECT (Font tidak terlalu bold agar mudah dibaca)
            Text(
              widget.item.title,
              style: const TextStyle(
                fontSize: 18.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 10),

            // 2. DESKRIPSI PROJECT
            Text(
              widget.item.shortDescription,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),

            const SizedBox(height: 16),

            // 3. OUTPUT PROJECT
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgDark.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'OUTPUT PROJECT:',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.item.projectOutput,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. BAHASA PEMROGRAMAN & TECH STACK
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.code_rounded, size: 14, color: AppColors.textMuted),
                SizedBox(width: 6),
                Text(
                  'Bahasa & Teknologi:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.item.techStack.map((tech) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    tech,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 18),

            // 5. TOMBOL TAUTAN (GITHUB REPOSITORY & LIVE DEMO)
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _openExternalUrl(context, widget.item.repoUrl),
                  icon: const Icon(Icons.code_rounded, size: 15),
                  label: const Text('Lihat Repo GitHub'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.glassBorder),
                    backgroundColor: AppColors.bgDark.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                if (widget.item.liveUrl != null)
                  ElevatedButton.icon(
                    onPressed: () => _openExternalUrl(context, widget.item.liveUrl!),
                    icon: const Icon(Icons.open_in_new_rounded, size: 15),
                    label: const Text('Buka Live Demo'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: AppColors.secondary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
