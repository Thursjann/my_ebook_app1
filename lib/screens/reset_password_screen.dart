import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final emailController = TextEditingController();
  String? message;

  void resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      setState(() {
        message = "ส่งลิงก์รีเซ็ตรหัสผ่านไปที่อีเมลแล้ว";
      });
    } catch (e) {
      setState(() {
        message = "เกิดข้อผิดพลาด กรุณาลองใหม่";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ลืมรหัสผ่าน")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text("กรอกอีเมลของคุณเพื่อรีเซ็ตรหัสผ่าน"),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "อีเมล"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: resetPassword,
              child: const Text("รีเซ็ตรหัสผ่าน"),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message!, style: const TextStyle(color: Colors.green)),
            ],
          ],
        ),
      ),
    );
  }
}
