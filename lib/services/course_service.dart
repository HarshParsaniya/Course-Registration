import 'package:dio/dio.dart';
import 'package:student_registration/models/course_model.dart';

class CourseService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.example.com/courses'; // Replace with your API URL
  
  // Flag to use demo mode (no API)
  final bool _useDemoMode = true;

  // Get all courses from API
  Future<List<CourseModel>> fetchCoursesFromApi() async {
    if (_useDemoMode) {
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      return getMockCourses();
    }
    
    try {
      final response = await _dio.get(_baseUrl);
      
      if (response.statusCode == 200) {
        final List<dynamic> coursesData = response.data;
        return coursesData.map((data) => CourseModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching courses: ${e.toString()}');
    }
  }

  // Get course details from API
  Future<CourseModel> fetchCourseDetailsFromApi(String courseId) async {
    if (_useDemoMode) {
      await Future.delayed(Duration(milliseconds: 800)); // Simulate network delay
      return getMockCourses().firstWhere(
        (course) => course.id == courseId,
        orElse: () => throw Exception('Course not found'),
      );
    }
    
    try {
      final response = await _dio.get('$_baseUrl/$courseId');
      
      if (response.statusCode == 200) {
        return CourseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load course details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching course details: ${e.toString()}');
    }
  }

  // Search courses from API
  Future<List<CourseModel>> searchCoursesFromApi(String query) async {
    if (_useDemoMode) {
      await Future.delayed(Duration(milliseconds: 800)); // Simulate network delay
      return getMockCourses().where((course) => 
        course.title.toLowerCase().contains(query.toLowerCase()) ||
        course.description.toLowerCase().contains(query.toLowerCase()) ||
        course.instructor.toLowerCase().contains(query.toLowerCase()) ||
        course.department.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    
    try {
      final response = await _dio.get('$_baseUrl/search', queryParameters: {'q': query});
      
      if (response.statusCode == 200) {
        final List<dynamic> coursesData = response.data;
        return coursesData.map((data) => CourseModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to search courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching courses: ${e.toString()}');
    }
  }

  // Get courses by department from API
  Future<List<CourseModel>> fetchCoursesByDepartmentFromApi(String department) async {
    if (_useDemoMode) {
      await Future.delayed(Duration(milliseconds: 800)); // Simulate network delay
      return getMockCourses().where((course) => course.department == department).toList();
    }
    
    try {
      final response = await _dio.get('$_baseUrl/department/$department');
      
      if (response.statusCode == 200) {
        final List<dynamic> coursesData = response.data;
        return coursesData.map((data) => CourseModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load department courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching department courses: ${e.toString()}');
    }
  }

  // Mock data for testing when API is not available
  List<CourseModel> getMockCourses() {
    return [
      CourseModel(
        id: '1',
        title: 'Introduction to Computer Science',
        description: 'A foundational course covering basic concepts in computer science, including algorithms, data structures, and programming fundamentals.',
        instructor: 'Dr. Jane Smith',
        imageUrl: 'https://source.unsplash.com/random/300x200?computer',
        credits: 3,
        department: 'Computer Science',
        schedule: 'Mon, Wed, Fri 10:00 AM - 11:30 AM',
        capacity: 50,
        enrolled: 35,
        prerequisites: [],
        rating: 4.5,
      ),
      CourseModel(
        id: '2',
        title: 'Calculus I',
        description: 'An introduction to differential and integral calculus, covering limits, derivatives, and basic integration techniques.',
        instructor: 'Dr. Michael Johnson',
        imageUrl: 'https://source.unsplash.com/random/300x200?math',
        credits: 4,
        department: 'Mathematics',
        schedule: 'Tue, Thu 9:00 AM - 11:00 AM',
        capacity: 40,
        enrolled: 38,
        prerequisites: ['Precalculus'],
        rating: 4.2,
      ),
      CourseModel(
        id: '3',
        title: 'Introduction to Psychology',
        description: 'A survey of the major concepts, theories, and research findings in psychology, including biological bases of behavior, learning, memory, and social psychology.',
        instructor: 'Dr. Sarah Williams',
        imageUrl: 'https://source.unsplash.com/random/300x200?psychology',
        credits: 3,
        department: 'Psychology',
        schedule: 'Mon, Wed 1:00 PM - 2:30 PM',
        capacity: 60,
        enrolled: 45,
        prerequisites: [],
        rating: 4.7,
      ),
      CourseModel(
        id: '4',
        title: 'Organic Chemistry',
        description: 'Study of the structure, properties, composition, reactions, and preparation of carbon-containing compounds.',
        instructor: 'Dr. Robert Chen',
        imageUrl: 'https://source.unsplash.com/random/300x200?chemistry',
        credits: 4,
        department: 'Chemistry',
        schedule: 'Tue, Thu 1:00 PM - 3:00 PM',
        capacity: 30,
        enrolled: 25,
        prerequisites: ['General Chemistry'],
        rating: 4.0,
      ),
      CourseModel(
        id: '5',
        title: 'World History',
        description: 'A comprehensive overview of major historical events and developments across different civilizations and time periods.',
        instructor: 'Dr. Emily Rodriguez',
        imageUrl: 'https://source.unsplash.com/random/300x200?history',
        credits: 3,
        department: 'History',
        schedule: 'Mon, Wed, Fri 2:00 PM - 3:00 PM',
        capacity: 45,
        enrolled: 30,
        prerequisites: [],
        rating: 4.3,
      ),
    ];
  }
}

