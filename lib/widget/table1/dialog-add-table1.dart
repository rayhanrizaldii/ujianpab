import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ujianpab/services/fetchtable1.dart';
import 'package:ujianpab/widget/table1/GenderRadio.dart';
import 'package:http/http.dart' as http;

class DialogTable1 extends StatefulWidget {
  @override
  _DialogTable1State createState() => _DialogTable1State();
}

class _DialogTable1State extends State<DialogTable1> {
  final _formKey = GlobalKey<FormState>();
  String? genderValue;
  TextEditingController _namaController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  String? selectedAge;
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
          final url = 'http://127.0.0.1:81/ujianpab/create_table1.php';
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

  List<String> ageList = [
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
  ];

  List<String> selectedHobbies = [];

  List<String> hobbiesList = [
    'Olahraga',
    'Membaca',
    'Memasak',
    'Bermain Musik',
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
                        controller: _namaController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Nama',
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
                                    : 'Tanggal Lahir',
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
                        controller: _alamatController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Alamat',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: GenderRadio(
                        groupValue: genderValue,
                        onChanged: (String? value) {
                          setState(() {
                            genderValue = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButton<String>(
                        value: selectedAge,
                        hint: const Text('Pilih Umur'),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedAge = newValue;
                          });
                        },
                        items: ageList.map<DropdownMenuItem<String>>(
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
                        children: hobbiesList.map((String hobby) {
                          return CheckboxListTile(
                            title: Text(hobby),
                            value: selectedHobbies.contains(hobby),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value != null && value) {
                                  selectedHobbies.add(hobby);
                                } else {
                                  selectedHobbies.remove(hobby);
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
                              String nama = _namaController.text;
                              DateTime? tanggalLahir = selectedDate;
                              int umur = int.parse(selectedAge!);
                              String gender = genderValue!;
                              String alamat = _alamatController.text;
                              String hobi = selectedHobbies.join(', ');

                              // Call createData with the correct arguments
                              createData(nama, tanggalLahir!, umur, gender,
                                  alamat, hobi, _image!);

                              Navigator.of(context).pop();
                              setState(() {});
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
