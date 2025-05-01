import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/cart_screen.dart';
import 'providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StoryNest',
        theme: ThemeData(
          primarySwatch: Colors.brown, 
          scaffoldBackgroundColor:const Color(0xFFFFF8F0), // ✅ พื้นหลังครีม/ขาวนวล
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.brown), // ข้อความทั่วไป
            titleLarge: TextStyle(color: Colors.brown), // หัวเรื่อง
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.brown.shade700),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.brown),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.brown.shade200),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
        },
      ),
    );
  }
}