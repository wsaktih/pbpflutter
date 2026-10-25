import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';

/// Kartu Login Interaktif Bergaya Cyberpunk & Modern
/// Menyediakan formulir login tunggal (Custom Login) untuk memasukkan NIM dan Password.
/// Fitur visual: glassmorphism transparan, partikel melayang, HUD corner bracket,
/// spotlight & ripple kursor, border gradient berputar, scanline hologram,
/// typewriter subtitle, jam live, password strength meter, dan shake saat error.
class CyberLoginCard extends StatefulWidget {
  final Function(BaseUser user) onLoginSuccess;

  const CyberLoginCard({
    super.key,
    required this.onLoginSuccess,
  });

  @override
  State<CyberLoginCard> createState() => _CyberLoginCardState();
}

class _CyberLoginCardState extends State<CyberLoginCard>
    with TickerProviderStateMixin {
  static const _subtitle = 'Masukkan NIM dan password untuk membuka portofolio';

  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController(text: '2026-PBO-001');
  final _passwordController = TextEditingController(text: 'pbo_flutter2026');
  final _nimFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _clock = ValueNotifier<DateTime>(DateTime.now());
  Timer? _clockTimer;
  Timer? _typeTimer;

  bool _isPasswordVisible = false;
  bool _isAuthenticating = false;
  bool _isHovering = false;
  String _authStatusMessage = '';
  double _authProgress = 0;

  /// Posisi kursor lokal (pixel) untuk efek spotlight
  Offset _mousePos = Offset.zero;

  /// Posisi klik terakhir untuk efek ripple
  Offset _ripplePos = Offset.zero;

  late final List<_Particle> _particles;

  late AnimationController _pulseController;
  late AnimationController _loopController;
  late AnimationController _entranceController;
  late AnimationController _typeController;
  late AnimationController _shakeController;
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    final rnd = math.Random(7);
    _particles = List.generate(
      22,
      (_) => _Particle(
        x: rnd.nextDouble(),
        y: rnd.nextDouble(),
        radius: 0.8 + rnd.nextDouble() * 2.2,
        speed: 1 + rnd.nextInt(2).toDouble(),
        phase: rnd.nextDouble() * math.pi * 2,
        warm: rnd.nextBool(),
      ),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _typeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _typeTimer = Timer(const Duration(milliseconds: 700), () {
      if (mounted) _typeController.forward();
    });

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _passwordController.addListener(() => setState(() {}));

    _clockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _clock.value = DateTime.now(),
    );
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _typeTimer?.cancel();
    _clock.dispose();
    _pulseController.dispose();
    _loopController.dispose();
    _entranceController.dispose();
    _typeController.dispose();
    _shakeController.dispose();
    _rippleController.dispose();
    _nimController.dispose();
    _passwordController.dispose();
    _nimFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      _shakeController.forward(from: 0);
      return;
    }

    setState(() {
      _isAuthenticating = true;
      _authProgress = 0.15;
      _authStatusMessage = 'Menginisialisasi Protokol Guest Access...';
    });

    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() {
      _authProgress = 0.55;
      _authStatusMessage = 'Memverifikasi NIM Tamu: ${_nimController.text.trim()}...';
    });

    await Future.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    setState(() {
      _authProgress = 1.0;
      _authStatusMessage = 'Izin Terverifikasi. Selamat Datang Guest!';
    });

    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    final nim = _nimController.text.trim();
    final password = _passwordController.text.trim();

    await AuthService().loginWithNim(
      nim: nim,
      password: password,
    );

    final user = AuthService().currentUser;
    if (user != null && mounted) {
      widget.onLoginSuccess(user);
    }
  }

  Future<void> _handleGuestLogin() async {
    setState(() {
      _isAuthenticating = true;
      _authProgress = 0.25;
      _authStatusMessage = 'Menyiapkan Protokol Guest 1-Click Pass...';
    });

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() {
      _authProgress = 0.70;
      _authStatusMessage = 'Mengaktifkan Sesi Tamu Pengunjung...';
    });

    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() {
      _authProgress = 1.0;
      _authStatusMessage = 'Akses Terbuka. Selamat Datang Guest!';
    });

    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;

    await AuthService().loginAsGuest();

    final user = AuthService().currentUser;
    if (user != null && mounted) {
      widget.onLoginSuccess(user);
    }
  }

  /// Animasi masuk bertahap (fade + slide) untuk setiap elemen form
  Widget _stagger(int index, Widget child) {
    final start = (0.2 + index * 0.08).clamp(0.0, 0.9);
    final end = (start + 0.35).clamp(0.0, 1.0);
    final anim = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (context, c) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(-30 * (1 - anim.value), 0),
          child: c,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardEntrance = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
    );

    return AnimatedBuilder(
      animation: Listenable.merge([cardEntrance, _shakeController]),
      builder: (context, child) {
        final v = cardEntrance.value;
        final s = _shakeController.value;
        final shakeX = math.sin(s * math.pi * 8) * 12 * (1 - s);
        return Opacity(
          opacity: v.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(shakeX, 40 * (1 - v)),
            child: Transform.scale(
              scale: 0.92 + 0.08 * v,
              child: child,
            ),
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onHover: (e) => setState(() => _mousePos = e.localPosition),
        onExit: (_) => setState(() => _isHovering = false),
        child: Listener(
          onPointerDown: (e) {
            _ripplePos = e.localPosition;
            _rippleController.forward(from: 0);
          },
          child: _buildCard(),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return AnimatedBuilder(
      animation: Listenable.merge(
          [_pulseController, _loopController, _rippleController]),
      builder: (context, child) {
        final pulse = _pulseController.value;
        return Container(
          width: 480,
          constraints: const BoxConstraints(maxWidth: 480),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary
                    .withOpacity((_isHovering ? 0.22 : 0.10) + 0.06 * pulse),
                blurRadius: 50 + 20 * pulse,
                spreadRadius: -4,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Stack(
                    children: [
                      // Lapisan kaca (sangat transparan)
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.10),
                                AppColors.bgSurface.withOpacity(0.18),
                                Colors.white.withOpacity(0.04),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Grid titik halus + partikel melayang
                      Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: _ParticlePainter(
                              particles: _particles,
                              progress: _loopController.value,
                            ),
                          ),
                        ),
                      ),

                      // Scanline hologram bergerak
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Align(
                            alignment: Alignment(0, -1.4 + 2.8 * _loopController.value),
                            child: Container(
                              height: 90,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    AppColors.primary.withOpacity(0.07),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Spotlight mengikuti kursor
                      Positioned.fill(
                        child: IgnorePointer(
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: _isHovering ? 1 : 0,
                            child: CustomPaint(
                              painter: _SpotlightPainter(position: _mousePos),
                            ),
                          ),
                        ),
                      ),

                      // Ripple saat klik
                      Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: _RipplePainter(
                              center: _ripplePos,
                              progress: _rippleController.value,
                            ),
                          ),
                        ),
                      ),

                      // Konten form
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 26, 32, 28),
                        child: child,
                      ),
                    ],
                  ),
                ),
              ),

              // Border gradient berputar + glow
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _AnimatedBorderPainter(
                      progress: _loopController.value,
                      intensity: _isHovering ? 1.0 : 0.6 + 0.2 * pulse,
                    ),
                  ),
                ),
              ),

              // HUD corner brackets
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _CornerBracketPainter(
                      pulse: pulse,
                      active: _isHovering,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status bar: koneksi aman + jam live
          _stagger(0, _buildStatusBar()),

          const SizedBox(height: 18),

          // Header Akses Terminal Portofolio
          _stagger(1, _buildTerminalHeader()),

          const SizedBox(height: 24),

          // Input NIM Mahasiswa
          _stagger(
            2,
            _buildGlowField(
              focusNode: _nimFocus,
              glowColor: AppColors.secondary,
              child: TextFormField(
                controller: _nimController,
                focusNode: _nimFocus,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: _inputDecoration(
                  label: 'NIM (Nomor Induk Mahasiswa)',
                  hint: 'Contoh: 2026-PBO-001...',
                  icon: Icons.badge_rounded,
                  iconColor: AppColors.secondary,
                  focusColor: AppColors.secondary,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'NIM wajib diisi';
                  }
                  if (val.trim().length < 3) {
                    return 'NIM minimal 3 karakter';
                  }
                  return null;
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Input Password dengan Toggle Visibility
          _stagger(
            3,
            _buildGlowField(
              focusNode: _passwordFocus,
              glowColor: AppColors.primary,
              child: TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                onFieldSubmitted: (_) => _isAuthenticating ? null : _handleLogin(),
                decoration: _inputDecoration(
                  label: 'Password / Kata Sandi',
                  hint: 'Masukkan password...',
                  icon: Icons.lock_outline_rounded,
                  iconColor: AppColors.primaryLight,
                  focusColor: AppColors.primary,
                ).copyWith(
                  suffixIcon: IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (c, a) => RotationTransition(
                        turns: Tween(begin: 0.75, end: 1.0).animate(a),
                        child: ScaleTransition(scale: a, child: c),
                      ),
                      child: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        key: ValueKey(_isPasswordVisible),
                        color: AppColors.textMuted,
                        size: 20,
                      ),
                    ),
                    onPressed: () =>
                        setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Password wajib diisi';
                  }
                  if (val.length < 4) {
                    return 'Password minimal 4 karakter';
                  }
                  return null;
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Password strength meter
          _stagger(4, _buildStrengthMeter()),

          const SizedBox(height: 14),

          // Demo Credentials Info Helper (klik untuk isi otomatis)
          _stagger(5, _buildDemoChip()),

          const SizedBox(height: 20),

          // Tombol Masuk
          _stagger(
            6,
            _ShimmerButton(
              onPressed: _isAuthenticating ? null : _handleLogin,
              isLoading: _isAuthenticating,
            ),
          ),

          const SizedBox(height: 12),

          // Tombol Akses Cepat sebagai Guest (1-Klik Pass)
          _stagger(
            7,
            _GuestQuickButton(
              onPressed: _isAuthenticating ? null : _handleGuestLogin,
              isLoading: _isAuthenticating,
            ),
          ),

          const SizedBox(height: 18),

          // Status autentikasi jika sedang loading
          _stagger(
            8,
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (c, a) => FadeTransition(
                opacity: a,
                child: SizeTransition(sizeFactor: a, child: c),
              ),
              child: _isAuthenticating
                  ? _buildAuthenticatingStatus()
                  : _buildFooterInfo(),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    required Color iconColor,
    required Color focusColor,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: iconColor, size: 20),
      filled: true,
      fillColor: Colors.black.withOpacity(0.18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: focusColor, width: 1.5),
      ),
    );
  }

  /// Membungkus input dengan glow halus + garis energi di bawah saat fokus
  Widget _buildGlowField({
    required FocusNode focusNode,
    required Color glowColor,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: focusNode,
      builder: (context, c) {
        final focused = focusNode.hasFocus;
        return AnimatedScale(
          scale: focused ? 1.015 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: glowColor.withOpacity(focused ? 0.28 : 0.0),
                  blurRadius: focused ? 22 : 0,
                  spreadRadius: focused ? 1 : 0,
                ),
              ],
            ),
            child: c,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildStatusBar() {
    return Row(
      children: [
        // Titik status berkedip dengan ring memancar
        SizedBox(
          width: 14,
          height: 14,
          child: AnimatedBuilder(
            animation: _loopController,
            builder: (context, _) {
              final t = (_loopController.value * 3) % 1.0;
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 6 + 8 * t,
                    height: 6 + 8 * t,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accent.withOpacity(1 - t),
                        width: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent,
                      boxShadow: [
                        BoxShadow(color: AppColors.accent.withOpacity(0.8), blurRadius: 6),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'SECURE CHANNEL • ONLINE',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 1.2,
          ),
        ),
        const Spacer(),
        // Mini equalizer / sinyal
        AnimatedBuilder(
          animation: _loopController,
          builder: (context, _) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(5, (i) {
                final h = 4 +
                    8 *
                        (0.5 +
                            0.5 *
                                math.sin(_loopController.value * math.pi * 12 + i * 1.3));
                return Container(
                  width: 3,
                  height: h,
                  margin: const EdgeInsets.only(left: 2),
                  decoration: BoxDecoration(
                    color: Color.lerp(AppColors.primary, AppColors.secondary, i / 4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            );
          },
        ),
        const SizedBox(width: 10),
        ValueListenableBuilder<DateTime>(
          valueListenable: _clock,
          builder: (context, now, _) {
            String two(int n) => n.toString().padLeft(2, '0');
            return Text(
              '${two(now.hour)}:${two(now.minute)}:${two(now.second)}',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'Courier',
                fontWeight: FontWeight.w700,
                color: AppColors.secondaryLight,
                letterSpacing: 1,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTerminalHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Holographic Chip Icon (melayang + glow berdenyut + ring orbit)
        AnimatedBuilder(
          animation: Listenable.merge([_loopController, _pulseController]),
          builder: (context, child) {
            final t = _loopController.value * 2 * math.pi;
            return SizedBox(
              width: 60,
              height: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Orbit dot
                  Transform.translate(
                    offset: Offset(math.cos(t * 2) * 30, math.sin(t * 2) * 30),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondary,
                        boxShadow: [
                          BoxShadow(color: AppColors.secondary, blurRadius: 6),
                        ],
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, math.sin(t * 2) * 2.5),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary
                                .withOpacity(0.3 + 0.3 * _pulseController.value),
                            blurRadius: 14 + 12 * _pulseController.value,
                          ),
                        ],
                      ),
                      child: child,
                    ),
                  ),
                ],
              ),
            );
          },
          child: const Center(
            child: Icon(
              Icons.nfc_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.primaryLight.withOpacity(0.5)),
                    ),
                    child: const Text(
                      'GATEWAY VERIFIED',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildFingerprintScanner(),
                ],
              ),
              const SizedBox(height: 6),
              // Judul dengan gradient yang bergerak
              AnimatedBuilder(
                animation: _loopController,
                builder: (context, child) {
                  final p = _loopController.value;
                  return ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment(-1 + 4 * p - 1.5, 0),
                      end: Alignment(1 + 4 * p - 1.5, 0),
                      colors: const [
                        AppColors.textPrimary,
                        AppColors.secondaryLight,
                        AppColors.primaryLight,
                        AppColors.textPrimary,
                      ],
                      tileMode: TileMode.mirror,
                    ).createShader(bounds),
                    child: child,
                  );
                },
                child: const Text(
                  'Visitor Access Pass',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              // Subtitle efek mesin ketik
              AnimatedBuilder(
                animation: Listenable.merge([_typeController, _pulseController]),
                builder: (context, _) {
                  final count = (_subtitle.length * _typeController.value).round();
                  final typing = _typeController.value < 1;
                  return RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      children: [
                        TextSpan(text: _subtitle.substring(0, count)),
                        TextSpan(
                          text: '▌',
                          style: TextStyle(
                            color: AppColors.secondary.withOpacity(
                              typing ? 1 : (_pulseController.value > 0.5 ? 1 : 0),
                            ),
                          ),
                        ),
                        TextSpan(
                          text: _subtitle.substring(count),
                          style: const TextStyle(color: Colors.transparent),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Ikon sidik jari dengan garis pemindai naik-turun
  Widget _buildFingerprintScanner() {
    return SizedBox(
      width: 24,
      height: 24,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, _) {
          final v = Curves.easeInOutSine.transform(_pulseController.value);
          return Stack(
            children: [
              Icon(
                Icons.fingerprint_rounded,
                color: AppColors.secondary.withOpacity(0.5 + 0.5 * v),
                size: 24,
              ),
              Positioned(
                top: 22 * v,
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    boxShadow: [
                      BoxShadow(color: AppColors.accent.withOpacity(0.9), blurRadius: 6),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStrengthMeter() {
    final pass = _passwordController.text;
    int score = 0;
    if (pass.length >= 6) score++;
    if (pass.length >= 10) score++;
    if (RegExp(r'\d').hasMatch(pass)) score++;
    if (RegExp(r'[A-Z]').hasMatch(pass) || RegExp(r'[^A-Za-z0-9]').hasMatch(pass)) {
      score++;
    }
    const labels = ['Sangat Lemah', 'Lemah', 'Cukup', 'Kuat', 'Sangat Kuat'];
    final colors = [
      Colors.redAccent,
      Colors.deepOrangeAccent,
      AppColors.secondary,
      AppColors.accent,
      AppColors.accent,
    ];
    final color = colors[score];

    return Row(
      children: [
        Expanded(
          child: Row(
            children: List.generate(4, (i) {
              final active = i < score;
              return Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250 + i * 80),
                  curve: Curves.easeOut,
                  height: 4,
                  margin: EdgeInsets.only(right: i == 3 ? 0 : 5),
                  decoration: BoxDecoration(
                    color: active ? color : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: active
                        ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 6)]
                        : [],
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (c, a) => FadeTransition(
            opacity: a,
            child: SlideTransition(
              position: Tween(begin: const Offset(0, 0.5), end: Offset.zero).animate(a),
              child: c,
            ),
          ),
          child: Text(
            labels[score],
            key: ValueKey(score),
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color),
          ),
        ),
      ],
    );
  }

  Widget _buildDemoChip() {
    return _HoverScale(
      onTap: () {
        _nimController.text = '2026-PBO-001';
        _passwordController.text = 'pbo_flutter2026';
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Akun tamu demo terisi otomatis ✨'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(milliseconds: 1400),
          ),
        );
      },
      builder: (hover) => AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(hover ? 0.14 : 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primary.withOpacity(hover ? 0.5 : 0.22),
          ),
        ),
        child: Row(
          children: [
            AnimatedRotation(
              turns: hover ? 0.5 : 0,
              duration: const Duration(milliseconds: 400),
              child: Icon(
                hover ? Icons.auto_awesome_rounded : Icons.info_outline_rounded,
                size: 15,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Akun Tamu Demo: NIM: 2026-PBO-001 | Pass: pbo_flutter2026',
                style: TextStyle(
                  fontSize: 11.5,
                  color: AppColors.secondaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: hover ? 1 : 0,
              child: const Text(
                'ISI',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondary,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticatingStatus() {
    return Container(
      key: const ValueKey('auth-status'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.secondary.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    '> $_authStatusMessage',
                    key: ValueKey(_authStatusMessage),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryLight,
                      fontFamily: 'Courier',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _authProgress),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            builder: (context, v, _) {
              return Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        children: [
                          Container(height: 5, color: Colors.white.withOpacity(0.08)),
                          FractionallySizedBox(
                            widthFactor: v,
                            child: Container(
                              height: 5,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.primary, AppColors.secondary],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${(v * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooterInfo() {
    return Container(
      key: const ValueKey('footer'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 6,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shield_outlined, size: 14, color: AppColors.accent),
              SizedBox(width: 6),
              Text(
                'PBO Architecture Compliant',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
          Text(
            'Flutter Web 2026',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

/// Helper hover + tap dengan efek scale halus
class _HoverScale extends StatefulWidget {
  final Widget Function(bool hover) builder;
  final VoidCallback? onTap;

  const _HoverScale({required this.builder, this.onTap});

  @override
  State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hover ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: widget.builder(_hover),
        ),
      ),
    );
  }
}

/// Tombol login dengan efek shimmer berjalan, hover glow, dan press scale
class _ShimmerButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _ShimmerButton({required this.onPressed, required this.isLoading});

  @override
  State<_ShimmerButton> createState() => _ShimmerButtonState();
}

class _ShimmerButtonState extends State<_ShimmerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmer;
  bool _hover = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _pressed ? 0.96 : (_hover && enabled ? 1.03 : 1.0),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: enabled
                    ? [AppColors.primary, AppColors.secondary]
                    : [
                        AppColors.primary.withOpacity(0.5),
                        AppColors.secondary.withOpacity(0.5),
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(_hover && enabled ? 0.55 : 0.25),
                  blurRadius: _hover && enabled ? 28 : 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Shimmer sweep
                  AnimatedBuilder(
                    animation: _shimmer,
                    builder: (context, _) {
                      return Positioned.fill(
                        child: Align(
                          alignment: Alignment(-2.5 + 5 * _shimmer.value, 0),
                          child: Transform.rotate(
                            angle: 0.35,
                            child: Container(
                              width: 60,
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0),
                                    Colors.white.withOpacity(_hover ? 0.45 : 0.25),
                                    Colors.white.withOpacity(0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedRotation(
                        turns: _hover && enabled ? -0.05 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          widget.isLoading
                              ? Icons.hourglass_top_rounded
                              : (_hover ? Icons.lock_open_rounded : Icons.lock_rounded),
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.isLoading ? 'Memverifikasi...' : 'Masuk ke Portofolio',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: _hover && enabled ? 26 : 0,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: _hover && enabled ? 1 : 0,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(Icons.arrow_forward_rounded,
                                size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tombol sekunder interaktif untuk akses langsung 1-klik sebagai Guest
class _GuestQuickButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _GuestQuickButton({required this.onPressed, required this.isLoading});

  @override
  State<_GuestQuickButton> createState() => _GuestQuickButtonState();
}

class _GuestQuickButtonState extends State<_GuestQuickButton> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _pressed ? 0.97 : (_hover && enabled ? 1.02 : 1.0),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 44,
            decoration: BoxDecoration(
              color: _hover
                  ? AppColors.secondary.withOpacity(0.12)
                  : Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hover
                    ? AppColors.secondary.withOpacity(0.6)
                    : Colors.white.withOpacity(0.15),
                width: 1.2,
              ),
              boxShadow: _hover
                  ? [
                      BoxShadow(
                        color: AppColors.secondary.withOpacity(0.2),
                        blurRadius: 16,
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_pin_circle_rounded,
                  size: 17,
                  color: _hover ? AppColors.secondaryLight : AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Masuk Cepat sebagai Guest (1-Klik Pass)',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: _hover ? Colors.white : AppColors.textSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Data partikel melayang di dalam kartu
class _Particle {
  final double x;
  final double y;
  final double radius;
  final double speed;
  final double phase;
  final bool warm;

  const _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.phase,
    required this.warm,
  });
}

/// Partikel cahaya yang naik perlahan + garis penghubung antar partikel dekat
class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final points = <Offset>[];
    final opacities = <double>[];

    for (final p in particles) {
      final y = (p.y - progress * p.speed) % 1.0;
      final x = p.x + math.sin(progress * 2 * math.pi + p.phase) * 0.02;
      final pos = Offset(x * size.width, y * size.height);
      final o = math.sin(y * math.pi).clamp(0.0, 1.0) * 0.7;
      points.add(pos);
      opacities.add(o);

      final color = p.warm ? AppColors.primary : AppColors.secondary;
      canvas.drawCircle(
        pos,
        p.radius * 2.5,
        Paint()
          ..color = color.withOpacity(o * 0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawCircle(pos, p.radius, Paint()..color = color.withOpacity(o));
    }

    // Garis konstelasi antar partikel yang berdekatan
    const maxDist = 90.0;
    final line = Paint()..strokeWidth = 0.6;
    for (var i = 0; i < points.length; i++) {
      for (var j = i + 1; j < points.length; j++) {
        final d = (points[i] - points[j]).distance;
        if (d < maxDist) {
          final o = (1 - d / maxDist) * math.min(opacities[i], opacities[j]) * 0.35;
          line.color = AppColors.secondaryLight.withOpacity(o);
          canvas.drawLine(points[i], points[j], line);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => old.progress != progress;
}

/// Spotlight radial lembut yang mengikuti posisi kursor
class _SpotlightPainter extends CustomPainter {
  final Offset position;

  _SpotlightPainter({required this.position});

  @override
  void paint(Canvas canvas, Size size) {
    const radius = 220.0;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.primary.withOpacity(0.18),
          AppColors.secondary.withOpacity(0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: position, radius: radius));
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter old) => old.position != position;
}

/// Gelombang ripple yang memancar dari titik klik
class _RipplePainter extends CustomPainter {
  final Offset center;
  final double progress;

  _RipplePainter({required this.center, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;
    final eased = Curves.easeOutCubic.transform(progress);
    for (var i = 0; i < 2; i++) {
      final p = (eased - i * 0.15).clamp(0.0, 1.0);
      if (p <= 0) continue;
      canvas.drawCircle(
        center,
        p * 260,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * (1 - p) + 0.5
          ..color = (i == 0 ? AppColors.secondary : AppColors.primary)
              .withOpacity((1 - p) * 0.55),
      );
    }
    canvas.drawCircle(
      center,
      eased * 120,
      Paint()
        ..color = AppColors.secondary.withOpacity((1 - eased) * 0.10)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );
  }

  @override
  bool shouldRepaint(covariant _RipplePainter old) =>
      old.progress != progress || old.center != center;
}

/// Siku HUD futuristik di keempat sudut kartu
class _CornerBracketPainter extends CustomPainter {
  final double pulse;
  final bool active;

  _CornerBracketPainter({required this.pulse, required this.active});

  @override
  void paint(Canvas canvas, Size size) {
    final inset = active ? 10.0 : 14.0;
    final len = 16.0 + 6 * pulse + (active ? 6 : 0);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = AppColors.secondary.withOpacity(0.55 + 0.35 * pulse);

    final w = size.width, h = size.height;
    final corners = [
      [Offset(inset, inset + len), Offset(inset, inset), Offset(inset + len, inset)],
      [Offset(w - inset - len, inset), Offset(w - inset, inset), Offset(w - inset, inset + len)],
      [Offset(inset, h - inset - len), Offset(inset, h - inset), Offset(inset + len, h - inset)],
      [Offset(w - inset - len, h - inset), Offset(w - inset, h - inset), Offset(w - inset, h - inset - len)],
    ];
    for (final c in corners) {
      final path = Path()
        ..moveTo(c[0].dx, c[0].dy)
        ..lineTo(c[1].dx, c[1].dy)
        ..lineTo(c[2].dx, c[2].dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CornerBracketPainter old) =>
      old.pulse != pulse || old.active != active;
}

/// Border gradient yang berputar mengelilingi kartu dengan efek glow
class _AnimatedBorderPainter extends CustomPainter {
  final double progress;
  final double intensity;

  _AnimatedBorderPainter({required this.progress, required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect.deflate(0.75), const Radius.circular(28));

    final shader = SweepGradient(
      colors: [
        Colors.white.withOpacity(0.06),
        AppColors.primary.withOpacity(intensity),
        AppColors.secondary.withOpacity(intensity),
        Colors.white.withOpacity(0.06),
        Colors.white.withOpacity(0.06),
        AppColors.primaryLight.withOpacity(intensity * 0.6),
        Colors.white.withOpacity(0.06),
      ],
      stops: const [0.0, 0.12, 0.22, 0.34, 0.6, 0.72, 0.85],
      transform: GradientRotation(progress * 2 * math.pi),
    ).createShader(rect);

    // Glow luar
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..shader = shader
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Garis tajam
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant _AnimatedBorderPainter old) =>
      old.progress != progress || old.intensity != intensity;
}
