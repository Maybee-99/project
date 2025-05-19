import 'package:flutter/material.dart';
import 'package:food/service/loginService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginForm() async {
    if (_formKey.currentState!.validate()) {
      final success = await LoginService().login(
        context,
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isloggedIn', true);

        // Optional: confirm save
        print("Login successful, saved isloggedIn = true");

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("ກຳລັງເຂົ້າສູ່ລະບົບ...")));

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error if login failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ຊື່ຜູ້ໃຊ້ ຫຼື ລະຫັດຜ່ານຜິດ")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "ຍິນດີຕ້ອນຮັບເຂົ້າສູ່ລະບົບ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 50),

                  TextFormField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    focusNode: _usernameFocus,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email, color: Colors.green),
                      hintText: "example@gmail.com",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 1,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onFieldSubmitted: (_) {
                      _usernameFocus.unfocus();
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'ກະລຸນາປ້ອນຊື່ຜູ້ໃຊ້';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    obscureText: _obscurePassword,
                    focusNode: _passwordFocus,
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock, color: Colors.green),
                      hintText: "ປ້ອນລະຫັດຜ່ານ",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.green, width: 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'ກະລຸນາປ້ອນລະຫັດຜ່ານຂອງທ່ານ';
                      }
                      if (value.length < 8) {
                        return 'ລະຫັດຜ່ານຕ້ອງມີຢ່າງນ້ອຍ 8 ຕົວຂື້ນ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: _loginForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "ເຂົ້າສູ່ລະບົບ",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text("ຍັງບໍ່ມີບັນຊີ? ລົງທະບຽນ"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
