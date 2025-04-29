import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_registration/models/user_model.dart';
import 'package:student_registration/providers/auth_provider.dart';
import 'package:student_registration/services/auth_service.dart';

// Create a mock AuthService
class MockAuthService extends Mock implements AuthService {
  @override
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    if (email == 'test@example.com' && password == 'password123') {
      return UserModel(
        id: 'test-user-id',
        name: 'Test User',
        email: 'test@example.com',
        studentId: 'ST12345',
        department: 'Computer Science',
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }
  
  @override
  Future<UserModel> registerWithEmailAndPassword(
    String name, 
    String email, 
    String password,
    String studentId,
    String department,
  ) async {
    return UserModel(
      id: 'new-user-id',
      name: name,
      email: email,
      studentId: studentId,
      department: department,
    );
  }
}

void main() {
  late MockAuthService mockAuthService;
  late AuthProvider authProvider;

  setUp(() {
    mockAuthService = MockAuthService();
    authProvider = AuthProvider(mockAuthService);
  });

  group('AuthProvider Tests', () {
    test('Sign in with valid credentials should return true', () async {
      // Act
      final result = await authProvider.signInWithEmailAndPassword(
        'test@example.com', 
        'password123'
      );

      // Assert
      expect(result, true);
      expect(authProvider.isAuthenticated, true);
      expect(authProvider.user, isNotNull);
      expect(authProvider.user!.email, 'test@example.com');
    });

    test('Sign in with invalid credentials should return false', () async {
      // Act
      final result = await authProvider.signInWithEmailAndPassword(
        'wrong@example.com', 
        'wrongpassword'
      );

      // Assert
      expect(result, false);
      expect(authProvider.isAuthenticated, false);
      expect(authProvider.user, isNull);
      expect(authProvider.error, isNotEmpty);
    });

    test('Register with valid data should return true', () async {
      // Act
      final result = await authProvider.registerWithEmailAndPassword(
        'New User',
        'new@example.com',
        'password123',
        'ST67890',
        'Mathematics',
      );

      // Assert
      expect(result, true);
      expect(authProvider.isAuthenticated, true);
      expect(authProvider.user, isNotNull);
      expect(authProvider.user!.name, 'New User');
      expect(authProvider.user!.email, 'new@example.com');
    });
  });
}

