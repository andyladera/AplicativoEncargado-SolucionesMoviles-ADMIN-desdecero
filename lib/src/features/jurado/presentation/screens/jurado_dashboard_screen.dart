import 'package:concurso_admin/src/features/admin/data/concurso_model.dart';
import 'package:concurso_admin/src/features/admin/domain/concurso_service.dart';
import 'package:concurso_admin/src/features/jurado/presentation/screens/proyectos_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JuradoDashboardScreen extends StatelessWidget {
  const JuradoDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jurado Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ConcursoModel>>(
        stream: ConcursoService().getConcursos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay concursos disponibles.'));
          }

          final concursos = snapshot.data!;

          return ListView.builder(
            itemCount: concursos.length,
            itemBuilder: (context, index) {
              final concurso = concursos[index];
              return ListTile(
                title: Text(concurso.nombre),
                subtitle: Text(concurso.descripcion),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProyectosScreen(concurso: concurso),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}