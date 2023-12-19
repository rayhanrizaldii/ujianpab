import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:html' as html;

String decodeFileName(String encodedFileName) {
  try {
    return utf8.decode(base64.decode(encodedFileName));
  } catch (e) {
    print('Error decoding file name: $e');
    return '';
  }
}

class FetchTableProduct {
  static Future<Map<dynamic, dynamic>> fetchDataProdukById(int id) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:81/ujianpab/produk/read_by_id.php?produk_id=$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data.containsKey('gambar_produk')) {
          data['gambar_produk'] = decodeFileName(data['gambar_produk']);
        }

        return data;
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchDataProduk() async {
    final response = await http
        .get(Uri.parse('http://localhost:81/ujianpab/produk/read.php'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData is Map && jsonData.containsKey('data')) {
        final dataList = List<Map<String, dynamic>>.from(jsonData['data']);

        // Mendekode nama file yang dienkripsi
        for (var data in dataList) {
          if (data.containsKey('gambar_produk')) {
            data['gambar_produk'] = decodeFileName(data['gambar_produk']);
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

  static Future<bool> createDataProduk(
    String nama,
    String harga,
    DateTime tanggalproduksi,
    String deskripsi,
    int tersedia,
    String jenis,
    String buatan,
    html.File imagePath,
  ) async {
    try {
      var url = Uri.parse('http://localhost:81/ujianpab/produk/create.php');
      var request = http.MultipartRequest('POST', url);

      request.fields['nama_produk'] = nama;
      request.fields['harga'] = harga;
      request.fields['tanggal_produksi'] =
          DateFormat('dd-MM-yyyy').format(tanggalproduksi);
      request.fields['deskripsi'] = deskripsi;
      request.fields['available'] = tersedia.toString();
      request.fields['jenis_kopi'] = jenis;
      request.fields['buatan'] = buatan;

      // ignore: unnecessary_null_comparison
      if (imagePath != null) {
        var fileReader = html.FileReader();
        fileReader.readAsArrayBuffer(imagePath);

        await fileReader.onLoad.first;

        var fileBytes = fileReader.result as List<int>;

        request.files.add(http.MultipartFile.fromBytes(
            'gambar_produk', fileBytes,
            filename: imagePath.name));

        var response = await request.send();
        if (response.statusCode == 200) {
          print('Data dan gambar berhasil disimpan.');
          print('${request}');
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

  static Future<void> deleteDataProduk(int id) async {
    String apiUrl =
        'http://127.0.0.1:81/ujianpab/produk/delete.php?produk_id=$id';

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

  static Future<void> updateDataProduk(
    int id,
    String nama,
    String harga,
    DateTime tanggalproduksi,
    String deskripsi,
    int tersedia,
    String jenis,
    String buatan,
    html.File imagePath,
  ) async {
    var url = Uri.parse(
        'http://127.0.0.1:81/ujianpab/produk/update.php'); // Ganti dengan URL API Anda
    var request = http.MultipartRequest('POST', url);

    request.fields['produk_id'] = id.toString();
    request.fields['nama_produk'] = nama;
    request.fields['harga'] = harga;
    request.fields['tanggal_produksi'] =
        DateFormat('dd-MM-yyyy').format(tanggalproduksi);
    request.fields['deskripsi'] = deskripsi;
    request.fields['available'] = tersedia.toString();
    request.fields['jenis_kopi'] = jenis;
    request.fields['buatan'] = buatan;

    // ignore: unnecessary_null_comparison
    if (imagePath != null) {
      try {
        var fileReader = html.FileReader();
        fileReader.readAsArrayBuffer(imagePath);

        await fileReader.onLoad.first;

        var fileBytes = fileReader.result as List<int>;

        request.files.add(http.MultipartFile.fromBytes(
            'gambar_produk', fileBytes,
            filename: imagePath.name));

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
}
