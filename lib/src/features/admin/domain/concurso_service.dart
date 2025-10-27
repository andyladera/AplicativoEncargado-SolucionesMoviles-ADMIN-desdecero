import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concurso_admin/src/features/admin/data/concurso_model.dart';

class ConcursoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _concursosCollection = FirebaseFirestore.instance.collection('concursos');

  Stream<List<ConcursoModel>> getConcursos() {
    return _concursosCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ConcursoModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> addConcurso(ConcursoModel concurso) {
    return _concursosCollection.doc(concurso.id).set(concurso.toMap());
  }

  Future<void> updateConcurso(ConcursoModel concurso) {
    return _concursosCollection.doc(concurso.id).update(concurso.toMap());
  }

  Future<void> deleteConcurso(String concursoId) {
    return _concursosCollection.doc(concursoId).delete();
  }
}