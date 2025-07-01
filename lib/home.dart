import 'dart:html' as html;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'splash_transition_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _glowController;
  late AnimationController _waveController;
  final TextEditingController _controllerName = TextEditingController();
  final FocusNode _nameFocus = FocusNode();

  html.AudioElement? helloAudio;
  html.AudioElement? welcomeAudio;
  html.AudioElement? clickAudio;

  String userName = "";
  bool _hovering = false;
  bool _hasTyped = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    clickAudio =
        html.AudioElement('assets/sounds/click.wav')
          ..preload = 'auto'
          ..load()
          ..style.display = 'none';
    html.document.body?.append(clickAudio!);

    helloAudio =
        html.AudioElement('assets/sounds/cfbothello.mp3')
          ..preload = 'auto'
          ..load()
          ..style.display = 'none';
    html.document.body?.append(helloAudio!);

    welcomeAudio =
        html.AudioElement('assets/sounds/welcome.mp3')
          ..preload = 'auto'
          ..load()
          ..style.display = 'none';
    html.document.body?.append(welcomeAudio!);

    final storedName = html.window.localStorage['cfUser'] ?? '';
    if (storedName.isNotEmpty) {
      userName = storedName;
      _controllerName.text = storedName;
    }
  }

  void _greetAndNavigate() {
    final name = _controllerName.text.trim();
    if (name.isEmpty) return;
    html.window.localStorage['cfUser'] = name;

    // ✅ Click sound
    final click =
        html.AudioElement('assets/sounds/click.wav')
          ..volume = 1.0
          ..style.display = 'none';
    html.document.body?.append(click);
    click.play();

    // ✅ Welcome sound (เล่นก่อน)
    final welcome =
        html.AudioElement('assets/sounds/welcome.mp3')
          ..volume = 1.0
          ..style.display = 'none';
    html.document.body?.append(welcome);
    welcome
        .play()
        .then((_) {
          print('✅ welcome played');

          // ✅ cfbothello เล่นหลังจาก welcome จบ
          welcome.onEnded.listen((event) {
            final hello =
                html.AudioElement('assets/sounds/cfbothello.mp3')
                  ..volume = 1.0
                  ..style.display = 'none';
            html.document.body?.append(hello);
            hello
                .play()
                .then((_) {
                  print('✅ cfbothello played');
                })
                .catchError((e) {
                  print('❌ cfbothello error: $e');
                });
          });
        })
        .catchError((e) {
          print('❌ welcome error: $e');
        });

    // ✅ ค่อยเปลี่ยนหน้า หลัง delay
    Future.delayed(const Duration(milliseconds: 1850), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SplashTransitionPage(userName: name),
        ),
      );
    });
  }

  void _onNameChanged(String name) {
    setState(() {
      userName = name.trim().replaceAll(RegExp(r'[^฀-๿a-zA-Z0-9 ]'), '');
      _hasTyped = userName.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _glowController.dispose();
    _waveController.dispose();
    _controllerName.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ...List.generate(
            2,
            (i) => Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 120 + i * 20,
                child: AnimatedBuilder(
                  animation: _waveController,
                  builder:
                      (context, child) => RepaintBoundary(
                        child: CustomPaint(
                          painter: WavePainter(
                            _waveController.value + i * 0.5,
                            opacity: i == 0 ? 0.2 : 1.0,
                          ),
                        ),
                      ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeTransition(
                    opacity: _fadeController,
                    child: Column(
                      children: [
                        RepaintBoundary(
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Transform.translate(
                                offset: const Offset(-54, 0),
                                child: Lottie.asset(
                                  'assets/animations/botbot.json',
                                  fit: BoxFit.cover,
                                  repeat: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_hasTyped)
                          FadeInUp(
                            duration: const Duration(milliseconds: 400),
                            child: RepaintBoundary(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.95),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'สวัสดี $userName!',
                                  style: GoogleFonts.prompt(
                                    fontSize: 16,
                                    color: Colors.deepPurple.shade400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Text(
                          "WELCOME TO CF BOT",
                          style: GoogleFonts.prompt(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "ผู้ช่วยฝึกซ้อมบทสนทนางานขายของคุณ",
                          style: GoogleFonts.prompt(
                            fontSize: 17,
                            color: Colors.deepPurple.shade400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  RepaintBoundary(
                    child: TextField(
                      focusNode: _nameFocus,
                      controller: _controllerName,
                      onChanged: _onNameChanged,
                      onSubmitted: (_) => _greetAndNavigate(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.prompt(
                        fontSize: 18,
                        color: Colors.deepPurple.shade900,
                      ),
                      decoration: InputDecoration(
                        labelText: "ชื่อเล่นของคุณ",
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (userName.isNotEmpty)
                    Text(
                      "ยินดีที่ได้รู้จักนะ $userName!",
                      style: GoogleFonts.prompt(
                        fontSize: 16,
                        color: Colors.deepPurple.shade400,
                      ),
                    ),
                  const SizedBox(height: 24),
                  MouseRegion(
                    onEnter: (_) => setState(() => _hovering = true),
                    onExit: (_) => setState(() => _hovering = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(
                              _hovering ? 0.4 : 0.3,
                            ),
                            blurRadius: _hovering ? 40 : 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _greetAndNavigate,
                        icon: const Icon(Icons.arrow_forward_ios, size: 18),
                        label: Text(
                          'เริ่มต้นใช้งาน',
                          style: GoogleFonts.prompt(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          backgroundColor: const Color(0xFF9F85D9),
                          elevation: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    child: Text(
                      "CF BOT by kiatnakin phatra financial group",
                      style: GoogleFonts.prompt(
                        fontSize: 13,
                        color: Colors.deepPurple.shade200,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double progress;
  final double opacity;
  WavePainter(this.progress, {this.opacity = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..shader = LinearGradient(
            colors: [
              const Color(0xFFC3BFFF).withOpacity(opacity),
              const Color(0xFFD6F3FF).withOpacity(opacity),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 20.0;
    final waveLength = size.width / 1.5;
    final yOffset = 40.0;

    path.moveTo(0, yOffset);
    for (double x = 0; x <= size.width; x++) {
      final y =
          yOffset +
          sin((x / waveLength * 2 * pi) + (progress * 2 * pi)) * waveHeight;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return progress != oldDelegate.progress || opacity != oldDelegate.opacity;
  }
}
