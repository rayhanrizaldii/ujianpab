import 'package:flutter/material.dart';
import 'package:ujianpab/widget/table1/dialog-add-table1.dart';
import 'package:ujianpab/services/fetchtable1.dart';
import 'package:ujianpab/widget/table1/dialog-update-table1.dart';

class tablemahasiswa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Mahasiswa'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: FetchTable1.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            // ... (kode sebelumnya)

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    height: 200,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(
                            'http://127.0.0.1:81/ujianpab/images/' +
                                item['foto'],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            // Tambahkan logika untuk membuka dialog edit
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                // Konversi 'id' dari String ke int
                                                int? itemId =
                                                    int.tryParse(item['id']);
                                                return DialogUpdateTable1(
                                                    id: itemId);
                                              },
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            int? itemId =
                                                int.tryParse(item['id']);
                                            deleteData(itemId!);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  item['nama'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Umur: ${item['umur']}',
                                ),
                                Text(
                                  'Alamat: ${item['alamat']}',
                                ),
                                Text(
                                  'Tanggal Lahir: ${item['tanggal_lahir']}',
                                ),
                                Text(
                                  'Gender: ${item['gender']}',
                                ),
                                Text(
                                  'Hobi: ${item['hobi']}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            print('${snapshot.error}');
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogTable1();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
