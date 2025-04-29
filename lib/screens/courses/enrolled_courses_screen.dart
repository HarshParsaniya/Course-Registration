// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:student_registration/providers/auth_provider.dart';
// import 'package:student_registration/providers/course_provider.dart';
// import 'package:student_registration/screens/courses/course_details_screen.dart';
// import 'package:student_registration/widgets/course_card.dart';

// class EnrolledCoursesScreen extends StatefulWidget {
//   @override
//   _EnrolledCoursesScreenState createState() => _EnrolledCoursesScreenState();
// }

// class _EnrolledCoursesScreenState extends State<EnrolledCoursesScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _loadEnrolledCourses();
//   }
  
//   Future<void> _loadEnrolledCourses() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    
//     if (authProvider.user != null) {
//       await courseProvider.fetchEnrolledCourses(authProvider.user!.id);
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     final courseProvider = Provider.of<CourseProvider>(context);
    
//     return RefreshIndicator(
//       onRefresh: _loadEnrolledCourses,
//       child: courseProvider.isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : courseProvider.enrolledCourses.isEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.school_outlined,
//                         size: 64,
//                         color: Colors.grey,
//                       ),
//                       SizedBox(height: 16),
//                       Text(
//                         'You are not enrolled in any courses yet',
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Navigate to course list
//                           DefaultTabController.of(context)?.animateTo(1);
//                         },
//                         child: Text('Browse Courses'),
//                       ),
//                     ],
//                   ),
//                 )
//               : ListView.builder(
//                   padding: EdgeInsets.all(16),
//                   itemCount: courseProvider.enrolledCourses.length,
//                   itemBuilder: (context, index) {
//                     final course = courseProvider.enrolledCourses[index];
//                     return CourseCard(
//                       course: course,
//                       onTap: () {
//                         courseProvider.setSelectedCourse(course);
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => CourseDetailsScreen(),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_registration/providers/auth_provider.dart';
import 'package:student_registration/providers/course_provider.dart';
import 'package:student_registration/screens/courses/course_details_screen.dart';
import 'package:student_registration/widgets/course_card.dart';

class EnrolledCoursesScreen extends StatefulWidget {
  @override
  _EnrolledCoursesScreenState createState() => _EnrolledCoursesScreenState();
}

class _EnrolledCoursesScreenState extends State<EnrolledCoursesScreen> {
  @override
  void initState() {
    super.initState();
    _loadEnrolledCourses();
  }

  Future<void> _loadEnrolledCourses() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      await courseProvider.fetchEnrolledCourses(authProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    
    return RefreshIndicator(
      onRefresh: _loadEnrolledCourses,
      child: courseProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : courseProvider.enrolledCourses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.school_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'You are not enrolled in any courses yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to course list
                          DefaultTabController.of(context)?.animateTo(1);
                        },
                        child: Text('Browse Courses'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: courseProvider.enrolledCourses.length,
                  itemBuilder: (context, index) {
                    final course = courseProvider.enrolledCourses[index];
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
    );
  }
}