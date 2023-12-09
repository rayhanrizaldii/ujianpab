import 'package:flutter/material.dart';
import 'package:ujianpab/table1.dart';
import 'package:ujianpab/tablemahasiswa.dart';

class bottomnavigationbar extends StatefulWidget {
  final int initialIndex;

  const bottomnavigationbar({Key? key, this.initialIndex = 0})
      : super(key: key);

  @override
  State<bottomnavigationbar> createState() => _bottomnavigationbarState();
}

class _bottomnavigationbarState extends State<bottomnavigationbar> {
  int _selectedIndex = 0;

  List<Widget> _screenList = [tablemahasiswa(), table1()];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _screenList[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: onItemTapped,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.black,
          selectedFontSize: 15,
          unselectedFontSize: 15,
          iconSize: 30,
          items: [
            BottomNavigationBarItem(
              tooltip: 'Tabel Mahasiswa',
              label: 'Tabel Mahasiswa',
              icon: Icon(
                Icons.local_movies_outlined,
                color: Colors.black,
              ),
            ),
            BottomNavigationBarItem(
              tooltip: 'Tabel Pembelian',
              label: 'Tabel Pembelian',
              icon: Icon(
                Icons.local_movies_outlined,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
