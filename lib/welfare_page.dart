import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';

class WelfarePage extends StatefulWidget {
  final void Function(String text) onEnterSpeakText;
  const WelfarePage({super.key, required this.onEnterSpeakText});

  @override
  State<WelfarePage> createState() => _WelfarePageState();
}

class _WelfarePageState extends State<WelfarePage> {
  bool hasSpoken = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!hasSpoken) {
      hasSpoken = true;
      final audio =
          html.AudioElement()
            ..src = 'assets/sounds/welfare.mp3'
            ..autoplay = true
            ..volume = 1.0
            ..load();
      html.document.body?.append(audio);
    }
  }

  final List<Map<String, dynamic>> topics = [
    {
      'title': 'MOU/NO MOU คืออะไร',
      'audio': 'assets/sounds/mounomou.mp3',
      'items': [
        {
          'title': 'เอกสารความแตกต่างระหว่าง MOU กับ NO MOU',
          'driveUrl':
              'https://drive.google.com/file/d/17iZ8Hzp2ZvPQPTLbPeqDNkqgda5vu1oU/view?usp=share_link',
        },
      ],
    },
    {
      'title': 'คู่มือ Chronos Agent Tool',
      'audio': 'assets/sounds/chronos.mp3',
      'items': [
        {
          'title': 'คู่มือ Chronos Agent Tool',
          'driveUrl':
              'https://drive.google.com/file/d/1_aYn61gu7yzkyizR1x6zoP3H78UmXZkK/view?usp=share_link',
        },
      ],
    },
    {
      'title': 'การ DipChip',
      'audio': 'assets/sounds/dipchip.mp3',
      'items': [
        {
          'title': 'DipChip',
          'driveUrl':
              'https://drive.google.com/file/d/1Q1FHY4JIqNF4rgYfzeqt6iqe2fPCSSmf/view?usp=share_link',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        title: Text(
          'หัวข้อ Welfare',
          style: GoogleFonts.prompt(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          final items = topic['items'] as List;

          final bool isMouOrChronos =
              topic['title'].contains('MOU') ||
              topic['title'].contains('Chronos');

          return FadeInUp(
            duration: Duration(milliseconds: 300 + index * 60),
            child: Container(
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                childrenPadding: const EdgeInsets.only(bottom: 16),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic['title'],
                      style: GoogleFonts.prompt(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple.shade900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_filled,
                          size: 18,
                          color: Colors.deepPurple.shade200,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isMouOrChronos
                              ? 'เอกสารภายใน • ${items.length} หัวข้อ'
                              : 'วิดีโอภายใน • ${items.length} หัวข้อ',
                          style: GoogleFonts.prompt(
                            fontSize: 13,
                            color: Colors.deepPurple.shade300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onExpansionChanged: (expanded) {
                  html.AudioElement('assets/sounds/click.wav')
                    ..volume = 1.0
                    ..play();
                  if (expanded) {
                    html.document
                        .querySelectorAll('audio')
                        .forEach((e) => e.remove());
                    final audioPath = topic['audio'];
                    if (audioPath != null) {
                      final audio =
                          html.AudioElement()
                            ..src = audioPath
                            ..autoplay = true
                            ..volume = 1.0
                            ..load();
                      html.document.body?.append(audio);
                    }
                  }
                },
                children: List<Widget>.from(
                  items.map(
                    (item) => _buildSubTopic(item as Map<String, String>),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubTopic(Map<String, String> item) {
    final String title = item['title']!;
    final String url = item['driveUrl']!;
    final bool isMouTopic = title.contains('MOU');
    final bool isChronosTopic = title.contains('Chronos');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              Icons.video_library,
              size: 28,
              color: Colors.deepPurple.shade300,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: GoogleFonts.prompt(fontSize: 15)),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                html.AudioElement('assets/sounds/click.wav')
                  ..volume = 1.0
                  ..play();
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.play_circle_outline),
              label: Text(
                (isMouTopic || isChronosTopic) ? 'กดอ่านตรงนี้' : 'ดูวิดีโอ',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.deepPurple.shade200),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
