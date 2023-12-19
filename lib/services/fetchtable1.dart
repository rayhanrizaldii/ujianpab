import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:html' as html;

String decodeFileName(String encodedFileName) {
  try {
    return utf8.decode(base64.decode(encodedFileName));
  } catch (e) {
    print('Error decoding file name: $e');
    return ''; // Handle the error or return a default value
  }
}

class FetchTable1 {
  static Future<Map<dynamic, dynamic>> fetchDataById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:81/ujianpab/read_table1_by_id.php?id=$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data.containsKey('foto')) {
          data['foto'] = decodeFileName(data['foto']);
        }

        return data;
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
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

  static Future<bool> createData(
    String nama,
    DateTime tanggalLahir,
    int umur,
    String gender,
    String alamat,
    String hobi,
    html.File imagePath,
  ) async {
    try {
      var url = Uri.parse('http://localhost:81/ujianpab/create_table1.php');
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

        await fileReader.onLoad.first;

        var fileBytes = fileReader.result as List<int>;

        request.files.add(http.MultipartFile.fromBytes('foto', fileBytes,
            filename: imagePath.name));

        var response = await request.send();
        if (response.statusCode == 200) {
          print('Data dan gambar berhasil disimpan.');
          return true; // Indicate success
        } else {
          print(
              'Gagal menyimpan data dan gambar. Status code: ${response.statusCode}');
          return false; // Indicate failure
        }
      } else {
        print('imagePath is null. Gagal menyimpan data dan gambar.');
        return false; // Indicate failure
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengirim permintaan: $e');
      return false; // Indicate failure
    }
  }

  static Future<void> updateData(
    int id,
    String nama,
    DateTime tanggalLahir,
    int umur,
    String gender,
    String alamat,
    String hobi,
    html.File imagePath,
  ) async {
    var url = Uri.parse(
        'http://127.0.0.1:81/ujianpab/update_table1.php'); // Ganti dengan URL API Anda
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
      try {
        var fileReader = html.FileReader();
        fileReader.readAsArrayBuffer(imagePath);

        await fileReader.onLoad.first;

        var fileBytes = fileReader.result as List<int>;

        request.files.add(http.MultipartFile.fromBytes(
          'foto',
          fileBytes,
          filename: imagePath.name,
        ));

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

  static Future<void> deleteData(int id) async {
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
}
