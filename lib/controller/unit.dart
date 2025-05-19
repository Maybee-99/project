import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/service/unitService.dart';

class Unit extends StatefulWidget {
  const Unit({super.key});

  @override
  State<Unit> createState() => _CategoryState();
}

TextEditingController unitController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _CategoryState extends State<Unit> {
  final api = UnitService();
  bool _isLoading = true;
  List<dynamic> _unit = [];
  @override
  void initState() {
    loadUnit();
    super.initState();
  }

  void loadUnit() async {
    final unit = await api.getUnit(context);
    setState(() {
      _unit = unit;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ຈັດການຫົວໜ່ວຍ",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                loadUnit();
                unitController.clear();
                _isLoading = true;
              });
            },
            icon: Icon(Icons.refresh, color: Colors.black),
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
                        api.createUnit(context, unitController.text).then((
                          value,
                        ) {
                          if (value != null) {
                            setState(() {
                              _unit.add(value);
                              unitController.clear();
                            });
                            loadUnit();
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
            SizedBox(height: 10),
            Expanded(child: units()),
          ],
        ),
      ),
    );
  }

  Widget units() {
    return _isLoading
        ? Center(child: CircularProgressIndicator(color: Colors.green))
        : _unit.isEmpty
        ? Text("ບໍ່ມີຂໍໍ່ມູນ")
        : ListView.builder(
          itemCount: _unit.length,
          itemBuilder: (context, index) {
            return Expanded(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text(
                    _unit[index]['unit_id'].toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  _unit[index]['unit_name'].toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_document, color: Colors.blue),
                      onPressed: () {
                        updateUnit(index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteUnit(index);
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
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: unitController,
        validator: (value) => value!.isEmpty ? "ກະລຸນາປ້ອນຫົວໜ່ວຍ" : null,
        decoration: InputDecoration(
          hintText: "ປ້ອນຊື່ຫົວໜ່ວຍ",
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
    );
  }

  void updateUnit(int index) {
    unitController.text = _unit[index]['unit_name'].toString();
    final GlobalKey<FormState> _dialogformKey = GlobalKey<FormState>();
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("ແກ້ໄຂຫົວໜ່ວຍ", style: TextStyle(fontSize: 16)),
          content: Material(
            child: Form(
              key: _dialogformKey,
              child: TextFormField(
                controller: unitController,
                validator: (value) => value!.isEmpty ? "ປ້ອນຊື່ຫົວໜ່ວຍ" : null,
                decoration: InputDecoration(
                  hintText: "ປ້ອນຊື່ຫົວໜ່ວຍ",
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
                unitController.clear();
              },
              child: Text("ຍົກເລີກ", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  api
                      .updateUnit(
                        context,
                        unitController.text,
                        _unit[index]['unit_id'].toString(),
                      )
                      .then((value) {
                        if (value != null) {
                          setState(() {
                            _unit[index] = value;
                            unitController.clear();
                          });
                          loadUnit();
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

  void deleteUnit(int index) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("ລຶບຫົວໜ່ວຍ", style: TextStyle(fontSize: 16)),
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
                    .deleteUnit(context, _unit[index]['unit_id'].toString())
                    .then((value) {
                      if (value != null) {
                        setState(() {
                          _unit.removeAt(index);
                        });
                        loadUnit();
                        unitController.clear();
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
