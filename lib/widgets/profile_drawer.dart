import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/help_center_screen.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFE0F2FF), // ฟ้าอ่อน
            ),
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("ยังไม่เปิดให้เปลี่ยนรูป")),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/default_avatar.png'),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user?.email ?? 'ยังไม่เข้าสู่ระบบ',
                  style: const TextStyle(color: Colors.black87, fontSize: 16),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('ตั้งค่าโปรไฟล์'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('รายการที่ชื่นชอบ'),
            onTap: () {Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FavoritesScreen()), 
                    );
                  },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('ตะกร้าสินค้า'),
            onTap: () {Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartScreen()), 
                    );},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('ตั้งค่า'),
            onTap: () {Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()), 
                    );},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('ศูนย์ช่วยเหลือ'),
            onTap: () {Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HelpCenterScreen()), 
                    );},
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('ออกจากระบบ'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

