import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/help_center_screen.dart';
import '../screens/profile_settings_screen.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Container(
        color: const Color(0xFFFFF8F0), // พื้นหลังครีม
        child: Column(
          children: [
            _buildDrawerHeader(context, user),
            _buildDrawerItem(Icons.edit, 'ตั้งค่าโปรไฟล์', () => _navigate(context, const ProfileSettingsScreen())),
            _buildDrawerItem(Icons.shopping_cart, 'ตะกร้าสินค้า', () => _navigate(context, const CartScreen())),
            _buildDrawerItem(Icons.settings, 'ตั้งค่า', () => _navigate(context, const SettingsScreen())),
            _buildDrawerItem(Icons.help_outline, 'ศูนย์ช่วยเหลือ', () => _navigate(context, const HelpCenterScreen())),
            const Spacer(),
            _buildLogoutItem(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, User? user) {
    return DrawerHeader(
      decoration: const BoxDecoration(color: Colors.brown),
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 110),
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
          if (user != null) 
            Text(
              user.email!,
              style: const TextStyle(color: Color(0xFFFFF8F0), fontSize: 16),
            ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.brown),
      title: Text(title, style: const TextStyle(color: Colors.brown)),
      onTap: onTap,
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('ออกจากระบบ', style: TextStyle(color: Colors.red)),
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      },
    );
  }

  void _navigate(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}