import 'package:firebase_auth/firebase_auth.dart';

enum UserRole { manager, frontDesk, unknown }

UserRole roleFromString(String? v) {
  switch (v) {
    case 'manager':
      return UserRole.manager;
    case 'frontdesk':
      return UserRole.frontDesk;
    default:
      return UserRole.unknown;
  }
}

class RoleService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserRole> getCurrentRole({bool forceRefresh = false}) async {
    final user = _auth.currentUser;
    if (user == null) return UserRole.unknown;

    final token = await user.getIdTokenResult(forceRefresh);
    final role = token.claims?['role'] as String?;
    return roleFromString(role);
  }
}
