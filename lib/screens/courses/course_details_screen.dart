import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_registration/models/course_model.dart';
import 'package:student_registration/providers/auth_provider.dart';
import 'package:student_registration/providers/course_provider.dart';

class CourseDetailsScreen extends StatefulWidget {
  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  bool _isEnrolling = false;

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final course = courseProvider.selectedCourse;

    if (course == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Course Details'),
        ),
        body: Center(
          child: Text('Course not found'),
        ),
      );
    }

    final bool isEnrolled = authProvider.user != null &&
        authProvider.user!.enrolledCourses.contains(course.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Course Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: course.imageUrl.isNotEmpty
                  ? Image.network(
                      course.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.book,
                            size: 64,
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Icon(
                        Icons.book,
                        size: 64,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
            ),

            // Course info
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          course.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              course.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // Department and credits
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        course.department,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(
                        Icons.school,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${course.credits} Credits',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Instructor
                  Text(
                    'Instructor',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          course.instructor[0].toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        course.instructor,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Schedule
                  Text(
                    'Schedule',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            course.schedule,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Capacity
                  Text(
                    'Capacity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: course.enrolled / course.capacity,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      course.enrolled < course.capacity
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${course.enrolled}/${course.capacity} students enrolled',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Prerequisites
                  if (course.prerequisites.isNotEmpty) ...[
                    Text(
                      'Prerequisites',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    ...course.prerequisites.map((prerequisite) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Colors.green,
                            ),
                            SizedBox(width: 8),
                            Text(prerequisite),
                          ],
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 16),
                  ],

                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    course.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Error message
                  if (courseProvider.error.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[300]!),
                      ),
                      child: Text(
                        courseProvider.error,
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),

                  // Enroll/Unenroll button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isEnrolling || courseProvider.isLoading
                          ? null
                          : () async {
                              if (authProvider.user == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'You need to be logged in to enroll'),
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                _isEnrolling = true;
                              });

                              try {
                                if (isEnrolled) {
                                  await courseProvider.unenrollFromCourse(
                                    authProvider.user!.id,
                                    course.id,
                                  );

                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Successfully unenrolled from course'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } else {
                                  if (!course.isAvailable) {
                                    throw Exception('Course is full');
                                  }

                                  await courseProvider.enrollInCourse(
                                    authProvider.user!.id,
                                    course.id,
                                  );

                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Successfully enrolled in course'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    _isEnrolling = false;
                                  });
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: isEnrolled ? Colors.red : null,
                      ),
                      child: _isEnrolling || courseProvider.isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  isEnrolled
                                      ? 'Unenrolling...'
                                      : 'Enrolling...',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            )
                          : Text(
                              isEnrolled ? 'Unenroll' : 'Enroll Now',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white), // Ensure visibility
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
