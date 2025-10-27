import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concurso_admin/src/features/jurado/data/proyecto_model.dart';

class ProyectoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _proyectosCollection = FirebaseFirestore.instance.collection('proyectos');

  Stream<List<ProyectoModel>> getProyectos(String concursoId) {
    return _proyectosCollection.where('concursoId', isEqualTo: concursoId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProyectoModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> calificarProyecto(String proyectoId, String juradoId, double calificacion) {
    return _proyectosCollection.doc(proyectoId).update({
      'calificaciones.$juradoId': calificacion,
    });
  }
}