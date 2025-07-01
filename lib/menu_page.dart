import 'dart:html' as html;
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'welfare_page.dart';
import 'personal_loan_topics_page.dart';
import 'sme_freedom_topics.dart';
import 'home_loan_topics_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _alignment;
  final List<_Particle> particles = List.generate(25, (_) => _Particle());
  bool isEasterEggRevealed = false;
  final List<String> suggestions = [
    "หัวข้อสินเชื่อบ้านน่าจะเหมาะกับคุณนะ!",
    "ลองดูสิทธิประโยชน์ใน Welfare ก่อนก็ได้นะ!",
    "SME Freedom อาจเป็นตัวช่วยธุรกิจของคุณ!",
    "หากกำลังมองหาเงินก้อน ลองดู Personal Loan ได้นะ!",
  ];
  late String currentSuggestion;
  bool _hasPlayedWelcomeSound = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _alignment = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: Tween(begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    currentSuggestion = (suggestions..shuffle()).first;

    Future.delayed(const Duration(seconds: 15), () {
      if (mounted) setState(() => isEasterEggRevealed = true);
    });

    // ✅ เล่นเสียง cfbothello.mp3
    Future.delayed(const Duration(milliseconds: 800), () {
      final hello =
          html.AudioElement('assets/sounds/.mp3')
            ..volume = 1.0
            ..style.display = 'none';

      html.document.body?.append(hello);
      hello.play().catchError((e) {
        print('❌ cfbothello error: $e');
      });

      hello.onEnded.listen((_) => hello.remove());
    });
  }

  void _playWelcomeSound() {
    if (_hasPlayedWelcomeSound) return;
    _hasPlayedWelcomeSound = true;
    final audio =
        html.AudioElement()
          ..src = 'assets/sounds/cfbothello.mp3'
          ..autoplay = true
          ..load();
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('ตั้งค่าผู้ใช้'),
            content: const Text(
              'ในอนาคต คุณจะสามารถเปลี่ยนชื่อ เปิด/ปิดเสียง หรือสลับโหมดแสงได้ที่นี่',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ปิด'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    final menuItems = [
      {
        'title': 'Home Loan',
        'widget': HomeLoanTopicsPage(onEnterSpeakText: (_) {}),
        'icon': Icons.home_outlined,
        'desc': 'หัวข้อสินเชื่อบ้าน',
        'tag': 'home',
        'subtitle': 'ทุกเรื่องบ้านในมือคุณ',
      },
      {
        'title': 'Welfare Topics',
        'widget': WelfarePage(onEnterSpeakText: (_) {}),
        'icon': Icons.volunteer_activism_outlined,
        'desc': 'หัวข้อเวลล์แฟร์',
        'tag': 'welfare',
        'subtitle': 'สิทธิประโยชน์เข้าใจง่าย',
      },
      {
        'title': 'SME Freedom',
        'widget': SmeFreedomTopicsPage(onEnterSpeakText: (_) {}),
        'icon': Icons.business_center_outlined,
        'desc': 'SME Freedom',
        'tag': 'sme',
        'subtitle': 'คู่คิดธุรกิจ SME',
      },
      {
        'title': 'Personal Loan',
        'widget': PersonalLoanTopicsPage(onEnterSpeakText: (_) {}),
        'icon': Icons.person_outline,
        'desc': 'สินเชื่อบุคคล',
        'tag': 'pl',
        'subtitle': 'ช่วยเหลือคุณทุกจังหวะชีวิต',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFBAA8F9), Color(0xFFD3C3FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Lottie.asset(
                          'assets/animations/menubot.json',
                          width: 130,
                          height: 130,
                          repeat: true,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome back!',
                              style: GoogleFonts.prompt(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'กรุณาเลือกหัวข้อที่คุณสนใจ',
                              style: GoogleFonts.prompt(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _ParticlePainter(particles, _controller.value),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: _alignment.value,
                      end: Alignment.center,
                      colors: const [
                        Color(0xFFFDFBFF),
                        Color(0xFFEDE7F6),
                        Color(0xFFE3F2FD),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 120, 16, 0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: Colors.deepPurple,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentSuggestion,
                        style: GoogleFonts.prompt(
                          fontSize: 14,
                          color: Colors.deepPurple.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: menuItems.length + (isEasterEggRevealed ? 1 : 0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWide ? 3 : 2,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 4 / 3,
                    ),
                    itemBuilder: (context, index) {
                      if (index >= menuItems.length) return const SizedBox();
                      final item = menuItems[index];
                      return _AnimatedMenuCard(
                        icon: item['icon'] as IconData,
                        title: item['title'] as String,
                        subtitle: item['subtitle'] as String,
                        desc: item['desc'] as String,
                        tag: item['tag'] as String,
                        destination: item['widget'] as Widget,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String desc;
  final String tag;
  final Widget destination;

  const _AnimatedMenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.tag,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final audio =
            html.AudioElement()
              ..src = 'assets/sounds/click.wav'
              ..volume = 1.0
              ..autoplay = true
              ..load()
              ..style.display = 'none';
        html.document.body?.append(audio);

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => destination,
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 6,
        color: Colors.white.withOpacity(0.85),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.deepPurple),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.prompt(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: GoogleFonts.prompt(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
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
    : radius = 6 + Random().nextDouble() * 10,
      position = Offset(Random().nextDouble(), Random().nextDouble()),
      speed = 0.12 + Random().nextDouble() * 0.25;

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
            ..color = Colors.white.withOpacity(0.05)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(offset, p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
