import 'package:flutter/material.dart';

class GenderRadio extends StatefulWidget {
  final String? groupValue;
  final Function(String?) onChanged;

  const GenderRadio({required this.groupValue, required this.onChanged});

  @override
  _GenderRadioState createState() => _GenderRadioState();
}

class _GenderRadioState extends State<GenderRadio> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile<String>(
          title: const Text('Laki-laki'),
          value: 'Laki-laki',
          groupValue: widget.groupValue,
          onChanged: widget.onChanged,
        ),
        RadioListTile<String>(
          title: const Text('Perempuan'),
          value: 'Perempuan',
          groupValue: widget.groupValue,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
