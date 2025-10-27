import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concurso_admin/src/features/auth/data/admin_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AdminModel?> getAdminData(User user) async {
    final doc = await _firestore.collection('admins').doc(user.uid).get();

    if (doc.exists) {
      return AdminModel.fromMap(doc.data()!);
    }

    return null;
  }
}