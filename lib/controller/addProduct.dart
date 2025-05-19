import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food/service/categoryService.dart';
import 'package:food/service/productService.dart';
import 'package:food/service/unitService.dart';
import 'package:food/widget/widget_reuse.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart' as universal_io;
import 'package:file_picker/file_picker.dart' as fp;

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController _productName = TextEditingController();
TextEditingController _stock = TextEditingController();
TextEditingController _price = TextEditingController();
TextEditingController _sale_price = TextEditingController();
TextEditingController _categoryId = TextEditingController();
TextEditingController _unitId = TextEditingController();

class _AddProductState extends State<AddProduct> {
  final productAPI = ProductService();
  final categoryAPI = CategoryService();
  final unitAPI = UnitService();
  final _categorries = [];
  final _units = [];
  bool isLoading = true;

  @override
  void initState() {
    loadCategory();
    loadUnit();
    super.initState();
  }

  void loadCategory() async {
    final categories = await categoryAPI.getCategories(context);
    setState(() {
      _categorries.addAll(categories);
      isLoading = false;
    });
  }

  void loadUnit() async {
    final units = await unitAPI.getUnit(context);
    setState(() {
      _units.addAll(units);
      isLoading = false;
    });
  }

  File? _file;
  Uint8List? webImage;
  ImagePicker imagePicker = ImagePicker();
  Future<void> fetchPhoto(ImageSource src) async {
    try {
      if (kIsWeb) {
        final result = await fp.FilePicker.platform.pickFiles(
          type: fp.FileType.custom,
          allowedExtensions: ['png', 'jpg', 'jpeg'],
          withData: true,
        );
        if (result != null && result.files.first.bytes != null) {
          setState(() {
            webImage = result.files.first.bytes;
          });
        }
      } else {
        final XFile? picked = await imagePicker.pickImage(
          source: src,
          maxHeight: 800,
          maxWidth: 800,
          imageQuality: 100,
        );
        if (picked != null) {
          setState(() {
            _file = File(picked.path);
          });
        }
      }
    } catch (e) {
      showAlert(context, "ຂໍ້ຄວາມ", "ເກີດຂໍ້ຜິດພາດ: $e", "ຕົກລົງ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ເພີ່ມສິນຄ້າ", style: TextStyle(fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                TextFormField(
                  validator:
                      (value) => value!.isEmpty ? "ກະລຸນາໃສ່ຊື່ສິນຄ້າ" : null,
                  controller: _productName,
                  decoration: InputDecoration(
                    labelText: "ຊື່ສິນຄ້າ",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1.5),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator:
                      (value) => value!.isEmpty ? "ກະລຸນາໃສ່ລາຄາສິນຄ້າ" : null,
                  controller: _price,
                  decoration: InputDecoration(
                    labelText: "ລາຄາຊື້",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1.5),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator:
                      (value) => value!.isEmpty ? "ກະລຸນາໃສ່ລາຄາສິນຄ້າ" : null,
                  controller: _sale_price,
                  decoration: InputDecoration(
                    labelText: "ລາຄາຂາຍ",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1.5),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator:
                      (value) => value!.isEmpty ? "ກະລຸນາໃສ່ຈຳນວນ" : null,
                  controller: _stock,
                  decoration: InputDecoration(
                    labelText: "ຈຳນວນ",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1.5),
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  validator:
                      (value) => value == null ? "ກະລຸນາເລືອກປະເພດ" : null,
                  value: _categoryId.text.isEmpty ? null : _categoryId.text,
                  onChanged: (value) {
                    setState(() {
                      _categoryId.text = value!;
                    });
                  },
                  items:
                      _categorries.map<DropdownMenuItem<String>>((category) {
                        return DropdownMenuItem<String>(
                          value: category['category_id'].toString(),
                          child: Text(category['category_name']),
                        );
                      }).toList(),
                  decoration: InputDecoration(
                    labelText: 'ເລືອກປະເພດ',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1.5),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  validator:
                      (value) => value == null ? "ກະລຸນາເລືອກຫົວໜ່ວຍ" : null,
                  value: _unitId.text.isEmpty ? null : _unitId.text,
                  onChanged: (value) {
                    setState(() {
                      _unitId.text = value!;
                    });
                  },
                  items:
                      _units.map<DropdownMenuItem<String>>((unit) {
                        return DropdownMenuItem<String>(
                          value: unit['unit_id'].toString(),
                          child: Text(unit['unit_name']),
                        );
                      }).toList(),
                  decoration: InputDecoration(
                    labelText: 'ເລືອກປະຫົວໜ່ວຍ',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1.5),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("ຮູບສິນຄ້າ", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    loadImage(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 178, 10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        _file != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _file!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                            : webImage != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                webImage!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                            : Icon(
                              Iconsax.image,
                              size: 50,
                              color: Colors.white,
                            ),
                  ),
                ),

                SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      onPressed: () async {
                        String imageUrl = "";
                        if (kIsWeb) {
                          if (webImage != null) {
                            imageUrl = await productAPI.upLoadImageToCloud(
                              webImage!,
                              context,
                            );
                          }
                        } else {
                          if (_file != null) {
                            Uint8List image = await _file!.readAsBytes();
                            imageUrl = await productAPI.upLoadImageToCloud(
                              image,
                              context,
                            );
                          }
                        }
                        if (_formKey.currentState!.validate()) {
                          productAPI.createProduct(
                            context,
                            _productName.text,
                            _price.text,
                            _sale_price.text,
                            _stock.text,
                            _categoryId.text,
                            _unitId.text,
                            imageUrl,
                          );
                          setState(() {
                            _productName.clear();
                            _price.clear();
                            _sale_price.clear();
                            _stock.clear();
                            _categoryId.clear();
                            _unitId.clear();
                            _file = null;
                            webImage = null;
                          });
                        }
                      },

                      child: Text("ບັນທຶກ", style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loadImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 110,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text("ເລືອກຮູບສິນຄ້າ", style: TextStyle(fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        fetchPhoto(ImageSource.camera);
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Icon(Iconsax.camera),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text("ຖ່າຍພາບ"),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        fetchPhoto(ImageSource.gallery);
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Icon(Iconsax.gallery),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text("ຮູບພາບ"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
