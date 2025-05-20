import 'package:flutter/material.dart';
import 'package:food/service/cart_service.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final NumberFormat _currencyFormat = NumberFormat("#,##0");

  double get total => CartService.cartItems.fold(
    0.0,
    (sum, item) =>
        sum +
        ((item['sale_price'] as int? ?? 0).toDouble()) *
            ((item['stock'] as int? ?? 0).toDouble()),
  );

  @override
  Widget build(BuildContext context) {
    final bool isCartEmpty = CartService.cartItems.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ກະຕ່າຂອງທ່ານ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body:
          isCartEmpty
              ? const Center(child: Text('ທ່ານຍັງບໍ່ໄດ້ເພີ່ມສິນຄ້າເຂົ້າກະຕ່າ!'))
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'ສິນຄ້າທີ່ເລືອກ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...CartService.cartItems
                      .map((product) => _buildProductItem(product))
                      .toList(),
                ],
              ),
      bottomNavigationBar:
          isCartEmpty
              ? null
              : Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey)),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'ລວມ: ₭${_currencyFormat.format(total)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text('ຊຳລະເງິນ'),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    double price = (product['sale_price'] as int? ?? 0).toDouble();
    int quantity = product['stock'] as int? ?? 1;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: _buildProductImage(product['image_url']),
        title: Text(product['product_name'] ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('₭${_currencyFormat.format(price)} / ${product['unit_name']}'),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () {
                    CartService.updateItemQuantity(product, quantity - 1);
                    setState(() {});
                  },
                ),
                Text('$quantity'),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  onPressed: () {
                    CartService.updateItemQuantity(product, quantity + 1);
                    setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.grey),
          onPressed: () {
            CartService.removeItem(product);
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const Icon(Icons.image, size: 50);
    } else if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => const Icon(Icons.broken_image),
      );
    } else {
      return Image.asset(imageUrl, width: 50, height: 50, fit: BoxFit.cover);
    }
  }
}
