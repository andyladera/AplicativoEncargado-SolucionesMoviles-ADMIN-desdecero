import 'package:concurso_admin/src/features/admin/data/concurso_model.dart';
import 'package:concurso_admin/src/features/jurado/data/proyecto_model.dart';
import 'package:concurso_admin/src/features/jurado/domain/proyecto_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProyectosScreen extends StatelessWidget {
  final ConcursoModel concurso;

  const ProyectosScreen({super.key, required this.concurso});

  @override
  Widget build(BuildContext context) {
    final juradoId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(concurso.nombre),
      ),
      body: StreamBuilder<List<ProyectoModel>>(
        stream: ProyectoService().getProyectos(concurso.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay proyectos en este concurso.'));
          }

          final proyectos = snapshot.data!;

          return ListView.builder(
            itemCount: proyectos.length,
            itemBuilder: (context, index) {
              final proyecto = proyectos[index];
              return ListTile(
                title: Text(proyecto.nombre),
                subtitle: Text(proyecto.descripcion),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showCalificacionDialog(context, proyecto, juradoId);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCalificacionDialog(BuildContext context, ProyectoModel proyecto, String juradoId) {
    final calificacionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Calificar ${proyecto.nombre}'),
          content: TextField(
            controller: calificacionController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Calificación (0-10)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final calificacion = double.tryParse(calificacionController.text);
                if (calificacion != null && calificacion >= 0 && calificacion <= 10) {
                  ProyectoService().calificarProyecto(proyecto.id, juradoId, calificacion);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}