import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class BookDetailScreen extends StatefulWidget {
  final Map<String, dynamic> book;
  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool alreadyPurchased = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfBookPurchased();
  }

  Future<void> _checkIfBookPurchased() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final orders = await FirebaseFirestore.instance
          .collection('orders')
          .where('email', isEqualTo: user.email)
          .get();
      for (var doc in orders.docs) {
        for (var item in (doc['items'] as List)) {
          if (item['title'] == widget.book['title']) {
            setState(() {
              alreadyPurchased = true;
              isLoading = false;
            });
            return;
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking purchased books: $e');
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title'], style: const TextStyle(color: Color(0xFFFFF8F0))),
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Color(0xFFFFF8F0)),
      ),
      backgroundColor: const Color(0xFFFFF8F0),
      body: isLoading ? const Center(child: CircularProgressIndicator()) : _buildContent(book),
    );
  }

  Widget _buildContent(Map<String, dynamic> book) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBookImage(book['image']),
          const SizedBox(height: 16),
          Text(book['title'] ?? '', style: _titleStyle()),
          const SizedBox(height: 8),
          if (book['author'] != null)
            Text('ผู้เขียน: ${book['author']}', style: _subtitleStyle()),
          const SizedBox(height: 8),
          Text('ราคา: ${book['price']} บาท', style: _priceStyle()),
          const SizedBox(height: 12),
          Text('หมวดหมู่: ${book['category'] ?? 'ไม่มีหมวดหมู่'}', style: _normalStyle()),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Text(book['description'] ?? 'ไม่มีคำอธิบาย', style: _normalStyle()),
            ),
          ),
          const SizedBox(height: 16),
          _buildActionButton(book),
        ],
      ),
    );
  }

  Widget _buildBookImage(String? imageUrl) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl ?? '',
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            height: 200,
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported, size: 50, color: Colors.brown),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(Map<String, dynamic> book) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          if (alreadyPurchased) {
            Navigator.pushNamed(context, '/reader', arguments: book);
          } else {
            Provider.of<CartProvider>(context, listen: false).addItem(book);
            Navigator.pushNamed(context, '/cart');
          }
        },
        icon: Icon(
          alreadyPurchased ? Icons.menu_book : Icons.shopping_cart,
          color: const Color(0xFFFFF8F0),
        ),
        label: Text(
          alreadyPurchased ? 'อ่านหนังสือ' : 'เพิ่มลงตะกร้า',
          style: const TextStyle(color: Color(0xFFFFF8F0)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          minimumSize: const Size.fromHeight(50),
        ),
      ),
    );
  }

  TextStyle _titleStyle() => const TextStyle(
    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown,
  );

  TextStyle _subtitleStyle() => TextStyle(
    fontSize: 16, color: Colors.brown.shade300,
  );

  TextStyle _priceStyle() => const TextStyle(
    fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold,
  );

  TextStyle _normalStyle() => const TextStyle(
    fontSize: 16, color: Colors.brown,
  );
}