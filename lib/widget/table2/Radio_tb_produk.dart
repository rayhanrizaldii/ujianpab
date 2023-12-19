import 'package:flutter/material.dart';

class Radio_Produk extends StatefulWidget {
  final String? groupValue;
  final Function(String?) onChanged;

  const Radio_Produk({required this.groupValue, required this.onChanged});

  @override
  _Radio_ProdukState createState() => _Radio_ProdukState();
}

class _Radio_ProdukState extends State<Radio_Produk> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile<String>(
          title: const Text('Robusta'),
          value: 'Robusta',
          groupValue: widget.groupValue,
          onChanged: widget.onChanged,
        ),
        RadioListTile<String>(
          title: const Text('Arabika'),
          value: 'Arabika',
          groupValue: widget.groupValue,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
