import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  const AuthRepository(this._auth);

  /// Login dengan email dan password Firebase Auth
  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Logout dari sesi saat ini
  Future<void> signOut() => _auth.signOut();

  User? get currentUser => _auth.currentUser;
}
