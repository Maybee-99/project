import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Image image(String _image) {
  return Image.asset(_image, width: 200, height: 200);
}

TextFormField textField(
  String hint,
  TextEditingController _controller,
  bool _obscureText,
  String _validate,
  Icon prefixIcon,
  IconButton? suffixIcon,
  bool _isHide,
) {
  return TextFormField(
    controller: _controller,
    obscureText: _obscureText,
    validator: (value) {
      return (value == null || value.isEmpty) ? _validate : null;
    },
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      hintText: hint,
      hintStyle: TextStyle(
        color: const Color.fromARGB(255, 74, 72, 72),
        fontSize: 14,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: _isHide ? suffixIcon : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    ),
  );
}

ElevatedButton button(String text, Color color, VoidCallback _onPressed) {
  return ElevatedButton(
    onPressed: _onPressed,
    child: Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    ),
  );
}

Row rowText(String text, TextButton _onPressed) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [Text(text), _onPressed],
  );
}

void showAlert(
  BuildContext context,
  String _title,
  String _content,
  String message,
) {
  showCupertinoDialog(
    context: context,
    builder:
        (BuildContext c) => CupertinoAlertDialog(
          title: Text(_title),
          content: Text(_content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: Text(
                message,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ],
        ),
  );
}
