import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food/service/productService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final api = ProductService();
  final TextEditingController searchController = TextEditingController();

  List<dynamic> productResults = [];
  List<String> recentSearches = [];
  Timer? _debounce;
  String username = '';

  @override
  void initState() {
    super.initState();
    _initUserAndSearches();
    searchController.addListener(() => setState(() {}));
  }

  Future<void> _initUserAndSearches() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username') ?? '';
    _loadRecentSearches();
  }

  void _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches = prefs.getStringList('search_$username') ?? [];
    });
  }

  Future<void> _saveSearch(String keyword) async {
    if (keyword.trim().length < 3) return;

    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('search_$username') ?? [];

    history.remove(keyword);
    history.insert(0, keyword);

    if (history.length > 10) {
      history = history.sublist(0, 10);
    }

    await prefs.setStringList('search_$username', history);
    setState(() {
      recentSearches = history;
    });
  }

  void _searchProducts(String query) async {
    if (query.length < 3) {
      setState(() => productResults = []);
      return;
    }

    final data = await api.search(context, query);
    setState(() {
      productResults = data;
    });
  }

  void _clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_$username');
    setState(() {
      recentSearches = [];
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        title: _buildSearchField(),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child:
            searchController.text.isEmpty
                ? _buildDefaultSearchView()
                : _buildResultGrid(productResults),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 45,
      child: TextField(
        controller: searchController,
        onChanged: (val) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 300), () {
            _searchProducts(val.trim());
          });
        },
        decoration: InputDecoration(
          hintText: "ຄົ້ນຫາ",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          suffixIcon:
              searchController.text.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.green),
                    onPressed: () {
                      searchController.clear();
                      setState(() => productResults = []);
                    },
                  )
                  : null,
          prefixIcon: Icon(Icons.search, color: Colors.green),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.green),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 5.0),
        ),
      ),
    );
  }

  Widget _buildDefaultSearchView() {
    final displayRecentSearches =
        recentSearches.length > 5
            ? recentSearches.sublist(0, 5)
            : recentSearches;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (recentSearches.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ການຄົ້ນຫາລ່າສຸດ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.clear, size: 20, color: Colors.grey),
                  onPressed: _clearSearchHistory,
                ),
              ],
            ),
          ),
        if (displayRecentSearches.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              child: Wrap(
                spacing: 5,
                children:
                    displayRecentSearches
                        .map(
                          (item) => ActionChip(
                            backgroundColor: Colors.white,
                            label: Text(item),
                            onPressed: () {
                              searchController.text = item;
                              _searchProducts(item);
                            },
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 10),
          child: Text(
            "ສິນຄ້ານິຍົມ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildResultGrid(List<dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final item = data[index];
          return GestureDetector(
            onTap: () async {
              searchController.text = item['product_name'];
              await _saveSearch(item['product_name']);
            },
            child: Card(
              elevation: 2,
              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: item['image_url'] ?? '',
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget:
                        (context, url, error) =>
                            Icon(Icons.image, size: 50, color: Colors.green),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        item['product_name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        "${item['price']}₭/${item['unit_name']}",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
