// product_detail_view.dart
import 'package:flutter/material.dart';
import 'package:food/service/cart_service.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailView extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int portion = 1;

  String formatPrice(int price) {
    final formatter = NumberFormat("#,##0.00");
    return "₭${formatter.format(price)}";
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final int basePrice = product['sale_price'];
    int totalPrice = portion * basePrice;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: product['image_url'] ?? '',
                  height: 200,
                  errorWidget:
                      (context, url, error) =>
                          const Icon(Icons.image, size: 100),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                product['product_name'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                product['description'] ?? 'ບໍ່ມີລາຍລະອຽດ',
                style: TextStyle(color: Colors.grey[800], height: 1.4),
              ),
              const Spacer(),
              const Text(
                'ຈຳນວນ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Icon(Icons.remove),
                    ),
                    color: Colors.red,
                    onPressed:
                        () => setState(() {
                          if (portion > 1) portion--;
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      '$portion',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Icon(Icons.add),
                    ),
                    color: Colors.red,
                    onPressed: () => setState(() => portion++),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      formatPrice(totalPrice),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // IMPORTANT: Include product_id for proper cart management
                        final cartItem = {
                          'product_id':
                              product['product_id'], // <--- ADD THIS LINE!
                          'product_name': product['product_name'],
                          'sale_price': basePrice,
                          'stock': portion,
                          'unit_name': product['unit_name'],
                          'image_url': product['image_url'],
                        };
                        CartService.addItem(cartItem);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ເພີ່ມເຂົ້າກະຕ່າແລ້ວ!')),
                        );
                      },
                      child: const Text(
                        'ເພີ່ມເຂົ້າກະຕ່າ',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
