import 'package:flutter/material.dart';
import 'package:ujianpab/widget/table1/dialog-table1.dart';
import 'package:ujianpab/services/fetchtable1.dart';

class tablemahasiswa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Mahasiswa'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchtable1.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    height: 150,
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
                                  'Tanggal Lahir: ${item['tanggal_lahir']}',
                                ),
                                Text(
                                  'Gender: ${item['gender']}',
                                ),
                                Text(
                                  'Gender: ${item['hobi']}',
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
