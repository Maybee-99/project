import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food/service/constant.dart';
import 'package:food/widget/widget_reuse.dart';
import 'package:http/http.dart' as http;

class UnitService {
  Future<List<dynamic>> getUnit(BuildContext context) async {
    var response = await http.get(Uri.parse(url + "unit"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
      return [];
    }
  }

  Future<Map<String, dynamic>?> createUnit(
    BuildContext context,
    String category,
  ) async {
    var response = await http.post(
      Uri.parse(url + "unit"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"unit_name": category}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      showAlert(context, "ຂໍ້ຄວາມ", "ຂໍ້ມູນຊ້ຳກັນ", "ຕົກລົງ");
      return null;
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateUnit(
    BuildContext context,
    String category,
    String id,
  ) async {
    var response = await http.put(
      Uri.parse(url + "unit/$id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"unit_name": category}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteUnit(
    BuildContext context,
    String id,
  ) async {
    var response = await http.delete(
      Uri.parse(url + "unit/$id"),
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
