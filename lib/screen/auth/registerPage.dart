import 'package:flutter/material.dart';
import 'package:food/service/registerService.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _lastnameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _lastnameFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final success = await RegisterService().register(
        context,
        _usernameController.text.trim(),
        _passwordController.text.trim(),
        _emailController.text.trim(),
      );

      if (success) {
        Navigator.pushReplacementNamed(context, '/login');
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("ກຳລັງລົງທະບຽນ...")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(22.0),
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
                        "assets/images/logo.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "ຍິນດີຕ້ອນຮັບສູ່ໜ້າລົງທະບຽນ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50),

                  TextFormField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted:
                        (_) =>
                            FocusScope.of(context).requestFocus(_lastnameFocus),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: Colors.green),
                      hintText: "ປ້ອນຊື່ຜູ້ໃຊ້",
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'ກະລຸນາປ້ອນຊື່ຜູ້ໃຊ້ຂອງທ່ານ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    focusNode: _lastnameFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted:
                        (_) =>
                            FocusScope.of(context).requestFocus(_passwordFocus),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email, color: Colors.green),
                      hintText: "ປ້ອນອີເມລ",
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'ກະລຸນາປ້ອນອີເມລຂອງທ່ານ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    textInputAction: TextInputAction.next,
                    obscureText: _obscurePassword,
                    onFieldSubmitted:
                        (_) =>
                            FocusScope.of(context).requestFocus(_confirmFocus),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock, color: Colors.green),
                      hintText: 'ປ້ອນລະຫັດຜ່ານ',
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
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

                  TextFormField(
                    controller: _confirmController,
                    focusNode: _confirmFocus,
                    obscureText: _obscureConfirm,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF4CAF50),
                      ),
                      hintText: " ຢືນຢັນລະຫັດຜ່ານ",
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'ລະຫັດຜ່ານທີ່ທ່ານໃຊ້ຢືນຢັນບໍ່ຖືກກັນ';
                      }
                      if (value == null || value.isEmpty) {
                        return 'ກະລຸນາຢືນຢັນຜ່ານຂອງທ່ານ';
                      }
                      if (value.length < 8) {
                        return 'ລະຫັດຜ່ານຕ້ອງມີຢ່າງນ້ອຍ 8 ຕົວຂື້ນ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CAF50),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "ລົງທະບຽນ",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
