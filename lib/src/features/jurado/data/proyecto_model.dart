class ProyectoModel {
  final String id;
  final String nombre;
  final String descripcion;
  final String concursoId;
  final String uidParticipante;
  final Map<String, double> calificaciones; // juradoId -> calificacion

  ProyectoModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.concursoId,
    required this.uidParticipante,
    required this.calificaciones,
  });

  factory ProyectoModel.fromMap(Map<String, dynamic> map) {
    return ProyectoModel(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      concursoId: map['concursoId'],
      uidParticipante: map['uidParticipante'],
      calificaciones: Map<String, double>.from(map['calificaciones']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'concursoId': concursoId,
      'uidParticipante': uidParticipante,
      'calificaciones': calificaciones,
    };
  }
}