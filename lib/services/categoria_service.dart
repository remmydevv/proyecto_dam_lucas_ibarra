import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriaService {
  Future<QuerySnapshot> categorias() {
    return FirebaseFirestore.instance.collection('categorias').get();
  }
}
