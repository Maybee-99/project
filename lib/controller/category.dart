import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/service/categoryService.dart';
import 'package:iconsax/iconsax.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

TextEditingController _categoryNameController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _CategoryState extends State<Category> {
  final api = CategoryService();
  bool _isLoading = true;
  List<dynamic> _categories = [];
  @override
  void initState() {
    loadCategorise();
    super.initState();
  }

  void loadCategorise() async {
    final categories = await api.getCategories(context);
    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ຈັດການປະເພດ",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                loadCategorise();
                _categoryNameController.clear();
                _isLoading = true;
              });
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(child: Header()),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        api
                            .createCategory(
                              context,
                              _categoryNameController.text,
                            )
                            .then((value) {
                              if (value != null) {
                                setState(() {
                                  _categories.add(value);
                                  _categoryNameController.clear();
                                });
                                loadCategorise();
                              }
                            });
                      }
                    },
                    child: Text(
                      "ເພີ່ມ",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey, thickness: 1),
            SizedBox(height: 10),
            Expanded(child: category()),
          ],
        ),
      ),
    );
  }

  Widget category() {
    return _isLoading
        ? Center(child: CircularProgressIndicator(color: Colors.green))
        : _categories.isEmpty
        ? Text("ບໍ່ມີຂໍໍ່ມູນ")
        : ListView.builder(
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            return Expanded(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text(
                    _categories[index]['category_id'].toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  _categories[index]['category_name'].toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_document, color: Colors.blue),
                      onPressed: () {
                        updateCategory(index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteCategory(index);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
  }

  Widget Header() {
    return Material(
      color: Colors.transparent,
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _categoryNameController,
          validator: (value) => value!.isEmpty ? "ປ້ອນຊື່ປະເພດ" : null,
          decoration: InputDecoration(
            hintText: "ປ້ອນຊື່ປະເພດ",
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 1),
            ),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          ),
        ),
      ),
    );
  }

  void updateCategory(int index) {
    _categoryNameController.text =
        _categories[index]['category_name'].toString();
    final GlobalKey<FormState> _dialogformKey = GlobalKey<FormState>();
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("ແກ້ໄຂໝວດໝູ່", style: TextStyle(fontSize: 16)),
          content: Material(
            color: Colors.transparent,
            child: Form(
              key: _dialogformKey,
              child: TextFormField(
                controller: _categoryNameController,
                validator: (value) => value!.isEmpty ? "ປ້ອນຊື່ໝວດໝູ່" : null,
                decoration: InputDecoration(
                  hintText: "ປ້ອນຊື່ໝວດໝູ່",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _categoryNameController.clear();
              },
              child: Text("ຍົກເລີກ", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                if (_dialogformKey.currentState!.validate()) {
                  api
                      .updateCategory(
                        context,
                        _categoryNameController.text,
                        _categories[index]['category_id'].toString(),
                      )
                      .then((value) {
                        if (value != null) {
                          setState(() {
                            _categories[index] = value;
                            _categoryNameController.clear();
                          });
                          loadCategorise();
                        }
                      });
                  Navigator.pop(context);
                }
              },
              child: Text("ແກ້ໄຂ", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void deleteCategory(int index) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("ລຶບໝວດໝູ່", style: TextStyle(fontSize: 16)),
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
                api
                    .deleteCategory(
                      context,
                      _categories[index]['category_id'].toString(),
                    )
                    .then((value) {
                      if (value != null) {
                        setState(() {
                          _categories.removeAt(index);
                        });
                        loadCategorise();
                        _categoryNameController.clear();
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
}
