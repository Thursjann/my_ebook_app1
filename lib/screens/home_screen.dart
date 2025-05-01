import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/profile_drawer.dart';
import 'book_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  List<dynamic> allBooks = [];
  String selectedCategory = 'ทั้งหมด';
  bool isLoading = true;
  String errorMessage = '';

  final categories = ['ทั้งหมด', 'การศึกษา', 'จิตวิทยา', 'นิยายเกย์', 'แฟนตาซี'];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      final response = await rootBundle.loadString('assets/books.json');
      final data = json.decode(response) as Map<String, dynamic>;
      setState(() {
        allBooks = data.values.expand((books) => books).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'โหลดข้อมูลผิดพลาด: $e';
        isLoading = false;
      });
    }
  }

  List<dynamic> get filteredBooks {
    final books = selectedCategory == 'ทั้งหมด'
        ? allBooks
        : allBooks.where((b) => b['category'] == selectedCategory).toList();
    return searchController.text.isEmpty
        ? books
        : books.where((b) => b['title'].toLowerCase().contains(searchController.text.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ร้านหนังสือ', style: TextStyle(color: Color(0xFFFFF8F0))),
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Color(0xFFFFF8F0)),
      ),
      drawer: const ProfileDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildCategoryChips(),
            const SizedBox(height: 16),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            Expanded(child: isLoading ? _buildLoading() : _buildBookGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() => TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'ค้นหาหนังสือ...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (_) => setState(() {}),
      );

  Widget _buildCategoryChips() => SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: categories.map((category) {
            final isSelected = selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal:0.2),
              child: ChoiceChip(
                label: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.brown[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                selected: isSelected,
                selectedColor: Colors.brown,
                backgroundColor: const Color(0xFFFFF8F0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? Color(0xFFFFF8F0) : Colors.brown.shade200,
                  ),
                ),
                onSelected: (_) => setState(() => selectedCategory = category),
              ),
            );
          }).toList(),
        ),
      );

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());

  Widget _buildBookGrid() {
    if (filteredBooks.isEmpty) {
      return Center(
        child: Text(searchController.text.isEmpty
            ? 'ไม่พบหนังสือในหมวดหมู่นี้'
            : 'ไม่พบหนังสือที่ค้นหา'),
      );
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: 0.5, crossAxisSpacing: 8, mainAxisSpacing: 8,
      ),
      itemCount: filteredBooks.length,
      itemBuilder: (context, index) => _buildBookCard(filteredBooks[index]),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
        ),
        child: Card(
          color: const Color(0xFFFFF8F0),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    book['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, size: 40),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        book['title'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${book['price']} บาท',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}