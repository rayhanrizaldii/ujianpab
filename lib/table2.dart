import 'package:flutter/material.dart';

class table2 extends StatefulWidget {
  const table2({super.key});

  @override
  State<table2> createState() => _table2State();
}

class _table2State extends State<table2> {
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
