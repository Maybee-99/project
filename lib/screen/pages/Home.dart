import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:food/controller/category.dart';
import 'package:food/controller/product.dart';
import 'package:food/controller/unit.dart';
import 'package:food/screen/view/Cart.dart';
import 'package:food/screen/view/ProductDetailView.dart';
import 'package:food/service/cart_service.dart';
import 'package:food/service/categoryService.dart';
import 'package:food/service/productService.dart';
import 'package:intl/intl.dart';

final List<String> imgList = [
  'assets/images/1.jpg',
  'assets/images/2.jpg',
  'assets/images/3.webp',
  'assets/images/4.jpg',
  'assets/images/5.jpg',
  'assets/images/6.jpg',
  'assets/images/7.jpg',
  'assets/images/8.jpg',
  'assets/images/9.jpg',
  'assets/images/10.jpg',
];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final productAPI = ProductService();
  final categoryAPI = CategoryService();
  bool _isLoading = true;
  List<dynamic> _categories = [];
  List<dynamic> _products = [];
  @override
  void initState() {
    loadCategorise();
    loadProducts();
    super.initState();
  }

  String formatPrice(int price) {
    final formatter = NumberFormat("#,##0");
    return "₭${formatter.format(price)}";
  }

  void loadCategorise() async {
    final categories = await categoryAPI.getCategories(context);
    setState(() {
      _categories = [
        {"category_name": "ທັງໝົດ"},
        ...categories,
      ];
      _isLoading = false;
    });
  }

  void loadProducts() async {
    final products = await productAPI.getProducts(context);
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  void loadProductsWithCategory(int index) async {
    final products = await productAPI.getProductsWithCate(
      context,
      _categories[index]['category_name'],
    );
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.green),
              child: Center(
                child: Text(
                  "ແອັບຂາຍສິນຄ້າອອນລາຍ",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            ListTile(
              leading: Icon(Icons.shopping_cart, color: Colors.green),
              title: Text(
                "ຈັດການສິນຄ້າ",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Products()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.inventory, color: Colors.green),
              title: Text(
                "ຈັດການຫົວໜ່ວຍ",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Unit()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.view_list, color: Colors.green),
              title: Text(
                "ຈັດການປະເພດ",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Category()),
                );
              },
            ),
            Divider(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CarouselSlider(
                items:
                    imgList.map((item) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            item,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      );
                    }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 2000),
                  height: 140,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                ),
              ),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "ປະເພດ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            category(),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "ສິນຄ້າ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            product(),
          ],
        ),
      ),
      floatingActionButton: Stack(
        clipBehavior: Clip.none,
        children: [
          FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: Colors.amber,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Cart()),
              );
            },
            child: const Icon(Icons.shopping_cart, color: Colors.black),
          ),
          if (CartService.cartItems.isNotEmpty)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  '${CartService.cartItems.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    
    );
  }

  int selectedIndex = 0;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget category() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: Colors.green));
    }
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            bool isAll = selectedIndex == index;
            return GestureDetector(
              onTap: () {
                onItemTapped(index);
                if (index == 0) {
                  loadProducts();
                } else {
                  loadProductsWithCategory(index);
                }
              },
              child: Container(
                width: 100,
                child: Card(
                  elevation: 3,

                  color: isAll ? Colors.green : Colors.white,
                  child: Center(
                    child: Text(
                      _categories[index]['category_name'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isAll ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget product() {
    if (_products.isEmpty) {
      return Center(child: CircularProgressIndicator(color: Colors.green));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GridView.builder(
        physics: PageScrollPhysics(),
        shrinkWrap: true,
        itemCount: _products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75, // Optional: better layout fit
        ),
        itemBuilder: (context, index) {
          final product = _products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailView(product: product),
                ),
              );
            },
            child: Card(
              elevation: 2,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: product['image_url'] ?? '',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      height: 140,
                      errorWidget:
                          (context, url, error) =>
                              Icon(Icons.image, size: 50, color: Colors.green),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        product['product_name'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "${formatPrice(product['sale_price'])}/ ${product['unit_name']}",
                        style: TextStyle(fontSize: 12, color: Colors.black87),
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

  // Widget product() {
  //   if (_products.isEmpty) {
  //     return Center(child: CircularProgressIndicator(color: Colors.green));
  //   }
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 5),
  //     child: GridView.builder(
  //       physics: PageScrollPhysics(),
  //       shrinkWrap: true,
  //       itemCount: _products.length,
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //       ),
  //       itemBuilder: (context, index) {
  //         return GestureDetector(
  //           child: Card(
  //             elevation: 2,
  //             color: Colors.white,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: [
  //                 ClipRRect(
  //                   borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(10),
  //                     topRight: Radius.circular(10),
  //                   ),
  //                   child: CachedNetworkImage(
  //                     imageUrl: _products[index]['image_url'] ?? '',
  //                     width: double.infinity,
  //                     fit: BoxFit.cover,
  //                     height: 90,
  //                     errorWidget:
  //                         (context, url, error) =>
  //                             Icon(Icons.image, size: 50, color: Colors.green),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: ListTile(
  //                     title: Text(
  //                       _products[index]['product_name'],
  //                       style: TextStyle(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     subtitle: Text(
  //                       "${_products[index]['sale_price']} ₭/ ${_products[index]['unit_name']}",
  //                       style: TextStyle(fontSize: 12, color: Colors.black87),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
