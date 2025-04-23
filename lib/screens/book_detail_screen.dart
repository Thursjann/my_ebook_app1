import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book['title'] ?? 'รายละเอียดหนังสือ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  book['image'],
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              book['title'] ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'ราคา: ${book['price'] ?? 'ไม่ระบุ'} บาท',
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 12),
            Text(
              book['description'] ?? 'ไม่มีคำอธิบาย',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("เพิ่มลงตะกร้าแล้ว")),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('เพิ่มลงตะกร้า'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
