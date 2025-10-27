import 'package:concurso_admin/src/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:concurso_admin/src/features/auth/data/admin_model.dart';
import 'package:concurso_admin/src/features/auth/domain/auth_service.dart';
import 'package:concurso_admin/src/features/auth/presentation/screens/login_screen.dart';
import 'package:concurso_admin/src/features/jurado/presentation/screens/jurado_dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        return FutureBuilder<AdminModel?>(
          future: AuthService().getAdminData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              // Handle error or user not found in 'admins' collection
              return const Scaffold(
                body: Center(
                  child: Text('Admin data not found.'),
                ),
              );
            }

            final admin = snapshot.data!;

            if (admin.rol == 'admin') {
              return const AdminDashboardScreen();
            } else if (admin.rol == 'jurado') {
              return const JuradoDashboardScreen();
            }

            return const Scaffold(
              body: Center(
                child: Text('Unknown role.'),
              ),
            );
          },
        );
      },
    );
  }
}