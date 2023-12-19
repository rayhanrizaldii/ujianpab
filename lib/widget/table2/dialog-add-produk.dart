import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ujianpab/bottomnavigation.dart';
import 'package:ujianpab/services/fetchtable2.dart';
import 'Radio_tb_produk.dart';
import 'package:http/http.dart' as http;

class DialogAddProduk extends StatefulWidget {
  @override
  _DialogAddProdukState createState() => _DialogAddProdukState();
}

class _DialogAddProdukState extends State<DialogAddProduk> {
  final _formKey = GlobalKey<FormState>();
  String? jenisproduk;
  TextEditingController _namaproduk = TextEditingController();
  TextEditingController _harga = TextEditingController();
  TextEditingController _deskripsi = TextEditingController();
  String? _tersedia;
  html.File? _image;

  void _pickImageFromGallery() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files!.length == 1) {
        final html.File file = files[0];
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((e) async {
          setState(() {
            _image = file;
          });

          // Upload image to server
          final url = 'http://127.0.0.1:81/ujianpab/create_tb_produk.php';
          final response = await http.post(Uri.parse(url), body: {
            'image': reader.result.toString(),
          });

          // Handle response from server
          if (response.statusCode == 200) {
            // Image uploaded successfully
          } else {
            // Failed to upload image
          }
        });
      }
    });
  }

  List<String> tersediaList =
      List.generate(100, (index) => (18 + index).toString());

  List<String> selectedBuatan = [];

  List<String> buatanList = [
    'Indonesia',
    'Luar Negeri',
  ];

  DateTime? selectedDate;
  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                ListView(
                  children: [
                    Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: _image != null
                                    ? Image.network(
                                        html.Url.createObjectUrlFromBlob(
                                            _image!),
                                        width: 100,
                                        height: 100,
                                      )
                                    : Container(),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _pickImageFromGallery();
                            },
                            child: const Text('Pilih Gambar'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: _namaproduk,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Nama Produk Kopi',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: _harga,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Harga',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: selectedDate != null
                                    ? DateFormat('dd-MM-yyyy')
                                        .format(selectedDate!)
                                    : 'Tanggal Produksi',
                              ),
                              enabled: false,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _selectDate(context),
                            child: Text('Pilih Tanggal'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: _deskripsi,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Deskripsi Produk',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Radio_Produk(
                        groupValue: jenisproduk,
                        onChanged: (String? value) {
                          setState(() {
                            jenisproduk = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButton<String>(
                        value: _tersedia,
                        hint: const Text('Apakah Tersedia'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _tersedia = newValue;
                          });
                        },
                        items: tersediaList.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: buatanList.map((String buatan) {
                          return CheckboxListTile(
                            title: Text(buatan),
                            value: selectedBuatan.contains(buatan),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value != null && value) {
                                  selectedBuatan.add(buatan);
                                } else {
                                  selectedBuatan.remove(buatan);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.all(16),
                        child: TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String nama = _namaproduk.text;
                              String harga = _harga.text;
                              DateTime? tanggalProduksi = selectedDate;
                              String deskripsi = _deskripsi.text;
                              int tersedia = int.parse(_tersedia!);
                              String jenis = jenisproduk!;
                              String buatan = selectedBuatan.join(', ');

                              // Call createData with the correct arguments
                              bool success =
                                  await FetchTableProduct.createDataProduk(
                                      nama,
                                      harga,
                                      tanggalProduksi!,
                                      deskripsi,
                                      tersedia,
                                      jenis,
                                      buatan,
                                      _image!);

                              if (success) {
                                // Jika berhasil, tampilkan AlertDialog

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Sukses'),
                                      content:
                                          Text('Data berhasil ditambahkan.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      bottomnavigationbar(
                                                        initialIndex: 1,
                                                      )),
                                            );
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                // Jika gagal, tampilkan AlertDialog dengan pesan error
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Gagal'),
                                      content: Text(
                                          'Terjadi kesalahan saat menambahkan data.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            // Tutup AlertDialog
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: Text('Simpan'),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
