import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:ujianpab/bottomnavigation.dart';
import 'package:ujianpab/services/fetchtable1.dart';
import 'package:ujianpab/widget/table1/GenderRadio.dart';

class DialogUpdateTable1 extends StatefulWidget {
  final int id;

  DialogUpdateTable1({required this.id});

  @override
  _DialogUpdateTable1State createState() => _DialogUpdateTable1State();
}

class _DialogUpdateTable1State extends State<DialogUpdateTable1> {
  final _formKey = GlobalKey<FormState>();
  late int id;
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
          final url =
              'http://127.0.0.1:81/ujianpab/update_table1.php?id=${widget.id}';
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

  List<String> ageList = List.generate(23, (index) => (18 + index).toString());

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
  void initState() {
    super.initState();
    _fetchDataById(widget.id);
  }

  void _fetchDataById(int id) async {
    try {
      final response = await FetchTable1.fetchDataById(id);
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
      _namaController.text = data['nama'];
      selectedDate = DateTime.parse(data['tanggal_lahir']);
      _alamatController.text = data['alamat'];
      genderValue = data['gender'];
      selectedAge = data['umur'].toString();
      selectedHobbies = data['hobi'].split(', ');

      // Check if 'foto' field is a String or a File
      if (data['foto'] is String) {
        // If it's a String, you might want to handle it accordingly (e.g., display as an image)
        // You need to implement the logic based on your use case.
        // _image = ...;
      } else if (data['foto'] is html.File) {
        // If it's a File, assign it directly
        _image = data['foto'];
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
                            try {
                              if (_formKey.currentState!.validate()) {
                                int id = widget.id;
                                String nama = _namaController.text;
                                DateTime? tanggalLahir = selectedDate;
                                int umur = int.parse(selectedAge!);
                                String gender = genderValue!;
                                String alamat = _alamatController.text;
                                String hobi = selectedHobbies.join(', ');

                                // Call updateData with the correct arguments, including the ID
                                await updateData(
                                  id,
                                  nama,
                                  tanggalLahir!,
                                  umur,
                                  gender,
                                  alamat,
                                  hobi,
                                  _image!,
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          bottomnavigationbar()),
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

  // Implement this method based on how you want to handle the update on the server
}

void _handleError(Object error) {
  print('Error: $error');
  // Handle the error appropriately, e.g., show a snackbar or dialog to the user
}
