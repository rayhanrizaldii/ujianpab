import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:html' as html;

String decodeFileName(String encodedFileName) {
  String decodedFileName = utf8.decode(base64.decode(encodedFileName));
  return decodedFileName;
}

class FetchTable1 {
  static Future<Map<String, dynamic>> fetchDataById(int id) async {
    final response = await http.get(
        Uri.parse('http://127.0.0.1:81/ujianpab/read_table1_by_id.php?id=$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData is Map && jsonData.containsKey('data')) {
        final data = Map<String, dynamic>.from(jsonData['data']);

        // Mendekode nama file yang dienkripsi
        if (data.containsKey('foto')) {
          data['foto'] = decodeFileName(data['foto']);
        }

        return data;
      } else {
        throw Exception('Invalid JSON format');
      }
    } else {
      throw Exception('Gagal mengambil data: ${response.statusCode}');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http
        .get(Uri.parse('http://localhost:81/ujianpab/read_table1.php'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData is Map && jsonData.containsKey('data')) {
        final dataList = List<Map<String, dynamic>>.from(jsonData['data']);

        // Mendekode nama file yang dienkripsi
        for (var data in dataList) {
          if (data.containsKey('foto')) {
            data['foto'] = decodeFileName(data['foto']);
          }
        }

        return dataList;
      } else {
        throw Exception('Invalid JSON format');
      }
    } else {
      throw Exception('Gagal mengambil data: ${response.statusCode}');
    }
  }
}

Future<void> createData(
  String nama,
  DateTime tanggalLahir,
  int umur,
  String gender,
  String alamat,
  String hobi,
  html.File imagePath,
) async {
  var url = Uri.parse(
      'http://localhost:81/ujianpab/create_table1.php'); // Replace with the correct URL

  var request = http.MultipartRequest('POST', url);

  request.fields['nama'] = nama;
  request.fields['tanggal_lahir'] =
      DateFormat('dd-MM-yyyy').format(tanggalLahir);
  request.fields['umur'] = umur.toString();
  request.fields['gender'] = gender;
  request.fields['alamat'] = alamat;
  request.fields['hobi'] = hobi;

  // ignore: unnecessary_null_comparison
  if (imagePath != null) {
    var fileReader = html.FileReader();
    fileReader.readAsArrayBuffer(imagePath);

    await fileReader
        .onLoad.first; // Wait for the FileReader to finish loading the file

    var fileBytes = fileReader.result as List<int>;

    request.files.add(http.MultipartFile.fromBytes('foto', fileBytes,
        filename: imagePath.name));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Data dan gambar berhasil disimpan.');
      } else {
        print(
            'Gagal menyimpan data dan gambar. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengirim permintaan: $e');
    }
  }
}

Future<void> deleteData(int id) async {
  // Gantilah URL_API dengan URL endpoint API Anda
  String apiUrl = 'http://127.0.0.1:81/ujianpab/delete_table1.php?id=$id';

  try {
    final response = await http.delete(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Data berhasil dihapus
      print('Data dengan ID $id berhasil dihapus.');
    } else {
      // Gagal menghapus data, tampilkan pesan kesalahan
      print('Gagal menghapus data. Status: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (error) {
    // Tangani kesalahan jika ada
    print('Error: $error');
  }
}

Future<void> updateData(
  int id,
  String nama,
  DateTime tanggalLahir,
  int umur,
  String gender,
  String alamat,
  String hobi,
  html.File imagePath,
) async {
  var url = Uri.parse('http://localhost:81/ujianpab/update_table1.php');

  var request = http.MultipartRequest('POST', url);

  request.fields['id'] = id.toString();
  request.fields['nama'] = nama;
  request.fields['tanggal_lahir'] =
      DateFormat('dd-MM-yyyy').format(tanggalLahir);
  request.fields['umur'] = umur.toString();
  request.fields['gender'] = gender;
  request.fields['alamat'] = alamat;
  request.fields['hobi'] = hobi;

  // ignore: unnecessary_null_comparison
  if (imagePath != null) {
    var fileReader = html.FileReader();
    fileReader.readAsArrayBuffer(imagePath);

    await fileReader.onLoad.first;

    var fileBytes = fileReader.result as List<int>;

    request.files.add(http.MultipartFile.fromBytes('foto', fileBytes,
        filename: imagePath.name));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Data dan gambar berhasil diperbarui.');
      } else {
        print(
            'Gagal memperbarui data dan gambar. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengirim permintaan: $e');
    }
  }
}
