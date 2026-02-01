// auth_service.dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mobile-only helper. (For web we use Firebase Auth popup/redirect)
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email', 'profile'],
  );

  bool _isSigningIn = false;
  bool get isSigningIn => _isSigningIn;

  /// Google Sign-In (Firebase-backed) - Multi-platform
  /// ✅ Strict access: ONLY users already pre-authorized in /users/{uid}
  /// ✅ Required fields: { uid, email, role: "manager|frontdesk", createdAt }
  /// ❌ No public/customer access: unauthorized users are signed out immediately
  Future<UserCredential?> signInWithGoogle() async {
    if (_isSigningIn) return null;
    _isSigningIn = true;

    try {
      late final UserCredential userCredential;

      if (kIsWeb) {
        final provider = GoogleAuthProvider()
          ..setCustomParameters(<String, String>{'prompt': 'select_account'});

        try {
          userCredential = await _auth.signInWithPopup(provider);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'popup-closed-by-user') {
            throw AuthException('Sign-in cancelled by user.');
          }
          if (e.code == 'popup-blocked') {
            throw AuthException(
              'Popup was blocked. Please allow popups and try again.',
            );
          }
          rethrow;
        }
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          throw AuthException('Sign-in cancelled by user.');
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        if (googleAuth.idToken == null) {
          throw AuthException('Missing Google ID token.');
        }

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await _auth.signInWithCredential(credential);
      }

      final user = userCredential.user;
      if (user == null) {
        throw AuthException('Failed to retrieve user information.');
      }

      // 🔒 STRICT: authorize against Firestore users collection (pre-authorized only)
      await _requireAuthorizedUser(user);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_friendlyFirebaseAuthMessage(e));
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Something went wrong. Please try again.\n$e');
    } finally {
      _isSigningIn = false;
    }
  }

  Future<void> _requireAuthorizedUser(User user) async {
    final ref = _firestore.collection('users').doc(user.uid);
    final snap = await ref.get();

    // Not pre-authorized => deny
    if (!snap.exists) {
      await signOut();
      throw AuthException('Access Restricted');
    }

    final data = snap.data();
    if (data == null) {
      await signOut();
      throw AuthException('Access Restricted');
    }

    final role = (data['role'] ?? '').toString().trim().toLowerCase();
    if (role != 'manager' && role != 'frontdesk') {
      await signOut();
      throw AuthException('Access Restricted');
    }

    // Optional hardening: ensure email matches (if available)
    final storedEmail = (data['email'] ?? '').toString().trim().toLowerCase();
    final authEmail = (user.email ?? '').trim().toLowerCase();
    if (storedEmail.isNotEmpty && authEmail.isNotEmpty && storedEmail != authEmail) {
      await signOut();
      throw AuthException('Access Restricted');
    }

    // ❌ DO NOT upsert user here (no public/customer access)
    // Managers can manage user docs via admin tooling/scripts only.
  }

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<void> signOut() async {
    if (!kIsWeb) {
      try {
        await _googleSignIn.signOut();
      } catch (_) {}
    }
    await _auth.signOut();
  }

  String _friendlyFirebaseAuthMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'This email is already linked to another sign-in method.';
      case 'invalid-credential':
        return 'Invalid sign-in credentials. Please try again.';
      case 'operation-not-allowed':
        return 'Google sign-in is not enabled for this project.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
