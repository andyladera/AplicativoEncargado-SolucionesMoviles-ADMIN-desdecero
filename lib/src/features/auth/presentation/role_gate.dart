import 'package:concurso_admin/src/features/auth/data/admin_model.dart';
import 'package:concurso_admin/src/features/auth/domain/auth_service.dart';
import 'package:concurso_admin/src/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:concurso_admin/src/features/jurado/presentation/screens/jurado_dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RoleGate extends StatefulWidget {
  final User user;

  const RoleGate({super.key, required this.user});

  @override
  State<RoleGate> createState() => _RoleGateState();
}

class _RoleGateState extends State<RoleGate> {
  late Future<AdminModel?> _adminDataFuture;

  @override
  void initState() {
    super.initState();
    _adminDataFuture = AuthService().getAdminData(widget.user);
  }

  @override
  void didUpdateWidget(covariant RoleGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.user.uid != oldWidget.user.uid) {
      setState(() {
        _adminDataFuture = AuthService().getAdminData(widget.user);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AdminModel?>(
      future: _adminDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error de Autenticación'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                ),
              ],
            ),
            body: const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No se encontraron datos para tu usuario. Esto puede ocurrir si el proceso de registro no se completó correctamente. Por favor, cierra sesión e intenta registrarte de nuevo.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final adminData = snapshot.data!;

        if (adminData.rol == 'admin') {
          return const AdminDashboardScreen();
        } else if (adminData.rol == 'jurado') {
          return const JuradoDashboardScreen();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Rol Desconocido'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                ),
              ],
            ),
            body: const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Tu usuario no tiene un rol asignado. Por favor, contacta al administrador.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}