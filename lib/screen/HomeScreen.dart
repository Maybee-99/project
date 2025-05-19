import 'package:flutter/material.dart';
import 'package:food/screen/pages/Home.dart';
import 'package:food/screen/pages/UserAccount.dart';
import 'package:food/screen/pages/search.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  final IntialIndex;
  const HomeScreen({super.key, this.IntialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final List<Widget> pages = [Home(), Search(), User()];

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  void onTap(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _index = widget.IntialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'ໜ້າຫຼັກ'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'ຄົ້ນຫາ'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ບັນຊີ'),
        ],
        currentIndex: _index,
        onTap: onTap,
      ),
    );
  }
}
