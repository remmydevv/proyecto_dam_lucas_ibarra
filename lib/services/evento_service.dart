import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventoService {
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection('eventos').snapshots();
  }

  Future<void> agregarEvento(
    String titulo,
    DateTime fechaHora,
    String lugar,
    String categoria,
  ) {
    final user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance.collection('eventos').add({
      'titulo': titulo,
      'fechaHora': Timestamp.fromDate(fechaHora),
      'lugar': lugar,
      'categoria': categoria,
      'autor': user!.displayName ?? user.email,
      'autorId': user.uid,
    });
  }

  Future<void> eliminarEvento(String id) {
    return FirebaseFirestore.instance.collection('eventos').doc(id).delete();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> evento(String id) {
    return FirebaseFirestore.instance.collection('eventos').doc(id).get();
  }

  Stream<QuerySnapshot> eventoByAutor() {
    final user = FirebaseAuth.instance.currentUser!;

    return FirebaseFirestore.instance
        .collection('eventos')
        .where('autorId', isEqualTo: user.uid)
        .snapshots();
  }
}
