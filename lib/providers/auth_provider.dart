// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;

  UserModel? _user;
  bool _isLoading = false;
  String _error = '';

  AuthProvider(this._authService);

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String get error => _error;

  // Private: Set loading
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Private: Set error
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = '';
    notifyListeners();
  }

  // Register
  Future<bool> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
    String studentId,
    String department,
  ) async {
    _setLoading(true);
    _setError('');

    try {
      _user = await _authService.registerWithEmailAndPassword(
        name,
        email,
        password,
        studentId,
        department,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign In
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _setLoading(true);
    _setError('');

    try {
      _user = await _authService.signInWithEmailAndPassword(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    _setLoading(true);
    _setError('');

    try {
      await _authService.signOut();
      _user = null;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Reset Password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _setError('');

    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

Future<bool> signInWithGoogle() async {
    try {
      final user = await _authService.signInWithGoogle();
      _user = user;
      notifyListeners();
      return true;
    } catch (e) {
      print('Google sign-in error: $e');
      return false;
    }
  }

  Future<bool> signInWithFacebook() async {
    try {
      final user = await _authService.signInWithFacebook();
      _user = user;
      notifyListeners();
      return true;
    } catch (e) {
      print('Facebook sign-in error: $e');
      return false;
    }
  }

//   Future<void> signOut() async {
//     await _authService.signOut();
//     _user = null;
//     notifyListeners();
//   }
// }

  // Update Profile
  Future<bool> updateUserProfile(UserModel updatedUser) async {
    _setLoading(true);
    _setError('');

    try {
      _user = await _authService.updateUserProfile(updatedUser);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }
}
