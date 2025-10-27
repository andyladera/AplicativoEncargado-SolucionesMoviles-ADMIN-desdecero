class ConcursoModel {
  final String id;
  final String nombre;
  final DateTime fecha;
  final String descripcion;
  final String estado; // e.g., 'abierto', 'cerrado', 'evaluando'

  ConcursoModel({
    required this.id,
    required this.nombre,
    required this.fecha,
    required this.descripcion,
    required this.estado,
  });

  factory ConcursoModel.fromMap(Map<String, dynamic> map) {
    return ConcursoModel(
      id: map['id'],
      nombre: map['nombre'],
      fecha: map['fecha'].toDate(),
      descripcion: map['descripcion'],
      estado: map['estado'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'fecha': fecha,
      'descripcion': descripcion,
      'estado': estado,
    };
  }
}