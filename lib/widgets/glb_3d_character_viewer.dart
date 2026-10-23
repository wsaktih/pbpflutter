import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../theme/app_colors.dart';

/// Widget Penampil Model 3D GLB Cyber Android Ber-Outfit (Tampilan Tunggal: Joget)
/// Menampilkan karakter 3D animated GLB interaktif berbalut outfit techwear oren-emas-hitam
/// dengan satu tampilan aksi tunggal: joget (dancing) yang energik & ritmis.
class Glb3DCharacterViewer extends StatefulWidget {
  final String glbAssetPath;
  final double width;
  final double height;
  final String? animationName;
  final bool autoRotate;

  const Glb3DCharacterViewer({
    super.key,
    this.glbAssetPath = 'assets/models/character.glb',
    this.width = 220,
    this.height = 295,
    this.animationName = 'joget',
    this.autoRotate = true,
  });

  @override
  State<Glb3DCharacterViewer> createState() => _Glb3DCharacterViewerState();
}

class _Glb3DCharacterViewerState extends State<Glb3DCharacterViewer> {
  late String _currentAnimation;

  @override
  void initState() {
    super.initState();
    _currentAnimation = widget.animationName ?? 'joget';
  }

  bool get _isTestingEnvironment {
    return WidgetsBinding.instance.runtimeType.toString().contains('TestWidgetsFlutterBinding');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          // 1. Model 3D Floating Bebas (Kotak Dihilangkan, Menyatu dengan Background)
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Bayangan lantai neon lembut di bawah karakter
                Positioned(
                  bottom: 4,
                  child: Container(
                    width: widget.width * 0.65,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.elliptical(widget.width * 0.65, 16),
                      ),
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.35),
                          AppColors.secondary.withOpacity(0.12),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Canvas WebGL 3D Model
                Positioned.fill(
                  child: _build3DModelView(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // 2. Tampilan Tunggal: Mode Joget Cyber (Techwear Outfit Edition)
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.secondary.withOpacity(0.45),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.85),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '🕺 Joget Cyber (Techwear)',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 4),

          // 3. Petunjuk Interaksi 360 yang Halus
          const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app_rounded, size: 10, color: AppColors.textMuted),
              SizedBox(width: 3),
              Text(
                'Putar 360° interaktif',
                style: TextStyle(
                  fontSize: 8.5,
                  color: AppColors.textMuted,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _build3DModelView() {
    // Di lingkungan pengujian otomatis (flutter test headless), render visual mockup
    // agar widget test tidak error karena WebView/WebGL native platform tidak ada di CPU test.
    if (_isTestingEnvironment) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_note_rounded, size: 48, color: AppColors.primary),
            const SizedBox(height: 6),
            Text(
              'Model GLB: Joget Techwear (Oren Emas)',
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ModelViewer(
      key: ValueKey('${widget.glbAssetPath}_$_currentAnimation'),
      src: widget.glbAssetPath,
      alt: 'Model 3D GLB Cyber Android Robot Joget Ber-Outfit Oren Emas',
      ar: false,
      autoRotate: widget.autoRotate,
      autoRotateDelay: 0,
      rotationPerSecond: '24deg',
      cameraControls: true,
      autoPlay: true,
      animationName: _currentAnimation,
      backgroundColor: Colors.transparent,
      disableZoom: false,
      cameraOrbit: '0deg 75deg 3.5m',
      cameraTarget: '0m 0.88m 0m',
      minCameraOrbit: 'auto auto 1.8m',
      maxCameraOrbit: 'auto auto 5.0m',
      shadowIntensity: 0.8,
      exposure: 1.15,
    );
  }
}
