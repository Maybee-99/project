import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food/service/constant.dart';
import 'package:food/widget/widget_reuse.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  Future<List<dynamic>> getCategories(BuildContext context) async {
    try {
      var response = await http.get(Uri.parse(url + "categories"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
        return [];
      }
    } catch (e) {
      showAlert(context, "ຂໍ້ຄວາມ", "ເກີດຂໍ້ຜິດພາດ${e}", "ຕົກລົງ");
      return [];
    }
  }

  Future<Map<String, dynamic>?> createCategory(
    BuildContext context,
    String category,
  ) async {
    var response = await http.post(
      Uri.parse(url + "categories"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"category_name": category}),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      showAlert(context, "ຂໍ້ຄວາມ", "ຂໍ້ມູນຊ້ຳກັນ", "ຕົກລົງ");
      return null;
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateCategory(
    BuildContext context,
    String category,
    String id,
  ) async {
    var response = await http.put(
      Uri.parse(url + "categories/$id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"category_name": category}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteCategory(
    BuildContext context,
    String id,
  ) async {
    var response = await http.delete(
      Uri.parse(url + "categories/$id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
      return null;
    }
  }
}
