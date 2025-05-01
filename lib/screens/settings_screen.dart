import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ListView(
        children: [
          _buildSection('การสั่งซื้อ', [
            'รายการที่ซื้อแล้ว',
            'Pre - order ที่สั่งซื้อ',
          ]),
          Divider(color: Colors.brown.shade200),
          _buildSection('การตั้งค่า', [
            'ตั้งค่าการแสดงผล',
            'ตั้งค่าประสิทธิภาพ',
            'ตั้งค่าการแจ้งเตือน',
            'ตั้งค่าความเป็นส่วนตัว',
            'ตั้งค่าความปลอดภัย',
          ]),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('การตั้งค่า', style: TextStyle(color: Color(0xFFFFF8F0))),
      backgroundColor: Colors.brown,
      iconTheme: const IconThemeData(color: Color(0xFFFFF8F0)),
      elevation: 0,
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(color: Colors.brown.shade200, fontWeight: FontWeight.bold),
          ),
        ),
        ...items.map((item) => ListTile(
              title: Text(item, style: const TextStyle(color: Colors.brown)),
            )),
      ],
    );
  }
}