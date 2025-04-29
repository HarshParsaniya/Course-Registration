import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:student_registration/models/user_model.dart';
import 'package:student_registration/services/database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DatabaseService _databaseService = DatabaseService();

  // Toggle demo mode for testing purposes
  final bool _useDemoMode = true;

  // Get currently signed-in user
  User? get currentUser => _auth.currentUser;

  // Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    if (_useDemoMode) {
      await Future.delayed(Duration(seconds: 1));
      return UserModel(
        id: 'demo-user-id',
        name: 'Demo User',
        email: email,
        photoUrl: '',
        enrolledCourses: [],
        department: 'Computer Science',
        studentId: 'DEMO123',
      );
    }

    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = result.user;
      if (user == null) throw Exception('User not found');

      // Try fetching user data from Firestore
      try {
        final UserModel userData = await _databaseService.getUser(user.uid);
        return userData;
      } catch (_) {
        // If user not found in database, create a basic profile
        final UserModel newUser = UserModel(
          id: user.uid,
          name: user.displayName ?? 'User',
          email: user.email ?? '',
          photoUrl: user.photoURL ?? '',
        );
        await _databaseService.createUser(newUser);
        return newUser;
      }
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  /// Register a new user with email and password
  Future<UserModel> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
    String studentId,
    String department,
  ) async {
    if (_useDemoMode) {
      await Future.delayed(Duration(seconds: 1));
      return UserModel(
        id: 'demo-user-id',
        name: name,
        email: email,
        photoUrl: '',
        enrolledCourses: [],
        department: department,
        studentId: studentId,
      );
    }

    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = result.user;
      if (user == null) throw Exception('Failed to create user');

      await user.updateDisplayName(name);

      final UserModel newUser = UserModel(
        id: user.uid,
        name: name,
        email: email,
        photoUrl: user.photoURL ?? '',
        enrolledCourses: [],
        department: department,
        studentId: studentId,
      );

      await _databaseService.createUser(newUser);
      return newUser;
    } catch (e) {
      throw Exception('Failed to register: ${e.toString()}');
    }
  }

  /// Sign in using Google
  Future<UserModel> signInWithGoogle() async {
    if (_useDemoMode) {
      await Future.delayed(Duration(seconds: 1));
      return UserModel(
        id: 'demo-google-user-id',
        name: 'Google User',
        email: 'google.user@example.com',
        photoUrl: '',
        enrolledCourses: [],
        department: 'Computer Science',
        studentId: 'GOOGLE123',
      );
    }

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign in aborted');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential result = await _auth.signInWithCredential(credential);
      final User? user = result.user;
      if (user == null) throw Exception('Failed to sign in with Google');

      // Check if user exists
      bool userExists = await _databaseService.checkUserExists(user.uid);

      if (!userExists) {
        final UserModel newUser = UserModel(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          photoUrl: user.photoURL ?? '',
          enrolledCourses: [],
        );
        await _databaseService.createUser(newUser);
        return newUser;
      } else {
        return await _databaseService.getUser(user.uid);
      }
    } catch (e) {
      throw Exception('Failed to sign in with Google: ${e.toString()}');
    }
  }

  /// Sign in using Facebook
  Future<UserModel> signInWithFacebook() async {
    if (_useDemoMode) {
      await Future.delayed(Duration(seconds: 1));
      return UserModel(
        id: 'demo-facebook-user-id',
        name: 'Facebook User',
        email: 'facebook.user@example.com',
        photoUrl: '',
        enrolledCourses: [],
        department: 'Computer Science',
        studentId: 'FB123',
      );
    }

    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status != LoginStatus.success) {
        throw Exception('Facebook login failed');
      }

      final OAuthCredential credential = FacebookAuthProvider.credential(
        loginResult.accessToken!.tokenString,
      );

      final UserCredential result = await _auth.signInWithCredential(credential);
      final User? user = result.user;
      if (user == null) throw Exception('Failed to sign in with Facebook');

      bool userExists = await _databaseService.checkUserExists(user.uid);

      if (!userExists) {
        final UserModel newUser = UserModel(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          photoUrl: user.photoURL ?? '',
          enrolledCourses: [],
        );
        await _databaseService.createUser(newUser);
        return newUser;
      } else {
        return await _databaseService.getUser(user.uid);
      }
    } catch (e) {
      throw Exception('Failed to sign in with Facebook: ${e.toString()}');
    }
  }

  /// Sign out from all providers
  Future<void> signOut() async {
    if (_useDemoMode) {
      await Future.delayed(Duration(milliseconds: 500));
      return;
    }

    try {
      await _googleSignIn.signOut();
      await FacebookAuth.instance.logOut();
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    if (_useDemoMode) {
      await Future.delayed(Duration(seconds: 1));
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: ${e.toString()}');
    }
  }

  /// Update user profile in Firestore
  Future<UserModel> updateUserProfile(UserModel user) async {
    if (_useDemoMode) {
      await Future.delayed(Duration(seconds: 1));
      return user;
    }

    try {
      await _databaseService.updateUser(user);
      return user;
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }
}
