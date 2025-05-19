import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../service/constant.dart';
import '../widget/widget_reuse.dart';

class RegisterService {
  Future<bool> register(
    BuildContext context,
    String username,
    String password,
    String email,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(url + 'register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
        }),
      );

      final resData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        final message = resData['message'] ?? 'ລອງໃໝ່ອີກຄັ້ງ';
        showAlert(context, "ແຈ້ງເຕືອນ", message, "ຕົກລົງ");
      } else if (response.statusCode == 422) {
        final message = resData['message'] ?? 'ລອນໃໝ່';
        showAlert(context, "ແຈ້ງເຕືອນ", message, "ຕົກລົງ");
      } else {
        showAlert(context, "ຜິດພາດ", resData['message'], "ຕົກລົງ");
      }
    } catch (e) {
      showAlert(context, "ເກີດຂໍ້ຜິດພາດ", "$e", "ຕົກລົງ");
      return false;
    }
    return false;
  }
}
