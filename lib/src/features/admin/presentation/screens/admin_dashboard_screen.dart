import 'package:concurso_admin/src/features/admin/data/concurso_model.dart';
import 'package:concurso_admin/src/features/admin/domain/concurso_service.dart';
import 'package:concurso_admin/src/features/admin/presentation/screens/add_concurso_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
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
            return const Center(child: Text('No hay concursos.'));
          }

          final concursos = snapshot.data!;

          return ListView.builder(
            itemCount: concursos.length,
            itemBuilder: (context, index) {
              final concurso = concursos[index];
              return ListTile(
                title: Text(concurso.nombre),
                subtitle: Text(concurso.descripcion),
                trailing: Text(concurso.estado),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddConcursoScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}