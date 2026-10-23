import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Background animasi minimalis elegan dengan partikel konstelasi,
/// gelombang aura neon, dan grid futuristik.
class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final bool showGrid;
  final bool showParticles;
  final bool showOrbs;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.showGrid = true,
    this.showParticles = true,
    this.showOrbs = true,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();
  Offset _mousePosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Inisialisasi partikel dinamis
    for (int i = 0; i < 48; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          vx: (_random.nextDouble() - 0.5) * 0.0006,
          vy: (_random.nextDouble() - 0.5) * 0.0006,
          radius: _random.nextDouble() * 2.2 + 1.2,
          baseColor: [
            AppColors.primary,
            AppColors.secondary,
            AppColors.accent,
            AppColors.primaryLight,
          ][_random.nextInt(4)],
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _mousePosition = event.localPosition;
        });
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Warna dasar kanvas gelap minimalis
          Container(
            color: AppColors.bgDark,
          ),

          // Layer Animasi Custom Painter
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: _CosmicAuraPainter(
                  progress: _controller.value,
                  particles: _particles,
                  mousePos: _mousePosition,
                  showGrid: widget.showGrid,
                  showParticles: widget.showParticles,
                  showOrbs: widget.showOrbs,
                ),
              );
            },
          ),

          // Lapisan konten utama di atas background
          widget.child,
        ],
      ),
    );
  }
}

class _Particle {
  double x;
  double y;
  double vx;
  double vy;
  double radius;
  Color baseColor;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.baseColor,
  });

  void update() {
    x += vx;
    y += vy;

    if (x < 0 || x > 1) vx = -vx;
    if (y < 0 || y > 1) vy = -vy;
  }
}

class _CosmicAuraPainter extends CustomPainter {
  final double progress;
  final List<_Particle> particles;
  final Offset mousePos;
  final bool showGrid;
  final bool showParticles;
  final bool showOrbs;

  _CosmicAuraPainter({
    required this.progress,
    required this.particles,
    required this.mousePos,
    required this.showGrid,
    required this.showParticles,
    required this.showOrbs,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Gambar Glowing Ambient Orbs (Aura Cahaya Halus)
    if (showOrbs) {
      _drawAuraOrbs(canvas, size);
    }

    // 2. Gambar Grid Matriks Halus
    if (showGrid) {
      _drawCyberGrid(canvas, size);
    }

    // 3. Gambar Partikel & Jaringan Garis Konstelasi
    if (showParticles) {
      _drawParticleConstellation(canvas, size);
    }

    // 4. Gambar Objek Geometris 3D Wireframe Melayang & Berotasi Dinamis
    _drawFloating3DObjects(canvas, size);
  }

  void _drawAuraOrbs(Canvas canvas, Size size) {
    final t = progress * 2 * pi;

    // Orb 1: Neon Cyber Orange (Bergerak elips lembut di kiri atas)
    final orb1Center = Offset(
      size.width * 0.25 + cos(t) * 90,
      size.height * 0.28 + sin(t) * 70,
    );
    final orb1Paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.primary.withOpacity(0.22),
          AppColors.primary.withOpacity(0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: orb1Center, radius: size.width * 0.35));
    canvas.drawCircle(orb1Center, size.width * 0.35, orb1Paint);

    // Orb 2: Radiant Gold Glow (Bergerak harmonis di kanan bawah)
    final orb2Center = Offset(
      size.width * 0.75 + sin(t * 0.8) * 110,
      size.height * 0.65 + cos(t * 0.8) * 80,
    );
    final orb2Paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.secondary.withOpacity(0.18),
          AppColors.secondary.withOpacity(0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: orb2Center, radius: size.width * 0.38));
    canvas.drawCircle(orb2Center, size.width * 0.38, orb2Paint);

    // Orb 3: Warm Amber Accent Pulse (Pusat tengah bawah)
    final orb3Center = Offset(
      size.width * 0.5 + cos(t * 1.2) * 80,
      size.height * 0.85 + sin(t * 1.2) * 60,
    );
    final orb3Paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.primaryLight.withOpacity(0.14),
          Colors.transparent,
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: orb3Center, radius: size.width * 0.28));
    canvas.drawCircle(orb3Center, size.width * 0.28, orb3Paint);
  }

  void _drawCyberGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.022)
      ..strokeWidth = 1.0;

    const double step = 64.0;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Titik persimpangan grid halus
    final dotPaint = Paint()..color = AppColors.primary.withOpacity(0.12);
    for (double x = 0; x < size.width; x += step * 2) {
      for (double y = 0; y < size.height; y += step * 2) {
        canvas.drawCircle(Offset(x, y), 1.5, dotPaint);
      }
    }
  }

  void _drawParticleConstellation(Canvas canvas, Size size) {
    final linePaint = Paint()..strokeWidth = 0.8;
    const double maxDistance = 110.0;

    // Perbarui posisi partikel
    for (final p in particles) {
      p.update();
    }

    // Hubungkan partikel yang berdekatan dengan garis neon lembut
    for (int i = 0; i < particles.length; i++) {
      final p1 = particles[i];
      final pos1 = Offset(p1.x * size.width, p1.y * size.height);

      for (int j = i + 1; j < particles.length; j++) {
        final p2 = particles[j];
        final pos2 = Offset(p2.x * size.width, p2.y * size.height);

        final dist = (pos1 - pos2).distance;
        if (dist < maxDistance) {
          final alpha = (1.0 - (dist / maxDistance)) * 0.16;
          linePaint.color = p1.baseColor.withOpacity(alpha);
          canvas.drawLine(pos1, pos2, linePaint);
        }
      }

      // Gambar titik partikel
      final dotPaint = Paint()..color = p1.baseColor.withOpacity(0.55);
      canvas.drawCircle(pos1, p1.radius, dotPaint);

      // Gambar halo partikel
      final glowPaint = Paint()..color = p1.baseColor.withOpacity(0.18);
      canvas.drawCircle(pos1, p1.radius * 2.2, glowPaint);
    }
  }

  /// 4. OBJEK GEOMETRIS 3D WIREFRAME MELAYANG DENGAN PROYEKSI MATEMATIKA PERSPEKTIF
  void _drawFloating3DObjects(Canvas canvas, Size size) {
    final t = progress * 2 * pi;

    // Objek 1: 3D Wireframe Cube di Area Kanan Atas
    final cubeCenter = Offset(
      size.width * 0.88 + cos(t * 0.6) * 24,
      size.height * 0.22 + sin(t * 0.6) * 18,
    );
    _draw3DWireframeCube(
      canvas: canvas,
      center: cubeCenter,
      scale: 36.0,
      rotX: t * 0.8 + (mousePos.dy / (size.height + 1) * 0.4),
      rotY: t * 1.2 + (mousePos.dx / (size.width + 1) * 0.4),
      rotZ: t * 0.5,
      color: AppColors.secondary,
    );

    // Objek 2: 3D Wireframe Octahedron di Area Kiri Bawah
    final octaCenter = Offset(
      size.width * 0.08 + sin(t * 0.5) * 20,
      size.height * 0.68 + cos(t * 0.5) * 18,
    );
    _draw3DWireframeOctahedron(
      canvas: canvas,
      center: octaCenter,
      scale: 34.0,
      rotX: -t * 0.9,
      rotY: t * 0.7,
      rotZ: t * 0.4,
      color: AppColors.primaryLight,
    );

    // Objek 3: 3D Wireframe Diamond di Area Kanan Bawah
    final diamondCenter = Offset(
      size.width * 0.92 + cos(t * 0.7) * 16,
      size.height * 0.78 + sin(t * 0.7) * 14,
    );
    _draw3DWireframeOctahedron(
      canvas: canvas,
      center: diamondCenter,
      scale: 26.0,
      rotX: t * 1.1,
      rotY: -t * 0.8,
      rotZ: t * 0.6,
      color: AppColors.primary,
    );
  }

  /// Proyeksi Matematika 3D ke 2D Layar dengan Rotasi Sumbu X, Y, Z dan Perspektif FOV
  Offset _project3D(
    double x,
    double y,
    double z,
    Offset center,
    double scale,
    double rotX,
    double rotY,
    double rotZ,
  ) {
    // Rotasi X
    final cosX = cos(rotX);
    final sinX = sin(rotX);
    final y1 = y * cosX - z * sinX;
    final z1 = y * sinX + z * cosX;

    // Rotasi Y
    final cosY = cos(rotY);
    final sinY = sin(rotY);
    final x2 = x * cosY + z1 * sinY;
    final z2 = -x * sinY + z1 * cosY;

    // Rotasi Z
    final cosZ = cos(rotZ);
    final sinZ = sin(rotZ);
    final x3 = x2 * cosZ - y1 * sinZ;
    final y3 = x2 * sinZ + y1 * cosZ;

    // Proyeksi Perspektif
    const double distance = 3.2;
    final double fov = distance / (distance + z2);

    return Offset(
      center.dx + x3 * scale * fov,
      center.dy + y3 * scale * fov,
    );
  }

  /// Menggambar Kubus Kawat 3D (3D Wireframe Cube)
  void _draw3DWireframeCube({
    required Canvas canvas,
    required Offset center,
    required double scale,
    required double rotX,
    required double rotY,
    required double rotZ,
    required Color color,
  }) {
    // 8 Titik Sudut Kubus
    const vertices = [
      [-1.0, -1.0, -1.0],
      [1.0, -1.0, -1.0],
      [1.0, 1.0, -1.0],
      [-1.0, 1.0, -1.0],
      [-1.0, -1.0, 1.0],
      [1.0, -1.0, 1.0],
      [1.0, 1.0, 1.0],
      [-1.0, 1.0, 1.0],
    ];

    // Proyeksikan seluruh titik ke layar 2D
    final projected = vertices
        .map((v) => _project3D(v[0], v[1], v[2], center, scale, rotX, rotY, rotZ))
        .toList();

    // 12 Pasang Garis Rusuk
    const edges = [
      [0, 1], [1, 2], [2, 3], [3, 0],
      [4, 5], [5, 6], [6, 7], [7, 4],
      [0, 4], [1, 5], [2, 6], [3, 7],
    ];

    final edgePaint = Paint()
      ..color = color.withOpacity(0.38)
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;

    final glowEdgePaint = Paint()
      ..color = color.withOpacity(0.12)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    for (final edge in edges) {
      final p1 = projected[edge[0]];
      final p2 = projected[edge[1]];
      canvas.drawLine(p1, p2, glowEdgePaint);
      canvas.drawLine(p1, p2, edgePaint);
    }

    // Titik Sudut Bercahaya (Glowing Vertex Dots)
    final vertexPaint = Paint()..color = color.withOpacity(0.75);
    for (final p in projected) {
      canvas.drawCircle(p, 2.2, vertexPaint);
    }
  }

  /// Menggambar Oktahedron Kawat 3D (3D Wireframe Octahedron)
  void _draw3DWireframeOctahedron({
    required Canvas canvas,
    required Offset center,
    required double scale,
    required double rotX,
    required double rotY,
    required double rotZ,
    required Color color,
  }) {
    // 6 Titik Sudut Oktahedron
    const vertices = [
      [0.0, -1.3, 0.0],  // Atas
      [0.0, 1.3, 0.0],   // Bawah
      [-1.0, 0.0, 0.0],  // Kiri
      [1.0, 0.0, 0.0],   // Kanan
      [0.0, 0.0, -1.0],  // Belakang
      [0.0, 0.0, 1.0],   // Depan
    ];

    final projected = vertices
        .map((v) => _project3D(v[0], v[1], v[2], center, scale, rotX, rotY, rotZ))
        .toList();

    // 12 Rusuk Oktahedron
    const edges = [
      [0, 2], [0, 3], [0, 4], [0, 5],
      [1, 2], [1, 3], [1, 4], [1, 5],
      [2, 4], [4, 3], [3, 5], [5, 2],
    ];

    final edgePaint = Paint()
      ..color = color.withOpacity(0.35)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final glowEdgePaint = Paint()
      ..color = color.withOpacity(0.12)
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke;

    for (final edge in edges) {
      final p1 = projected[edge[0]];
      final p2 = projected[edge[1]];
      canvas.drawLine(p1, p2, glowEdgePaint);
      canvas.drawLine(p1, p2, edgePaint);
    }

    final vertexPaint = Paint()..color = color.withOpacity(0.7);
    for (final p in projected) {
      canvas.drawCircle(p, 2.0, vertexPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CosmicAuraPainter oldDelegate) => true;
}
