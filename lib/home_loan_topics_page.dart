import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';

class HomeLoanTopicsPage extends StatefulWidget {
  final void Function(String text) onEnterSpeakText;
  const HomeLoanTopicsPage({super.key, required this.onEnterSpeakText});

  @override
  State<HomeLoanTopicsPage> createState() => _HomeLoanTopicsPageState();
}

class _HomeLoanTopicsPageState extends State<HomeLoanTopicsPage> {
  bool hasSpoken = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!hasSpoken) {
      hasSpoken = true;
      final audio =
          html.AudioElement()
            ..src = 'assets/sounds/hl.mp3'
            ..autoplay = true
            ..volume = 1.0
            ..load();
      html.document.body?.append(audio);
    }
  }

  final List<Map<String, dynamic>> topics = [
    {
      'title': 'บทสนทนาที่ใช้ระหว่างลูกค้ากับเซลล์ Home Loan',
      'audio': 'assets/sounds/conversation.mp3',
      'items': [
        {
          'title': 'บทสนทนาที่ใช้ระหว่างลูกค้ากับเซลล์ Home Loan',
          'driveUrl':
              'https://drive.google.com/file/d/18unJc1HPJxoWm613sBLSLkZ4EljSE-1A/preview',
        },
      ],
    },
    {
      'title': 'คำถามที่มักพบบ่อยในสินเชื่อ Home Loan',
      'audio': 'assets/sounds/frequestion.mp3',
      'items': [
        {
          'title': 'คำถามที่มักพบบ่อยในสินเชื่อ Home Loan',
          'driveUrl':
              'https://drive.google.com/file/d/1IOECuwVHy1dFYJrhu6Lsc3osXXaB-CV3/preview',
        },
      ],
    },
    {
      'title': 'ข้อโต้แย้งหรือข้อกังวลต่างๆของลูกค้า Home Loan',
      'audio': 'assets/sounds/concern.mp3',
      'items': [
        {
          'title': 'ข้อโต้แย้งหรือข้อกังวลต่างๆของลูกค้า Home Loan',
          'driveUrl':
              'https://drive.google.com/file/d/1nVFt9-BeCwpIAlE3QPvW4cv26ut3MPBq/preview',
        },
      ],
    },
    {
      'title': 'วิธีปิดการขายสินเชื่อ Home Loan',
      'audio': 'assets/sounds/closedeal.mp3',
      'items': [
        {
          'title': 'วิธีปิดการขายสินเชื่อ Home Loan',
          'driveUrl':
              'https://drive.google.com/file/d/1rYijtHfkij6S4GZHpf-g7DbEdXo_6xnF/preview',
        },
      ],
    },
    {
      'title': 'บทสนทนาการนำเสนอประกัน (MRTA)',
      'audio': 'assets/sounds/insurance.mp3',
      'items': [
        {
          'title': 'บทสนทนาการนำเสนอประกัน MRTA',
          'driveUrl':
              'https://drive.google.com/file/d/1dp8OFtA5T2xraO021Owh_LN9JMA1ofi7/preview',
        },
      ],
    },
    {
      'title': 'บทสนทนาการนำเสนอประกัน (PA)',
      'audio': 'assets/sounds/insurance.mp3',
      'items': [
        {
          'title': 'บทสนทนาการนำเสนอประกัน PA',
          'driveUrl':
              'https://drive.google.com/file/d/1LRwfB7c4AFs5Cv-MVHrdTTJXnctRCMRr/preview',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'หัวข้อสินเชื่อบ้าน',
          style: GoogleFonts.prompt(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple.shade800,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          final items = topic['items'] as List;

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
                          'วิดีโอภายใน • ${items.length} หัวข้อ',
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
                    // ลบเสียงเก่าทั้งหมดก่อน
                    html.document
                        .querySelectorAll('audio')
                        .forEach((e) => e.remove());
                    // เล่นเสียงใหม่
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
              label: const Text('ดูวิดีโอ'),
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
