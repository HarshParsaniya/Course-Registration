import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_registration/models/course_model.dart';
import 'package:student_registration/providers/course_provider.dart';
import 'package:student_registration/services/course_service.dart';
import 'package:student_registration/services/database_service.dart';

// Create mock services
class MockCourseService extends Mock implements CourseService {
  @override
  List<CourseModel> getMockCourses() {
    return [
      CourseModel(
        id: '1',
        title: 'Introduction to Computer Science',
        description: 'A foundational course covering basic concepts in computer science.',
        instructor: 'Dr. Jane Smith',
        credits: 3,
        department: 'Computer Science',
        schedule: 'Mon, Wed, Fri 10:00 AM - 11:30 AM',
        capacity: 50,
        enrolled: 35,
      ),
      CourseModel(
        id: '2',
        title: 'Calculus I',
        description: 'An introduction to differential and integral calculus.',
        instructor: 'Dr. Michael Johnson',
        credits: 4,
        department: 'Mathematics',
        schedule: 'Tue, Thu 9:00 AM - 11:00 AM',
        capacity: 40,
        enrolled: 38,
      ),
    ];
  }
  
  @override
  Future<List<CourseModel>> fetchCoursesFromApi() async {
    return getMockCourses();
  }
  
  @override
  Future<List<CourseModel>> searchCoursesFromApi(String query) async {
    return getMockCourses().where((course) => 
      course.title.toLowerCase().contains(query.toLowerCase())).toList();
  }
}

class MockDatabaseService extends Mock implements DatabaseService {
  @override
  Future<List<CourseModel>> getUserEnrolledCourses(String userId) async {
    return [
      CourseModel(
        id: '1',
        title: 'Introduction to Computer Science',
        description: 'A foundational course covering basic concepts in computer science.',
        instructor: 'Dr. Jane Smith',
        credits: 3,
        department: 'Computer Science',
        schedule: 'Mon, Wed, Fri 10:00 AM - 11:30 AM',
        capacity: 50,
        enrolled: 35,
      ),
    ];
  }
}

void main() {
  late MockCourseService mockCourseService;
  late MockDatabaseService mockDatabaseService;
  late CourseProvider courseProvider;

  setUp(() {
    mockCourseService = MockCourseService();
    mockDatabaseService = MockDatabaseService();
    courseProvider = CourseProvider(mockCourseService, mockDatabaseService);
  });

  group('CourseProvider Tests', () {
    test('fetchAllCourses should populate courses list', () async {
      // Act
      await courseProvider.fetchAllCourses();

      // Assert
      expect(courseProvider.courses.length, 2);
      expect(courseProvider.courses[0].title, 'Introduction to Computer Science');
      expect(courseProvider.courses[1].title, 'Calculus I');
    });

    test('fetchEnrolledCourses should populate enrolled courses list', () async {
      // Act
      await courseProvider.fetchEnrolledCourses('test-user-id');

      // Assert
      expect(courseProvider.enrolledCourses.length, 1);
      expect(courseProvider.enrolledCourses[0].title, 'Introduction to Computer Science');
    });

    test('searchCourses should return matching courses', () async {
      // Act
      final results = await courseProvider.searchCourses('calculus');

      // Assert
      expect(results.length, 1);
      expect(results[0].title, 'Calculus I');
    });
  });
}

