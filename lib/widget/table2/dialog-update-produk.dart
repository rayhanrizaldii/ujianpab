import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:ujianpab/bottomnavigation.dart';
import 'package:ujianpab/services/fetchtable2.dart';
import 'package:ujianpab/widget/table2/Radio_tb_produk.dart';

class DialogUpdateProduk extends StatefulWidget {
  final int id;

  DialogUpdateProduk({required this.id});

  @override
  _DialogUpdateProdukState createState() => _DialogUpdateProdukState();
}

class _DialogUpdateProdukState extends State<DialogUpdateProduk> {
  final _formKey = GlobalKey<FormState>();
  String? jenisproduk;
  late int id;
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
          final url =
              'http://127.0.0.1:81/ujianpab/produk/update.php?produk_id=$id';
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
  void initState() {
    super.initState();
    _fetchDataProdukById(widget.id);
  }

  void _fetchDataProdukById(int id) async {
    try {
      final response = await FetchTableProduct.fetchDataProdukById(id);
      // ignore: unnecessary_null_comparison
      if (response == null) {
        print('Empty response from the server');
        return;
      }

      final jsonData = response as Map<String, dynamic>;
      if (!jsonData.containsKey('data')) {
        print('Invalid JSON format: $response');
        return;
      }

      _populateFormFields(jsonData['data'][0] as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _populateFormFields(Map<String, dynamic> data) {
    setState(() {
      _namaproduk.text = data['nama_produk'];
      selectedDate = DateTime.parse(data['tanggal_produksi']);
      _harga.text = data['harga'];
      _deskripsi.text = data['deskripsi'];
      jenisproduk = data['jenis_kopi'];
      _tersedia = data['available'].toString();
      selectedBuatan = data['buatan'].split(', ');

      // Check if 'foto' field is a String or a File
      if (data['gambar_produk'] is String) {
        // If it's a String, you might want to handle it accordingly (e.g., display as an image)
        // You need to implement the logic based on your use case.
        _image = "http://127.0.0.1:81/ujianpab/produk/images/" +
            data['gambar_produk'] as html.File;
      } else if (data['gambar_produk'] is html.File) {
        // If it's a File, assign it directly
        _image = data['gambar_produk'];
      }

      // Load image if available
      // Note: You need to implement the logic for loading the image here
    });
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
                        hint: const Text('Berapa Tersedia?'),
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
                            try {
                              if (_formKey.currentState!.validate()) {
                                int id = widget.id;
                                String nama = _namaproduk.text;
                                String harga = _harga.text;
                                DateTime? tanggalProduksi = selectedDate;
                                String deskripsi = _deskripsi.text;
                                int tersedia = int.parse(_tersedia!);
                                String jenis = jenisproduk!;
                                String buatan = selectedBuatan.join(', ');

                                // Call updateData with the correct arguments, including the ID
                                await FetchTableProduct.updateDataProduk(
                                  id,
                                  nama,
                                  harga,
                                  tanggalProduksi!,
                                  deskripsi,
                                  tersedia,
                                  jenis,
                                  buatan,
                                  _image!,
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => bottomnavigationbar(
                                            initialIndex: 1,
                                          )),
                                );
                              }
                            } catch (e) {
                              _handleError(e);
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

void _handleError(Object error) {
  print('Error: $error');
  // Handle the error appropriately, e.g., show a snackbar or dialog to the user
}
