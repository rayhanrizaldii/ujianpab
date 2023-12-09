import 'package:http/http.dart' as http;
import 'dart:convert';

class fetchtable1 {
  List<Map<String, dynamic>> dataList = [];

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('http://127.0.0.1:81/ujianpab/read_table1.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          dataList = List<Map<String, dynamic>>.from(data['data']);
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
