import 'package:flutter/material.dart';

class listTable extends StatefulWidget {
  const listTable({super.key});

  @override
  State<listTable> createState() => _listTableState();
}

class _listTableState extends State<listTable> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Ini Halaman List Tabel'),
        ),
      ),
    );
  }
}
