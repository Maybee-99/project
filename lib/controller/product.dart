import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/controller/addProduct.dart';
import 'package:food/service/categoryService.dart';
import 'package:food/service/productService.dart';
import 'package:food/service/unitService.dart';
import 'package:iconsax/iconsax.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _ProductsState extends State<Products> {
  final productAIP = ProductService();
  final categoryAIP = CategoryService();
  final unitAIP = UnitService();
  bool _isLoading = true;
  List<dynamic> _products = [];
  List category = [];
  List unit = [];

  TextEditingController _productId = TextEditingController();
  TextEditingController _productName = TextEditingController();
  TextEditingController _stock = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _sale_price = TextEditingController();
  TextEditingController _catId = TextEditingController();
  TextEditingController _unitId = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();
    loadCategory();
    loadUnit();
  }

  void loadProducts() async {
    final products = await productAIP.getProducts(context);
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  void loadCategory() async {
    final data = await categoryAIP.getCategories(context);
    setState(() {
      category = data;
      _isLoading = false;
    });
  }

  void loadUnit() async {
    final data = await unitAIP.getUnit(context);
    setState(() {
      unit = data;
      _isLoading = false;
    });
  }

  void deleteProduct(int index) async {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("ລຶບສິນຄ້າ", style: TextStyle(fontSize: 16)),
          content: Text(
            "ທ່ານແນ່ໃຈຈະລຶບແທ້ບໍ່?",
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ຍົກເລີກ", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                productAIP
                    .deleteProduct(
                      context,
                      _products[index]['product_id'].toString(),
                    )
                    .then((value) {
                      if (value != null) {
                        setState(() {
                          _products.removeAt(index);
                        });
                        loadProducts();
                      }
                    });
                Navigator.pop(context);
              },
              child: Text("ຕົກລົງ", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 216, 219, 216),
      appBar: AppBar(
        title: const Text(
          "ຈັດການສິນຄ້າ",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed:
                () => setState(() {
                  loadProducts();
                  _isLoading = true;
                }),
            icon: Icon(Iconsax.refresh, size: 30),
          ),
          IconButton(
            icon: const Icon(Iconsax.add_circle, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProduct()),
              );
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.green))
              : _products.isEmpty
              ? Center(child: Text("ບໍ່ມີຂໍ້ມູນ"))
              : ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      radius: 12,
                                      child: Text(
                                        product['product_id'].toString(),
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      product['product_name'],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "ປະເພດ: ${product['category_name']}",
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "ຈຳນວນ: ${product['stock']} ${product['unit_name']} ",
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "ລາຄາຊື້: ${product['price']} ₭",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "ລາຄາຂາຍ: ${product['sale_price']} ₭",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_document,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    updateProduct(context, product);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    deleteProduct(index);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }

  void updateProduct(BuildContext context, Map<String, dynamic> product) {
    _productName.text = product['product_name'] ?? '';
    _price.text = product['price']?.toString() ?? '';
    _sale_price.text = product['sale_price']?.toString() ?? '';
    _stock.text = product['stock']?.toString() ?? '';
    _catId.text = product['category_id']?.toString() ?? '';
    _unitId.text = product['unit_id']?.toString() ?? '';
    _productId.text = product['product_id'].toString() ?? '';

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("ແກ້ໄຂສິນຄ້າ", style: TextStyle(fontSize: 16)),
          ),
          content: Container(
            height: 400,
            child: Material(
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _productName,
                        decoration: InputDecoration(
                          labelText: "ຊື່ສິນຄ້າ",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _price,
                        decoration: InputDecoration(
                          labelText: "ລາຄາຊື້",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 1.5,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        validator:
                            (value) =>
                                value!.isEmpty ? "ກະລຸນາໃສ່ລາຄາສິນຄ້າ" : null,
                        controller: _sale_price,
                        decoration: InputDecoration(
                          labelText: "ລາຄາຂາຍ",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 1.5,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _stock,
                        decoration: InputDecoration(
                          labelText: "ຈຳນວນ",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 1.5,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        validator:
                            (value) =>
                                _catId.text.isEmpty ? "ກະລຸນາເລອກປະເພດ" : null,
                        value:
                            category.any(
                                  (item) =>
                                      item['category_id'].toString() ==
                                      _catId.text,
                                )
                                ? _catId.text
                                : null,
                        items:
                            category.map<DropdownMenuItem<String>>((item) {
                              return DropdownMenuItem<String>(
                                value: item['category_id'].toString(),
                                child: Text(item['category_name']),
                              );
                            }).toList(),
                        decoration: InputDecoration(
                          labelText: 'ເລືອກປະເພດ',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _catId.text = value!;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        validator:
                            (value) =>
                                _unitId.text.isEmpty
                                    ? "ກະລຸນາເລືອກຫົວຫົວໜ່ວຍ"
                                    : null,
                        value:
                            unit.any(
                                  (item) =>
                                      item['unit_id'].toString() ==
                                      _unitId.text,
                                )
                                ? _unitId.text
                                : null,
                        items:
                            unit.map<DropdownMenuItem<String>>((item) {
                              return DropdownMenuItem<String>(
                                value: item['unit_id'].toString(),
                                child: Text(item['unit_name']),
                              );
                            }).toList(),
                        decoration: InputDecoration(
                          labelText: 'ເລືອກຫົວໜ່ວຍ',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _unitId.text = value!;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("ຍົກເລີກ"),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                productAIP
                                    .updateProduct(
                                      context,
                                      _productName.text,
                                      _price.text,
                                      _sale_price.text,
                                      _stock.text,
                                      _catId.text,
                                      _unitId.text,
                                      _productId.text,
                                    )
                                    .then((val) {
                                      if (val != null) {
                                        loadProducts();
                                        Navigator.pop(context);
                                      }
                                    });
                              }
                            },
                            child: Text("ບັນທຶກ"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
