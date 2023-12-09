import 'package:http/http.dart' as http;
import 'dart:convert';

String decodeFileName(String encodedFileName) {
  String decodedFileName = utf8.decode(base64.decode(encodedFileName));
  return decodedFileName;
}

class fetchtable1 {
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
