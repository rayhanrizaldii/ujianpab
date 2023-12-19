import 'package:flutter/material.dart';
import 'package:ujianpab/services/fetchtable2.dart';
import 'package:ujianpab/widget/table2/dialog-add-produk.dart';
import 'package:ujianpab/widget/table2/dialog-update-produk.dart';

class tb_produk extends StatefulWidget {
  const tb_produk({super.key});

  @override
  State<tb_produk> createState() => _tb_produkState();
}

class _tb_produkState extends State<tb_produk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Produk'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: FetchTableProduct.fetchDataProduk(),
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
                    height: 200,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(
                              'http://127.0.0.1:81/ujianpab/produk/images/' +
                                  item['gambar_produk'],
                            ),
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
                                            // print(item['id']);
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                int? itemId = int.tryParse(
                                                    item['produk_id']);
                                                return DialogUpdateProduk(
                                                    id: itemId!);
                                              },
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            int? itemId =
                                                int.tryParse(item['produk_id']);
                                            FetchTableProduct.deleteDataProduk(
                                                itemId!);
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  item['nama_produk'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Deskripsi: ${item['deskripsi']}',
                                ),
                                Text(
                                  'Harga: ${item['harga']}',
                                ),
                                Text(
                                  'Jenis produk: ${item['jenis_kopi']}',
                                ),
                                Text(
                                  'Tanggal Produksi: ${item['tanggal_produksi']}',
                                ),
                                Text(
                                  'Tersedia: ${item['available']}',
                                ),
                                Text(
                                  'Buatan: ${item['buatan']}',
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
              return DialogAddProduk();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
