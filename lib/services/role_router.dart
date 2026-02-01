import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RoleRouter {
  RoleRouter._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// ✅ Use after login (Email/Password or Google)
  static Future<void> routeAfterLogin(
    BuildContext context, {
    required String managerRoute,
    required String frontDeskRoute,
    required String loginRoute,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    _showBlockingLoader(context);

    try {
      final role = await _fetchRole(user.uid);

      if (!context.mounted) return;
      Navigator.of(context).pop(); // close loader

      if (role == 'manager') {
        Navigator.pushNamedAndRemoveUntil(context, managerRoute, (_) => false);
        return;
      }

      if (role == 'frontdesk') {
        Navigator.pushNamedAndRemoveUntil(context, frontDeskRoute, (_) => false);
        return;
      }

      await _block(context, loginRoute);
    } catch (_) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      await _block(context, loginRoute);
    }
  }

  /// ✅ Use on app start (auto-redirect if already signed in)
  static Future<void> routeOnAppStart(
    BuildContext context, {
    required String managerRoute,
    required String frontDeskRoute,
    required String loginRoute,
  }) async {
    final user = _auth.currentUser;

    // Not signed in -> go to login
    if (user == null) {
      Navigator.pushNamedAndRemoveUntil(context, loginRoute, (_) => false);
      return;
    }

    _showBlockingLoader(context);

    try {
      final role = await _fetchRole(user.uid);

      if (!context.mounted) return;
      Navigator.of(context).pop(); // close loader

      if (role == 'manager') {
        Navigator.pushNamedAndRemoveUntil(context, managerRoute, (_) => false);
        return;
      }

      if (role == 'frontdesk') {
        Navigator.pushNamedAndRemoveUntil(context, frontDeskRoute, (_) => false);
        return;
      }

      await _block(context, loginRoute);
    } catch (_) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      await _block(context, loginRoute);
    }
  }

  static Future<String?> _fetchRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    final data = doc.data();
    return (data?['role'] as String?)?.toLowerCase().trim();
  }

  static Future<void> _block(BuildContext context, String loginRoute) async {
    await _auth.signOut();

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Access Restricted')),
    );

    Navigator.pushNamedAndRemoveUntil(context, loginRoute, (_) => false);
  }

  static void _showBlockingLoader(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: SizedBox(
          width: 46,
          height: 46,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
