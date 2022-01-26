import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  CollectionReference mahasiswa =
      FirebaseFirestore.instance.collection('mahasiswa');

  Future<String> addMahasiswa(dynamic data) async {
    var respon = await mahasiswa.add(data);

    return respon.id;
  }

  void editMahasiswa(dynamic data, String id) async {
    var respon = await mahasiswa.doc(id).update(data);
  }

  void deleteMahasiswa(String id) async {
    var respon = await mahasiswa.doc(id).delete();
  }
}
