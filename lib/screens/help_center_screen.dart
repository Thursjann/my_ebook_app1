import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      'จำ Username หรือ Password ไม่ได้',
      'แสดงผลหนังสือออกจาก Cloud ต้องทำอย่างไร',
      'ชำระเงินแล้วแต่ยังไม่ได้รับหนังสือ',
      'หนังสือในชั้นหนังสือหายไปหมด',
      'ซื้อหนังสือผ่าน Apple ID แล้ว แต่ไม่พบหนังสือในชั้นหนังสือ',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Color(0xFFFFF8F0)),
        title: const Text('ศูนย์ช่วยเหลือ', style: TextStyle(color: Color(0xFFFFF8F0))),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('เลือกหัวข้อการติดต่อ'),
          const SizedBox(height: 10),
          ...topics.map((topic) => ExpansionTile(
                title: Text(topic, style: const TextStyle(color: Colors.brown)),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('คำตอบหรือขั้นตอนที่เกี่ยวข้อง...', style: TextStyle(color: Colors.brown)),
                  ),
                ],
              )),
          const SizedBox(height: 20),
          Divider(color: Colors.brown.shade200),
          const SizedBox(height: 10),
          _buildSectionHeader('ข้อมูลการติดต่อ'),
          const SizedBox(height: 10),
          _buildContactItem(Icons.location_on, 'มหาวิทยาลัยรังสิต เลขที่ 52/347 หมู่บ้านเมืองเอก ถ.พหลโยธิน ต.หลักหก อ.เมือง จ.ปทุมธานี 12000'),
          _buildContactItem(Icons.phone, '02-791-600'),
          _buildContactItem(Icons.email, 'info@rsu.ac.th'),
          const SizedBox(height: 20),
          _buildSectionHeader('แผนที่'),
          _buildMapPlaceholder(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.brown.shade200, fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  Widget _buildContactItem(IconData icon, String info) {
    return ListTile(
      leading: Icon(icon, color: Colors.brown),
      title: Text(info, style: const TextStyle(color: Colors.brown)),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: Text('แผนที่แสดงที่นี่')),
    );
  }
}