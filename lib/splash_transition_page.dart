import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'menu_page.dart';

class SplashTransitionPage extends StatefulWidget {
  final String userName;
  const SplashTransitionPage({super.key, required this.userName});

  @override
  State<SplashTransitionPage> createState() => _SplashTransitionPageState();
}

class _SplashTransitionPageState extends State<SplashTransitionPage>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late AnimationController _textSwitchController;
  late AnimationController _fadeController;
  final List<_Particle> particles = List.generate(25, (_) => _Particle());

  final List<String> thoughts = ["กำลังพาคุณเข้าสู่ระบบ..."];
  int currentTextIndex = 0;

  @override
  void initState() {
    super.initState();

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _textSwitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();

    _cycleThoughts();
    _navigateLater();
  }

  void _navigateLater() {
    Future.delayed(const Duration(seconds: 4), () {
      _fadeController.reverse().then((_) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (_, __, ___) => const MenuPage(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
          ),
        );
      });
    });
  }

  void _cycleThoughts() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      _textSwitchController.forward(from: 0);
      setState(() {
        currentTextIndex = (currentTextIndex + 1) % thoughts.length;
      });
    }
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _textSwitchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = Colors.deepPurple.shade700;
    final lightColor = Colors.deepPurple.shade100;

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeController,
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _rippleController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _ParticlePainter(particles, _rippleController.value),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFF3EFFF), Color(0xFFE2F3F3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                );
              },
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _rippleController,
                        builder: (context, child) {
                          final scale = 1.0 + _rippleController.value * 0.5;
                          final opacity = 1.0 - _rippleController.value;
                          return Transform.scale(
                            scale: scale,
                            child: Opacity(
                              opacity: opacity,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: mainColor.withOpacity(0.12),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              mainColor.withOpacity(0.2),
                              lightColor.withOpacity(0.5),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: mainColor.withOpacity(0.25),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Lottie.asset(
                          'assets/animations/robot_wave.json',
                          repeat: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "สวัสดีคุณ ${widget.userName}!",
                    style: GoogleFonts.prompt(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeTransition(
                    opacity: _textSwitchController.drive(
                      CurveTween(curve: Curves.easeIn),
                    ),
                    child: Text(
                      thoughts[currentTextIndex],
                      style: GoogleFonts.prompt(
                        fontSize: 16,
                        color: Colors.deepPurple.shade300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Particle {
  Offset position;
  double radius;
  double speed;
  _Particle()
    : radius = 8 + Random().nextDouble() * 12,
      position = Offset(Random().nextDouble(), Random().nextDouble()),
      speed = 0.15 + Random().nextDouble() * 0.3;

  Offset animatedPosition(double t) {
    final dx = (position.dx + sin(t * speed)) % 1.0;
    final dy = (position.dy + cos(t * speed)) % 1.0;
    return Offset(dx, dy);
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double time;
  _ParticlePainter(this.particles, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final pos = p.animatedPosition(time);
      final offset = Offset(pos.dx * size.width, pos.dy * size.height);
      final paint =
          Paint()
            ..color = Colors.white.withOpacity(0.06)
            ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 6);
      canvas.drawCircle(offset, p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
