import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_registration/models/user_model.dart';
import 'package:student_registration/models/course_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Flag to use demo mode (no Firebase)
  final bool _useDemoMode = true;
  
  // Demo data
  final List<UserModel> _demoUsers = [];
  final List<CourseModel> _demoCourses = [
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

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _coursesCollection => _firestore.collection('courses');

  // Check if user exists
  Future<bool> checkUserExists(String userId) async {
    if (_useDemoMode) {
      await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
      return _demoUsers.any((user) => user.id == userId);
    }
    
    try {
      DocumentSnapshot doc = await _usersCollection.doc(userId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking user: ${e.toString()}');
      // Return false for demo purposes if Firestore is not available
      return false;
    }
  }

  // Create user
  Future<void> createUser(UserModel user) async {
    if (_useDemoMode) {
      await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
      _demoUsers.add(user);
      return;
    }
    
    try {
      await _usersCollection.doc(user.id).set(user.toJson());
    } catch (e) {
      print('Error creating user: ${e.toString()}');
      // For demo purposes, we'll just print the error and continue
    }
  }

  // Get user
  Future<UserModel> getUser(String userId) async {
    if (_useDemoMode) {
      await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
      final user = _demoUsers.firstWhere(
        (user) => user.id == userId,
        orElse: () => throw Exception('User not found'),
      );
      return user;
    }
    
    try {
      DocumentSnapshot doc = await _usersCollection.doc(userId).get();
      if (!doc.exists) {
        throw Exception('User not found');
      }
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error getting user: ${e.toString()}');
      // For demo purposes, throw the exception to be handled by the caller
      throw Exception('Error getting user: ${e.toString()}');
    }
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
    if (_useDemoMode) {
      await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
      final index = _demoUsers.indexWhere((u) => u.id == user.id);
      if (index >= 0) {
        _demoUsers[index] = user;
      } else {
        _demoUsers.add(user);
      }
      return;
    }
    
    try {
      await _usersCollection.doc(user.id).update(user.toJson());
    } catch (e) {
      print('Error updating user: ${e.toString()}');
      // For demo purposes, we'll just print the error and continue
    }
  }

  // Get all courses
  Future<List<CourseModel>> getAllCourses() async {
    if (_useDemoMode) {
      await Future.delayed(Duration(milliseconds: 800)); // Simulate network delay
      return _demoCourses;
    }
    
    try {
      QuerySnapshot snapshot = await _coursesCollection.get();
      return snapshot.docs
          .map((doc) => CourseModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting courses: ${e.toString()}');
      // Return demo courses for demo purposes if Firestore is not available
      return _demoCourses;
    }
  }

  // Get courses by department
  Future<List<CourseModel>> getCoursesByDepartment(String department) async {
    if (_useDemoMode) {
      await Future.delayed(Duration(milliseconds: 800)); // Simulate network delay
      return _demoCourses.where((course) => course.department == department).toList();
    }
    
    try {
      QuerySnapshot snapshot = await _coursesCollection
          .where('department', isEqualTo: department)
          .get();
      return snapshot.docs
          .map((doc) => CourseModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting courses by department: ${e.toString()}');
      // Return filtered demo courses for demo purposes if Firestore is not available
      return _demoCourses.where((course) => course.department == department).toList();
    }
  }

  // Get course by ID
  Future<CourseModel> getCourseById(String courseId) async {
    if (_useDemoMode) {
      await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
      final course = _demoCourses.firstWhere(
        (course) => course.id == courseId,
        orElse: () => throw Exception('Course not found'),
      );
      return course;
    }
    
    try {
      DocumentSnapshot doc = await _coursesCollection.doc(courseId).get();
      if (!doc.exists) {
        throw Exception('Course not found');
      }
      return CourseModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error getting course: ${e.toString()}');
      // For demo purposes, throw the exception to be handled by the caller
      throw Exception('Error getting course: ${e.toString()}');
    }
  }

  // Enroll in course
  Future<void> enrollInCourse(String userId, String courseId) async {
    if (_useDemoMode) {
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      
      // Find user
      final userIndex = _demoUsers.indexWhere((user) => user.id == userId);
      if (userIndex < 0) {
        throw Exception('User not found');
      }
      
      // Find course
      final courseIndex = _demoCourses.indexWhere((course) => course.id == courseId);
      if (courseIndex < 0) {
        throw Exception('Course not found');
      }
      
      // Check if already enrolled
      if (_demoUsers[userIndex].enrolledCourses.contains(courseId)) {
        throw Exception('Already enrolled in this course');
      }
      
      // Check if course is full
      if (_demoCourses[courseIndex].enrolled >= _demoCourses[courseIndex].capacity) {
        throw Exception('Course is full');
      }
      
      // Update user's enrolled courses
      final updatedUser = _demoUsers[userIndex].copyWith(
        enrolledCourses: [..._demoUsers[userIndex].enrolledCourses, courseId],
      );
      _demoUsers[userIndex] = updatedUser;
      
      // Update course enrollment count
      final updatedCourse = _demoCourses[courseIndex].copyWith(
        enrolled: _demoCourses[courseIndex].enrolled + 1,
      );
      _demoCourses[courseIndex] = updatedCourse;
      
      return;
    }
    
    try {
      // Get user and course
      UserModel user = await getUser(userId);
      CourseModel course = await getCourseById(courseId);

      // Check if already enrolled
      if (user.enrolledCourses.contains(courseId)) {
        throw Exception('Already enrolled in this course');
      }

      // Check if course is full
      if (course.enrolled >= course.capacity) {
        throw Exception('Course is full');
      }

      // Update user's enrolled courses
      List<String> updatedCourses = List.from(user.enrolledCourses)..add(courseId);
      await _usersCollection.doc(userId).update({
        'enrolledCourses': updatedCourses,
      });

      // Update course enrollment count
      await _coursesCollection.doc(courseId).update({
        'enrolled': course.enrolled + 1,
      });
    } catch (e) {
      print('Error enrolling in course: ${e.toString()}');
      throw Exception('Error enrolling in course: ${e.toString()}');
    }
  }

  // Unenroll from course
  Future<void> unenrollFromCourse(String userId, String courseId) async {
    if (_useDemoMode) {
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      
      // Find user
      final userIndex = _demoUsers.indexWhere((user) => user.id == userId);
      if (userIndex < 0) {
        throw Exception('User not found');
      }
      
      // Find course
      final courseIndex = _demoCourses.indexWhere((course) => course.id == courseId);
      if (courseIndex < 0) {
        throw Exception('Course not found');
      }
      
      // Check if enrolled
      if (!_demoUsers[userIndex].enrolledCourses.contains(courseId)) {
        throw Exception('Not enrolled in this course');
      }
      
      // Update user's enrolled courses
      final updatedEnrolledCourses = List<String>.from(_demoUsers[userIndex].enrolledCourses)
        ..remove(courseId);
      
      final updatedUser = _demoUsers[userIndex].copyWith(
        enrolledCourses: updatedEnrolledCourses,
      );
      _demoUsers[userIndex] = updatedUser;
      
      // Update course enrollment count
      final updatedCourse = _demoCourses[courseIndex].copyWith(
        enrolled: _demoCourses[courseIndex].enrolled - 1,
      );
      _demoCourses[courseIndex] = updatedCourse;
      
      return;
    }
    
    try {
      // Get user and course
      UserModel user = await getUser(userId);
      CourseModel course = await getCourseById(courseId);

      // Check if enrolled
      if (!user.enrolledCourses.contains(courseId)) {
        throw Exception('Not enrolled in this course');
      }

      // Update user's enrolled courses
      List<String> updatedCourses = List.from(user.enrolledCourses)..remove(courseId);
      await _usersCollection.doc(userId).update({
        'enrolledCourses': updatedCourses,
      });

      // Update course enrollment count
      await _coursesCollection.doc(courseId).update({
        'enrolled': course.enrolled - 1,
      });
    } catch (e) {
      print('Error unenrolling from course: ${e.toString()}');
      throw Exception('Error unenrolling from course: ${e.toString()}');
    }
  }

  // Get user's enrolled courses
  Future<List<CourseModel>> getUserEnrolledCourses(String userId) async {
    if (_useDemoMode) {
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      
      // Find user
      final userIndex = _demoUsers.indexWhere((user) => user.id == userId);
      if (userIndex < 0) {
        return []; // Return empty list if user not found
      }
      
      // Get enrolled courses
      final enrolledCourseIds = _demoUsers[userIndex].enrolledCourses;
      return _demoCourses.where((course) => enrolledCourseIds.contains(course.id)).toList();
    }
    
    try {
      UserModel user = await getUser(userId);
      List<CourseModel> enrolledCourses = [];

      for (String courseId in user.enrolledCourses) {
        try {
          CourseModel course = await getCourseById(courseId);
          enrolledCourses.add(course);
        } catch (e) {
          print('Error getting course $courseId: ${e.toString()}');
          // Continue with the next course
        }
      }

      return enrolledCourses;
    } catch (e) {
      print('Error getting enrolled courses: ${e.toString()}');
      // Return empty list for demo purposes if Firestore is not available
      return [];
    }
  }

  // Search courses
  Future<List<CourseModel>> searchCourses(String query) async {
    if (_useDemoMode) {
      await Future.delayed(Duration(milliseconds: 800)); // Simulate network delay
      
      // Filter courses based on query
      return _demoCourses.where((course) {
        return course.title.toLowerCase().contains(query.toLowerCase()) ||
               course.description.toLowerCase().contains(query.toLowerCase()) ||
               course.instructor.toLowerCase().contains(query.toLowerCase()) ||
               course.department.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    
    try {
      // Get all courses (in a real app, you'd use a more efficient query)
      List<CourseModel> allCourses = await getAllCourses();
      
      // Filter courses based on query
      return allCourses.where((course) {
        return course.title.toLowerCase().contains(query.toLowerCase()) ||
               course.description.toLowerCase().contains(query.toLowerCase()) ||
               course.instructor.toLowerCase().contains(query.toLowerCase()) ||
               course.department.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      print('Error searching courses: ${e.toString()}');
      // Return empty list for demo purposes if Firestore is not available
      return [];
    }
  }
}

