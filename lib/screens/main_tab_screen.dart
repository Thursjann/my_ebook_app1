import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'my_library_screen.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 0;

  final _pages = const [
    HomeScreen(),
    MyLibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.brown,
        selectedItemColor: Color(0xFFFFF8F0),
        unselectedItemColor: Colors.brown.shade200,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'ร้านค้า'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'คลังหนังสือ'),
        ],
      ),
    );
  }
}