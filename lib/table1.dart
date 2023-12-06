import 'package:flutter/material.dart';

class table1 extends StatefulWidget {
  const table1({super.key});

  @override
  State<table1> createState() => _table1State();
}

class _table1State extends State<table1> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Ini Halaman tabel 1'),
        ),
      ),
    );
  }
}
