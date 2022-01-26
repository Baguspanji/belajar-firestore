import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/src/firebase/firestore.dart';
import 'package:flutter_firebase/src/pages/detail.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firestore = Firestore();

  final namaController = TextEditingController();

  final alamatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference mahasiswa = firestore.mahasiswa;

    return Scaffold(
      appBar: AppBar(
        title: Text('Belajar Firebase'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: mahasiswa.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }

          return ListView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: snapshot.data!.docs.map((e) {
                var mhs = e.data() as Map<String, dynamic>;

                return Card(
                  elevation: 8,
                  child: Stack(
                    children: [
                      ListTile(
                        onTap: () {
                          // contoh pindah halaman
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (_) => DetailPage()));

                          setState(() {
                            namaController.text = mhs['nama'];
                            alamatController.text = mhs['alamat'];
                          });

                          showAlertDialog(context, isEdit: true, id: e.id);
                        },
                        title: Text(mhs['nama']),
                        subtitle: Text(mhs['alamat']),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: IconButton(
                          onPressed: () {
                            firestore.deleteMahasiswa(e.id);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }).toList());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            namaController.text = '';
            alamatController.text = '';
          });
          showAlertDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  showAlertDialog(BuildContext context, {bool isEdit = false, String id = ''}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: isEdit ? Text('Update Mahasiswa') : Text("Tambah Mahasiswa"),
          content: Container(
            height: 120,
            child: Column(
              children: [
                TextField(
                  controller: namaController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    labelStyle: TextStyle(fontSize: 12),
                    hintText: 'Masukkan Nama Mahasiswa',
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                ),
                TextField(
                  controller: alamatController,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                    labelStyle: TextStyle(fontSize: 12),
                    hintText: 'Masukkan ALamat Mahasiswa',
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            isEdit
                ? TextButton(
                    child: Text("Update"),
                    onPressed: () async {
                      dynamic data = {
                        'nama': namaController.text,
                        'alamat': alamatController.text,
                      };

                      Navigator.pop(context);

                      firestore.editMahasiswa(data, id);
                    },
                  )
                : TextButton(
                    child: Text("Simpan"),
                    onPressed: () async {
                      dynamic data = {
                        'nama': namaController.text,
                        'alamat': alamatController.text,
                      };

                      Navigator.pop(context);

                      var id = await firestore.addMahasiswa(data);

                      // var snackBar = SnackBar(content: Text('Behasil Simpan'));
                      // if (id == '') {
                      //   var snackBar = SnackBar(content: Text('Gagal Simpan'));
                      // }
                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  ),
          ],
        );
      },
    );
  }
}
