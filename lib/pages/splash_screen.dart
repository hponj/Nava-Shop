import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/session_service.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _floatController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    final entranceCurve = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );
    _fadeAnimation = entranceCurve;
    _scaleAnimation = Tween<double>(begin: .72, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.elasticOut,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, .35),
      end: Offset.zero,
    ).animate(entranceCurve);

    _entranceController.forward();
    _floatController.repeat(reverse: true);
    cekSession();
  }

  /// Membaca status login langsung dari penyimpanan session.
  Future<void> cekSession() async {
    final results = await Future.wait([
      SessionService.isLogin(),
      // Menjaga splash tetap terlihat walau pembacaan session sangat cepat.
      Future<void>.delayed(const Duration(milliseconds: 1800)),
    ]);

    if (!mounted) return;
    final sudahLogin = results.first as bool;
    Navigator.pushReplacementNamed(context, sudahLogin ? '/home' : '/login');
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF9F9FF), Color(0xFFECEEFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const _BackgroundShapes(),
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          final value = _floatController.value;
                          return Transform.translate(
                            offset: Offset(0, math.sin(value * math.pi) * -8),
                            child: child,
                          );
                        },
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: _LogoMark(animation: _floatController),
                        ),
                      ),
                      const SizedBox(height: 30),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              const Text(
                                'Nava Shop',
                                style: TextStyle(
                                  color: AppTheme.ink,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Belanja mudah, temukan lebih banyak.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: const Color(0xFF697086),
                                      letterSpacing: .1,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: const _LoadingIndicator(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 28,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  'PILIHAN TERBAIK UNTUK HARIMU',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF9399AD),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  final Animation<double> animation;

  const _LogoMark({required this.animation});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 146,
      height: 146,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Transform.rotate(
              angle: animation.value * math.pi / 7,
              child: child,
            ),
            child: Container(
              width: 136,
              height: 136,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: .16),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(46),
              ),
            ),
          ),
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, Color(0xFF8282EF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: .28),
                  blurRadius: 30,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: const Icon(
              Icons.shopping_bag_rounded,
              color: Colors.white,
              size: 56,
            ),
          ),
          Positioned(
            top: 7,
            right: 10,
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: AppTheme.secondary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: AppTheme.primary,
            backgroundColor: Color(0xFFD9DCF5),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Menyiapkan pengalamanmu...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF7B8195),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _BackgroundShapes extends StatelessWidget {
  const _BackgroundShapes();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -70,
            child: _GlowCircle(
              size: 240,
              color: AppTheme.primary.withValues(alpha: .08),
            ),
          ),
          Positioned(
            left: -85,
            bottom: 80,
            child: _GlowCircle(
              size: 210,
              color: AppTheme.secondary.withValues(alpha: .07),
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height * .25,
            left: 34,
            child: const Icon(
              Icons.star_rounded,
              size: 18,
              color: Color(0x225B5BD6),
            ),
          ),
          Positioned(
            right: 40,
            bottom: MediaQuery.sizeOf(context).height * .25,
            child: const Icon(
              Icons.circle,
              size: 12,
              color: Color(0x3300A88F),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
