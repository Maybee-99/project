import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:food/service/constant.dart';
import 'package:food/widget/widget_reuse.dart';
import 'package:http/http.dart' as http;

class ProductService {
  Future<List<dynamic>> getProducts(BuildContext context) async {
    var response = await http.get(Uri.parse(url + "products"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
      return [];
    }
  }

  Future<List<dynamic>> getProductsWithCate(
    BuildContext context,
    String category,
  ) async {
    var response = await http.get(Uri.parse(url + "products/$category"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ", "ຕົກລົງ");
      return [];
    }
  }

  Future<Map<String, dynamic>?> createProduct(
    BuildContext context,
    String name,
    String price,
    String sale_price,
    String quantity,
    String category,
    String unit,
    String? image,
  ) async {
    var response = await http.post(
      Uri.parse(url + "products"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "product_name": name,
        "price": price,
        "sale_price": sale_price,
        "stock": quantity,
        "category_id": category,
        "unit_id": unit,
        "image_url": image,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      showAlert(context, "ຂໍ້ຄວາມ", "ຂໍ້ມູນຊ້ຳກັນ", "ຕົກລົງ");
      return null;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateProduct(
    BuildContext context,
    String name,
    String price,
    String sale_price,
    String quantity,
    String category,
    String unit,
    String id,
  ) async {
    var response = await http.put(
      Uri.parse(url + "products/$id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "product_name": name,
        "price": price,
        "sale_price": sale_price,
        "stock": quantity,
        "category_id": category,
        "unit_id": unit,
        "product_id": id,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      showAlert(context, "ຂໍ້ຄວາມ", "ເກີດຂໍ້ຜິດພາດ", "ຕົກລົງ");
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteProduct(
    BuildContext context,
    String id,
  ) async {
    final response = await http.delete(
      Uri.parse(url + "products/$id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    print('Delete status: ${response.statusCode}');
    print('Delete response: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      try {
        final json = jsonDecode(response.body);
        String errorMessage = json['message'] ?? "ລຶບຜິດພາດ";
        showAlert(context, "ຂໍ້ຄວາມ", errorMessage, "ຕົກລົງ");
      } catch (e) {
        showAlert(context, "ຂໍ້ຄວາມ", e.toString(), "ຕົກລົງ");
      }

      return null;
    }
  }

  Future<String> upLoadImageToCloud(
    Uint8List imageBytes,
    BuildContext context,
  ) async {
    final uri = Uri.parse(server_url);
    final preset = "flutter-upload";
    try {
      final request =
          http.MultipartRequest('POST', uri)
            ..fields['upload_preset'] = preset
            ..files.add(
              await http.MultipartFile.fromBytes(
                'file',
                imageBytes,
                filename: 'upload.jpg',
              ),
            );

      final response = await request.send();
      if (response.statusCode == 200) {
        final resData = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(resData);
        return jsonResponse["secure_url"];
      } else {
        final resData = await response.stream.bytesToString();
        showAlert(context, "ຂໍ້ຄວາມ", "${resData}", "ຕົກລົງ");
      }
    } catch (e) {
      showAlert(context, "ຂໍ້ຄວາມ", "${e}", "ຕົກລົງ");
    }
    return "";
  }

  Future<List<dynamic>> search(BuildContext context, String parameter) async {
    try {
      final encodedName = Uri.encodeComponent(parameter);
      final response = await http.get(Uri.parse(url + "search/$encodedName"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      showAlert(context, "ຂໍ້ຄວາມ", "ເກີດຂໍ້ຜິດພາດ", "ຕົກລົງ");
      return [];
    }
  }
}
