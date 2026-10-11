import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'profile_3d_inspector_dialog.dart';

/// Komponen Foto Profil 3D Spasial Interaktif:
/// - Dynamic 3D Perspective Tilt via Mouse Hover & Pan Drag (Matrix4 3D)
/// - Multi-plane Parallax: Deep Glow Halo, Outer 3D Gyroscope Rings, Inner Core Bevel
/// - Specular Gloss Reflection Glint yang bergerak dinamis mengikuti sudut datang cahaya
/// - 4 Satelit Teknologi Floating 3D (Flutter, Dart, PBO A+, Architect) yang mengorbit dengan kedalaman Z nyata
/// - Integrasi Avatar 3D Karakter Pengembang dengan fallback mulus
/// - Klik untuk membuka Konsol Inspeksi Profil 3D Full-Scale
class CircularProfileAvatar extends StatefulWidget {
  final double radius;
  final String imageUrl;
  final bool isInteractive;
  final VoidCallback? onTap;
  final bool? showOrbitBadges;
  final bool use3DAvatarAsset;
  final bool enable3DTilt;
  final bool enableIdleFloat;

  const CircularProfileAvatar({
    super.key,
    this.radius = 80,
    this.imageUrl =
        'assets/images/profile.jpeg',
    this.isInteractive = true,
    this.onTap,
    this.showOrbitBadges,
    this.use3DAvatarAsset = true,
    this.enable3DTilt = true,
    this.enableIdleFloat = true,
  });

  @override
  State<CircularProfileAvatar> createState() => _CircularProfileAvatarState();
}

class _CircularProfileAvatarState extends State<CircularProfileAvatar>
    with TickerProviderStateMixin {
  late AnimationController _idleFloatController;
  late AnimationController _rotationRingController;
  late AnimationController _orbitController;

  // Sudut rotasi 3D interaktif
  double _tiltX = 0.0;
  double _tiltY = 0.0;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    // 1. Controller untuk rotasi ring gradasi dasar
    _rotationRingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // 2. Controller untuk pergerakan satelit orbit 3D
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    // 3. Controller untuk animasi floating riak halus saat idle
    _idleFloatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    if (widget.enableIdleFloat) {
      _idleFloatController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _rotationRingController.dispose();
    _orbitController.dispose();
    _idleFloatController.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent details, Size size) {
    if (!widget.enable3DTilt) return;
    final center = Offset(size.width / 2, size.height / 2);
    final offset = details.localPosition - center;

    setState(() {
      _isHovered = true;
      // Normalisasi -1.0 s/d 1.0 lalu kalikan dengan sudut kemiringan maksimum (sekitar 0.35 rad = ~20 derajat)
      final normX = (offset.dx / (size.width / 2)).clamp(-1.0, 1.0);
      final normY = (offset.dy / (size.height / 2)).clamp(-1.0, 1.0);

      _tiltY = normX * 0.35;
      _tiltX = -normY * 0.35;
    });
  }

  void _onExit() {
    setState(() {
      _isHovered = false;
      _tiltX = 0.0;
      _tiltY = 0.0;
    });
  }

  void _handleClick() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      Profile3DInspectorDialog.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalSize = widget.radius * 2;
    final showSatellites = widget.showOrbitBadges ?? (widget.radius >= 65);

    return AnimatedBuilder(
      animation: Listenable.merge([
        _idleFloatController,
        _rotationRingController,
        _orbitController,
      ]),
      builder: (context, child) {
        // Hitung nilai floating idle halus saat kursor tidak aktif
        final idleOffsetX = widget.enableIdleFloat && !_isHovered
            ? sin(_idleFloatController.value * 2 * pi) * 0.08
            : 0.0;
        final idleOffsetY = widget.enableIdleFloat && !_isHovered
            ? cos(_idleFloatController.value * 2 * pi) * 0.06
            : 0.0;

        final currentTiltX = _tiltX + idleOffsetY;
        final currentTiltY = _tiltY + idleOffsetX;

        return MouseRegion(
          onHover: (e) => _onHover(e, Size(totalSize, totalSize)),
          onExit: (_) => _onExit(),
          cursor: widget.isInteractive
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: _handleClick,
            onPanUpdate: widget.enable3DTilt
                ? (details) {
                    setState(() {
                      _tiltY += details.delta.dx * 0.008;
                      _tiltX -= details.delta.dy * 0.008;
                      _tiltX = _tiltX.clamp(-0.45, 0.45);
                      _tiltY = _tiltY.clamp(-0.45, 0.45);
                    });
                  }
                : null,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: _isHovered ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              builder: (context, hoverVal, _) {
                final scale = 1.0 + (hoverVal * 0.05);

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0018) // Depth perspective factor
                    ..scale(scale)
                    ..rotateX(currentTiltX)
                    ..rotateY(currentTiltY),
                  child: SizedBox(
                    width: totalSize + (showSatellites ? 80 : 20),
                    height: totalSize + (showSatellites ? 80 : 20),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        // LAPISAN 0: Satelit Orbit Belakang (Z < 0)
                        if (showSatellites)
                          ..._buildSatellites(
                            radius: widget.radius,
                            isFront: false,
                            tiltX: currentTiltX,
                            tiltY: currentTiltY,
                          ),

                        // LAPISAN 1: Ambient Glow Halo di Belakang Avatar
                        _buildBackGlowHalo(totalSize, hoverVal, currentTiltX, currentTiltY),

                        // LAPISAN 2: 3D Outer Gyroscope Wireframe Rings
                        _buildGyroscopeRings(totalSize, currentTiltX, currentTiltY),

                        // LAPISAN 2.5: Solid Coin Chassis Backing (Ketebalan fisik 3D padat tanpa duplikasi)
                        _buildSolidCoinBacking(totalSize, currentTiltX, currentTiltY),

                        // LAPISAN 3-6: AVATAR DEPAN DENGAN TRANSLASI Z POSITIF (FRONT FACE 3D)
                        Transform(
                          transform: Matrix4.identity()..translate(0.0, 0.0, 6.0),
                          alignment: Alignment.center,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Rotating Gradient Border
                              _buildRotatingBorder(totalSize),

                              // Inner Dark Bevel Frame
                              Container(
                                width: totalSize + 4,
                                height: totalSize + 4,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.bgDark,
                                ),
                              ),

                              // AVATAR UTAMA (Image Asset 3D / Fallback Network)
                              _buildAvatarCore(totalSize),

                              // Hologram Specular Lens Reflection (Dynamic 3D Glint)
                              _buildGlassDomeGlare(totalSize, currentTiltX, currentTiltY),
                            ],
                          ),
                        ),

                        // LAPISAN 7: Satelit Orbit Depan (Z >= 0)
                        if (showSatellites)
                          ..._buildSatellites(
                            radius: widget.radius,
                            isFront: true,
                            tiltX: currentTiltX,
                            tiltY: currentTiltY,
                          ),

                        // LAPISAN 8: Micro Badge PBO A+ di Kiri Atas
                        _buildBadgeTopLeft(currentTiltX, currentTiltY),

                        // LAPISAN 9: Badge Status Aktif / 3D Live di Kanan Bawah
                        _buildBadgeBottomRight(currentTiltX, currentTiltY),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Lapisan 1: Deep Ambient Halo dengan Offset Cahaya 3D
  Widget _buildBackGlowHalo(double totalSize, double hoverVal, double tiltX, double tiltY) {
    final lightShift = Offset(-tiltY * 30, tiltX * 30);

    return Transform.translate(
      offset: lightShift,
      child: Container(
        width: totalSize + 30,
        height: totalSize + 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.35 + (hoverVal * 0.25)),
              blurRadius: 36 + (hoverVal * 16),
              spreadRadius: 4 + (hoverVal * 4),
            ),
            BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 48,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  /// Lapisan 2: Cincin Giroskop 3D Wireframe
  Widget _buildGyroscopeRings(double totalSize, double tiltX, double tiltY) {
    if (widget.radius < 50) return const SizedBox.shrink();

    return Transform.rotate(
      angle: _rotationRingController.value * 2 * pi * 0.5,
      child: Container(
        width: totalSize + 22,
        height: totalSize + 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.secondary.withOpacity(0.3),
            width: 1.2,
          ),
        ),
      ),
    );
  }

  /// Lapisan 2.5: Solid Coin Chassis Backing (Ketebalan fisik 3D padat tanpa duplikasi irisan)
  Widget _buildSolidCoinBacking(double totalSize, double tiltX, double tiltY) {
    if (widget.radius < 50) return const SizedBox.shrink();

    final depthOffset = Offset(-tiltY * 16, tiltX * 16);

    return Transform(
      transform: Matrix4.identity()..translate(0.0, 0.0, -4.0),
      alignment: Alignment.center,
      child: Transform.translate(
        offset: depthOffset,
        child: Container(
          width: totalSize + 14,
          height: totalSize + 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E293B),
                Color(0xFF0F172A),
                Color(0xFF070B14),
              ],
            ),
            border: Border.all(
              color: AppColors.secondary.withOpacity(0.55),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.85),
                offset: depthOffset * 0.9,
                blurRadius: 18,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.25),
                offset: depthOffset * 0.4,
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Lapisan 3: Rotating Gradient Ring
  Widget _buildRotatingBorder(double totalSize) {
    return Transform.rotate(
      angle: _rotationRingController.value * 2 * pi,
      child: Container(
        width: totalSize + 12,
        height: totalSize + 12,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: SweepGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary,
              AppColors.accent,
              AppColors.accentRose,
              AppColors.primary,
            ],
          ),
        ),
      ),
    );
  }

  /// Lapisan 5: Avatar Gambar 3D dengan Dukungan Asset Lokal & Fallback Aman
  Widget _buildAvatarCore(double totalSize) {
    final isAsset = widget.imageUrl.startsWith('assets/');

    return ClipOval(
      child: SizedBox(
        width: totalSize,
        height: totalSize,
        child: isAsset
            ? Image.asset(
                widget.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/avatar_3d.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildNetworkImage(totalSize);
                    },
                  );
                },
              )
            : (widget.use3DAvatarAsset
                ? Image.asset(
                    'assets/images/profile.jpeg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/avatar_3d.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildNetworkImage(totalSize);
                        },
                      );
                    },
                  )
                : _buildNetworkImage(totalSize)),
      ),
    );
  }

  Widget _buildNetworkImage(double totalSize) {
    return Image.network(
      widget.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: AppColors.bgCard,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.secondary,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColors.bgCard,
          child: const Icon(
            Icons.person_rounded,
            size: 64,
            color: AppColors.primaryLight,
          ),
        );
      },
    );
  }

  /// Lapisan 6: Specular Glass Lens Reflection (Glint highlight 3D dinamis)
  Widget _buildGlassDomeGlare(double totalSize, double tiltX, double tiltY) {
    return ClipOval(
      child: Container(
        width: totalSize,
        height: totalSize,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(
              (-tiltY * 2.5 - 0.25).clamp(-1.0, 1.0),
              (-tiltX * 2.5 - 0.25).clamp(-1.0, 1.0),
            ),
            radius: 0.75,
            colors: [
              Colors.white.withOpacity(0.38),
              Colors.white.withOpacity(0.06),
              Colors.transparent,
            ],
            stops: const [0.0, 0.4, 0.8],
          ),
        ),
      ),
    );
  }

  /// Lapisan Satelit Floating 3D yang Mengorbit (Depan vs Belakang)
  List<Widget> _buildSatellites({
    required double radius,
    required bool isFront,
    required double tiltX,
    required double tiltY,
  }) {
    final satellites = [
      {'label': 'Cybersecurity', 'icon': Icons.security_rounded, 'color': AppColors.secondary},
      {'label': 'IoT', 'icon': Icons.sensors_rounded, 'color': const Color(0xFF10B981)},
      {'label': 'Software Engineering', 'icon': Icons.code_rounded, 'color': AppColors.primaryLight},
      {'label': 'AI Engineering', 'icon': Icons.psychology_rounded, 'color': AppColors.accentRose},
    ];

    final widgets = <Widget>[];
    final orbitProgress = _orbitController.value * 2 * pi;

    for (int i = 0; i < satellites.length; i++) {
      final angle = orbitProgress + (i * (pi / 2));
      final z = sin(angle); // Z-depth: -1 (belakang) s/d +1 (depan)

      // Filter layer depan vs belakang
      if (isFront && z < 0) continue;
      if (!isFront && z >= 0) continue;

      final orbitRadiusX = radius + 34;
      final orbitRadiusY = radius * 0.42;

      final x = cos(angle) * orbitRadiusX + (tiltY * 20);
      final y = sin(angle) * orbitRadiusY + (-tiltX * 20);

      final scale = 0.82 + ((z + 1.0) * 0.16);
      final opacity = (0.4 + ((z + 1.0) * 0.3)).clamp(0.2, 1.0);

      widgets.add(
        Transform.translate(
          offset: Offset(x, y),
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bgDark.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: (satellites[i]['color'] as Color).withOpacity(0.7),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (satellites[i]['color'] as Color).withOpacity(0.35),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      satellites[i]['icon'] as IconData,
                      size: 11,
                      color: satellites[i]['color'] as Color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      satellites[i]['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: satellites[i]['color'] as Color,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  /// Badge Kiri Atas dengan Parallax 3D
  Widget _buildBadgeTopLeft(double tiltX, double tiltY) {
    if (widget.radius < 50) return const SizedBox.shrink();

    return Positioned(
      top: 0,
      left: 0,
      child: Transform.translate(
        offset: Offset(tiltY * 14, -tiltX * 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.bgSurface.withOpacity(0.95),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.secondary.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 10,
              ),
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.2),
                blurRadius: 12,
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.view_in_ar_rounded, size: 12, color: AppColors.secondary),
              SizedBox(width: 4),
              Text(
                '3D HOLO A+',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Badge Kanan Bawah dengan Parallax 3D
  Widget _buildBadgeBottomRight(double tiltX, double tiltY) {
    return Positioned(
      bottom: widget.radius < 50 ? 0 : 4,
      right: widget.radius < 50 ? 0 : 4,
      child: Transform.translate(
        offset: Offset(tiltY * 14, -tiltX * 14),
        child: Container(
          padding: const EdgeInsets.all(3.5),
          decoration: const BoxDecoration(
            color: AppColors.bgDark,
            shape: BoxShape.circle,
          ),
          child: Container(
            width: widget.radius < 50 ? 14 : 20,
            height: widget.radius < 50 ? 14 : 20,
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.7),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.check,
                size: widget.radius < 50 ? 9 : 12,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
