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
  bool isLoading = true;
  String errorMessage = '';

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
    try {
      final String response = await rootBundle.loadString('assets/books.json');
      final Map<String, dynamic> data = json.decode(response);

      // แปลงข้อมูลจาก Map เป็น List โดยรวมทุกหมวดหมู่
      List<dynamic> allBooksList = [];
      data.forEach((category, books) {
        allBooksList.addAll(books);
      });

      setState(() {
        allBooks = allBooksList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'ไม่สามารถโหลดข้อมูล: $e';
        isLoading = false;
        loadSampleBooks();
      });
    }
  }

  void loadSampleBooks() {
    allBooks = [
      {
        "title": "หนังสือตัวอย่าง 1",
        "category": "การศึกษา",
        "price": 250,
        "image":
            "https://hot-thai-kitchen.com/wp-content/uploads/2013/03/tom-yum-goong-blog.jpg",
        "description": "รายละเอียดหนังสือตัวอย่าง 1"
      },
      {
        "title": "หนังสือตัวอย่าง 2",
        "category": "จิตวิทยา",
        "price": 350,
        "image": "https://via.placeholder.com/150?text=Book2",
        "description": "รายละเอียดหนังสือตัวอย่าง 2"
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = selectedCategory == 'ทั้งหมด'
        ? allBooks
        : allBooks.where((book) => book['category'] == selectedCategory).toList();

    final searchedBooks = searchController.text.isEmpty
        ? filteredBooks
        : filteredBooks
            .where((book) =>
                book['title'].toLowerCase().contains(searchController.text.toLowerCase()))
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
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : searchedBooks.isEmpty
                      ? Center(
                          child: Text(
                            searchController.text.isEmpty
                                ? 'ไม่พบหนังสือในหมวดหมู่นี้'
                                : 'ไม่พบหนังสือที่ค้นหา',
                          ),
                        )
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.5,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
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
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(10)),
                                        child: Image.network(
                                          book['image'],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                        loadingProgress.expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                              ),
                                            );
                                          },
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
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${book['price']} บาท',
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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