import 'package:flutter/material.dart';
import 'package:student_registration/models/course_model.dart';
import 'package:student_registration/services/course_service.dart';
import 'package:student_registration/services/database_service.dart';

class CourseProvider with ChangeNotifier {
  final CourseService _courseService;
  final DatabaseService _databaseService;
  
  List<CourseModel> _courses = [];
  List<CourseModel> _enrolledCourses = [];
  CourseModel? _selectedCourse;
  bool _isLoading = false;
  String _error = '';
  
  CourseProvider(this._courseService, this._databaseService);

  // Getters
  List<CourseModel> get courses => _courses;
  List<CourseModel> get enrolledCourses => _enrolledCourses;
  CourseModel? get selectedCourse => _selectedCourse;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = '';
    notifyListeners();
  }

  // Set selected course
  void setSelectedCourse(CourseModel course) {
    _selectedCourse = course;
    notifyListeners();
  }

  // Fetch all courses
  Future<void> fetchAllCourses() async {
    _setLoading(true);
    _setError('');
    
    try {
      // Try to fetch from API first
      try {
        _courses = await _courseService.fetchCoursesFromApi();
      } catch (apiError) {
        // If API fails, try to fetch from Firestore
        try {
          _courses = await _databaseService.getAllCourses();
        } catch (dbError) {
          // If both fail, use mock data
          _courses = _courseService.getMockCourses();
        }
      }
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load courses: ${e.toString()}');
      _setLoading(false);
    }
  }

  // Fetch courses by department
  Future<void> fetchCoursesByDepartment(String department) async {
    _setLoading(true);
    _setError('');
    
    try {
      // Try to fetch from API first
      try {
        _courses = await _courseService.fetchCoursesByDepartmentFromApi(department);
      } catch (apiError) {
        // If API fails, try to fetch from Firestore
        _courses = await _databaseService.getCoursesByDepartment(department);
      }
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load department courses: ${e.toString()}');
      _setLoading(false);
    }
  }

  // Fetch course details
  Future<void> fetchCourseDetails(String courseId) async {
    _setLoading(true);
    _setError('');
    
    try {
      // Try to fetch from API first
      try {
        _selectedCourse = await _courseService.fetchCourseDetailsFromApi(courseId);
      } catch (apiError) {
        // If API fails, try to fetch from Firestore
        _selectedCourse = await _databaseService.getCourseById(courseId);
      }
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load course details: ${e.toString()}');
      _setLoading(false);
    }
  }

  // Search courses
  Future<List<CourseModel>> searchCourses(String query) async {
    _setLoading(true);
    _setError('');
    
    try {
      List<CourseModel> searchResults = [];
      
      // Try to search from API first
      try {
        searchResults = await _courseService.searchCoursesFromApi(query);
      } catch (apiError) {
        // If API fails, try to search from Firestore
        searchResults = await _databaseService.searchCourses(query);
      }
      
      _setLoading(false);
      return searchResults;
    } catch (e) {
      _setError('Failed to search courses: ${e.toString()}');
      _setLoading(false);
      return [];
    }
  }

  // Fetch user's enrolled courses
  Future<void> fetchEnrolledCourses(String userId) async {
    _setLoading(true);
    _setError('');
    
    try {
      _enrolledCourses = await _databaseService.getUserEnrolledCourses(userId);
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load enrolled courses: ${e.toString()}');
      _setLoading(false);
    }
  }

  // Enroll in course
  Future<bool> enrollInCourse(String userId, String courseId) async {
    _setLoading(true);
    _setError('');
    
    try {
      await _databaseService.enrollInCourse(userId, courseId);
      
      // Refresh enrolled courses
      await fetchEnrolledCourses(userId);
      
      // Refresh selected course if it's the one being enrolled in
      if (_selectedCourse != null && _selectedCourse!.id == courseId) {
        await fetchCourseDetails(courseId);
      }
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to enroll in course: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Unenroll from course
  Future<bool> unenrollFromCourse(String userId, String courseId) async {
    _setLoading(true);
    _setError('');
    
    try {
      await _databaseService.unenrollFromCourse(userId, courseId);
      
      // Refresh enrolled courses
      await fetchEnrolledCourses(userId);
      
      // Refresh selected course if it's the one being unenrolled from
      if (_selectedCourse != null && _selectedCourse!.id == courseId) {
        await fetchCourseDetails(courseId);
      }
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to unenroll from course: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }
}

