import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _checkout(BuildContext context) async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'email': user?.email,
        'items': cart.items.map((item) => {
          'id': item['id'],
          'title': item['title'],
          'author': item['author'],
          'price': item['price'],
          'image': item['image'],
          'description': item['description'],
          'category': item['category'],
          'quantity': item['quantity'],
        }).toList(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      cart.clearCart();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('สั่งซื้อสำเร็จ! หนังสือถูกเพิ่มเข้า Library')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('สั่งซื้อไม่สำเร็จ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ตะกร้าสินค้า', style: TextStyle(color: Color(0xFFFFF8F0))),
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Color(0xFFFFF8F0)),
      ),
      body: cart.items.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(child: _buildCartList(context, cart)),
                _buildCheckoutButton(context),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Color(0xFFFFF8F0)),
          SizedBox(height: 16),
          Text('ไม่มีสินค้าในตะกร้า', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildCartList(BuildContext context, CartProvider cart) {
    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (ctx, index) {
        final item = cart.items[index];
        return Dismissible(
          key: Key('${item['id']}_$index'),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Color(0xFFFFF8F0)),
          ),
          confirmDismiss: (_) => _confirmDelete(context, item['title']),
          child: Card(
            color: const Color(0xFFFFF8F0),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              leading: Image.network(
                item['image'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, color: Colors.brown),
              ),
              title: Text(item['title']),
              subtitle: Text('${item['price']} บาท'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.brown),
                onPressed: () => _deleteItem(context, cart, item),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, String title) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('ลบ $title ออกจากตะกร้า?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('ยกเลิก')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('ลบ', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  void _deleteItem(BuildContext context, CartProvider cart, Map<String, dynamic> item) {
    cart.removeItem(item);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ลบ ${item['title']} เรียบร้อย')),
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => _checkout(context),
        icon: const Icon(Icons.payment, color: Color(0xFFFFF8F0)),
        label: const Text('ดำเนินการสั่งซื้อ', style: TextStyle(color: Color(0xFFFFF8F0))),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          padding: const EdgeInsets.symmetric(vertical: 16),
          minimumSize: const Size.fromHeight(50),
        ),
      ),
    );
  }
}