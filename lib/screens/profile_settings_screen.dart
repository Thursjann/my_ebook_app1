import 'package:flutter/material.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      'แก้ไขข้อมูลส่วนตัว',
      'แก้ไขอีเมล',
      'เปลี่ยนรหัสผ่าน',
      'การเชื่อมต่อบัญชี',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Color(0xFFFFF8F0))),
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Color(0xFFFFF8F0)),
        elevation: 0,
      ),
      body: ListView(
        children: options.map((option) => ListTile(
          title: Text(option, style: const TextStyle(color: Colors.brown)),
        )).toList(),
      ),
    );
  }
}