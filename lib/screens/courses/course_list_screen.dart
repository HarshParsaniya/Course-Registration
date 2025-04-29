import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_registration/providers/course_provider.dart';
import 'package:student_registration/screens/courses/course_details_screen.dart';
import 'package:student_registration/widgets/course_card.dart';

class CourseListScreen extends StatefulWidget {
  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final _searchController = TextEditingController();
  List<String> _departments = [
    'All Departments',
    'Computer Science',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'Engineering',
    'Business',
    'Economics',
    'Psychology',
    'History',
    'Literature',
    'Arts',
  ];
  String _selectedDepartment = 'All Departments';
  List<String> _filters = ['All', 'Available', 'Popular'];
  String _selectedFilter = 'All';
  
  @override
  void initState() {
    super.initState();
    _loadCourses();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  Future<void> _loadCourses() async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    
    if (_selectedDepartment == 'All Departments') {
      await courseProvider.fetchAllCourses();
    } else {
      await courseProvider.fetchCoursesByDepartment(_selectedDepartment);
    }
  }
  
  Future<void> _searchCourses(String query) async {
    if (query.isEmpty) {
      await _loadCourses();
      return;
    }
    
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    await courseProvider.searchCourses(query);
  }
  
  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    
    return Scaffold(
      body: Column(
        children: [
          // Search and filter section
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search courses...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (value) {
                    _searchCourses(value);
                  },
                ),
                SizedBox(height: 16),
                
                // Department and filter row
                Row(
                  children: [
                    // Department dropdown
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedDepartment,
                            isExpanded: true,
                            hint: Text('Department'),
                            items: _departments.map((String department) {
                              return DropdownMenuItem<String>(
                                value: department,
                                child: Text(department),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedDepartment = newValue;
                                  _searchController.clear();
                                });
                                _loadCourses();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    
                    // Filter dropdown
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedFilter,
                          hint: Text('Filter'),
                          items: _filters.map((String filter) {
                            return DropdownMenuItem<String>(
                              value: filter,
                              child: Text(filter),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedFilter = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Course list
          Expanded(
            child: courseProvider.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : courseProvider.courses.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No courses found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: courseProvider.courses.length,
                        itemBuilder: (context, index) {
                          final course = courseProvider.courses[index];
                          
                          // Apply filters
                          if (_selectedFilter == 'Available' && !course.isAvailable) {
                            return SizedBox.shrink();
                          }
                          if (_selectedFilter == 'Popular' && course.rating < 4.0) {
                            return SizedBox.shrink();
                          }
                          
                          return CourseCard(
                            course: course,
                            onTap: () {
                              courseProvider.setSelectedCourse(course);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CourseDetailsScreen(),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

