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
  List<dynamic> allBooks = [];
  String selectedCategory = 'ทั้งหมด';
  TextEditingController searchController = TextEditingController();

  final List<String> categories = [
    'ทั้งหมด',
    'การศึกษา',
    'จิตวิทยา',
    'นิยายเกย์',
    'แฟนตาซี',
  ];

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
  final String response = await rootBundle.loadString('assets/books.json');
  final data = json.decode(response) as List;
  print("โหลดได้ ${data.length} เล่ม");
  print("ตัวอย่างหนังสือ: ${data[0]}");
  setState(() {
    allBooks = data;
  });
}

  @override
  Widget build(BuildContext context) {
    final filteredBooks = selectedCategory == 'ทั้งหมด'
        ? allBooks
        : allBooks.where((book) => book['category'] == selectedCategory).toList();

    final searchedBooks = searchController.text.isEmpty
        ? filteredBooks
        : filteredBooks
            .where((book) => book['title'].toLowerCase().contains(searchController.text.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ร้านหนังสือ'),
        backgroundColor: Colors.lightBlue[200],
      ),
      drawer: const ProfileDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหาหนังสือ...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category == selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: searchedBooks.isEmpty && searchController.text.isNotEmpty
                  ? const Center(child: Text('ไม่พบหนังสือที่ค้นหา'))
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: searchedBooks.length,
                      itemBuilder: (context, index) {
                        final book = searchedBooks[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookDetailScreen(book: book),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  book['image'],
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.image_not_supported),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                book['title'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${book['price']} บาท',
                                style: const TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
