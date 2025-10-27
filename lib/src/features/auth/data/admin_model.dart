class AdminModel {
  final String uid;
  final String email;
  final String rol;

  AdminModel({
    required this.uid,
    required this.email,
    required this.rol,
  });

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      uid: map['uid'],
      email: map['email'],
      rol: map['rol'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'rol': rol,
    };
  }
}