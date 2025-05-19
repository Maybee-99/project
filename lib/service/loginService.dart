import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food/models/User_Model.dart';
import 'package:food/service/constant.dart';
import 'package:food/widget/widget_reuse.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  Future<bool> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(url + "login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        UserModel user = UserModel.fromJson(data['user']);

        final pref = await SharedPreferences.getInstance();
        await pref.setInt('user_id', user.userId ?? 0);
        await pref.setString('username', user.username ?? '');
        await pref.setString('email', user.email ?? '');
        await pref.setString('role', user.role ?? '');

        return true;
      } else if (response.statusCode == 401 && email.isNotEmpty) {
        final message = jsonDecode(response.body)['message'] ?? 'ລອງໃໝ່ອີກຄັ້ງ';
        showAlert(context, "ແຈ້ງເຕືອນ", message, "ຕົກລົງ");
        return false;
      }
    } catch (e) {
      showAlert(context, "ຂໍ້ຄວາມ", "ເກີດຂໍ້ຜິດພາດ{$e}", "ຕົກລົງ");
      return false;
    }
    return false;
  }
}
