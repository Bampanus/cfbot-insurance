import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';

class PersonalLoanTopicsPage extends StatefulWidget {
  final void Function(String text) onEnterSpeakText;
  const PersonalLoanTopicsPage({super.key, required this.onEnterSpeakText});

  @override
  State<PersonalLoanTopicsPage> createState() => _PersonalLoanTopicsPageState();
}

class _PersonalLoanTopicsPageState extends State<PersonalLoanTopicsPage> {
  bool hasSpoken = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!hasSpoken) {
      hasSpoken = true;
      final audio =
          html.AudioElement()
            ..src = 'assets/sounds/pl.mp3'
            ..volume = 1.0
            ..autoplay = true
            ..load();
      html.document.body!.append(audio);
    }
  }

  final List<Map<String, dynamic>> topics = [
    {
      'title': 'บทสนทนาที่ใช้ระหว่างลูกค้ากับเซลล์ Personal Loan',
      'audio': 'assets/sounds/conversation.mp3',
      'items': [
        {
          'title': 'บทสนทนาที่ใช้ระหว่างลูกค้ากับเซลล์ Personal Loan',
          'driveUrl':
              'https://drive.google.com/file/d/1czFq-Dahdq61_tur8mYnFa5GpektoDxv/preview',
        },
      ],
    },
    {
      'title': 'คำถามที่มักพบบ่อยในสินเชื่อ Personal Loan',
      'audio': 'assets/sounds/frequestion.mp3',
      'items': [
        {
          'title': 'คำถามที่พบบ่อยเกี่ยวกับสินเชื่อบุคคล Personal Loan',
          'driveUrl':
              'https://drive.google.com/file/d/1U466JkxfoU8vD29I71QUGR7_pB_6B5Ex/preview',
        },
      ],
    },
    {
      'title': 'ข้อโต้แย้งหรือข้อกังวลต่างๆของลูกค้า Personal Loan',
      'audio': 'assets/sounds/concern.mp3',
      'items': [
        {
          'title': 'ข้อโต้แย้งและข้อกังวลเกี่ยวกับสินเชื่อบุคคล Personal Loan',
          'driveUrl':
              'https://drive.google.com/file/d/1Z7duk0cZ_UilWb_TRZIUMLyhNMjBt2wv/preview',
        },
      ],
    },
    {
      'title': 'วิธีปิดการขายสินเชื่อ Personal Loan',
      'audio': 'assets/sounds/closedeal.mp3',
      'items': [
        {
          'title': 'เทคนิคการปิดการขายสินเชื่อบุคคล Personal Loan',
          'driveUrl':
              'https://drive.google.com/file/d/15oBHrkXGop5uArB-PFZP-HUFj-QFFYns/preview',
        },
      ],
    },
    {
      'title': 'บทสนทนาการนำเสนอประกัน PL Care',
      'audio': 'assets/sounds/insurance.mp3',
      'items': [
        {
          'title': 'บทสนทนาการนำเสนอประกัน PL Care',
          'driveUrl':
              'https://drive.google.com/file/d/1qNqLHbgy4Beec55PpP_yl3yxjNBnBOZH/view?usp=share_link',
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
          'หัวข้อสินเชื่อบุคคล',
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
