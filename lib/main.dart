import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  preloadSounds(); // 🔊 preload เสียงไว้ก่อน
  runApp(const MyApp());
}

/// 🔊 โหลดไฟล์เสียงไว้ล่วงหน้าเพื่อให้ Flutter คัดลอกเข้า build
void preloadSounds() {
  final files = [
    'assets/sounds/welcome.mp3',
    'assets/sounds/cfbothello.mp3',
    'assets/sounds/pl.mp3',
    'assets/sounds/hl.mp3',
    'assets/sounds/sme.mp3',
    'assets/sounds/welfare.mp3',
  ];

  for (final file in files) {
    html.HttpRequest.request(file).catchError((e) {
      print('❌ preload fail: $file');
    });
  }

  // 🔥 บังคับ Flutter คัดลอก asset เสียงอย่างน้อย 1 ไฟล์
  final silentPlay =
      html.AudioElement('assets/sounds/welcome.mp3')
        ..volume = 0
        ..play();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CF Bot',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const HomePage(), // เริ่มที่หน้านี้
      debugShowCheckedModeBanner: false,
    );
  }
}
