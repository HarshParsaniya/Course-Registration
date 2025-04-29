import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_registration/providers/auth_provider.dart';
import 'package:student_registration/providers/course_provider.dart';
import 'package:student_registration/screens/auth/login_screen.dart';
import 'package:student_registration/screens/courses/course_list_screen.dart';
import 'package:student_registration/screens/courses/enrolled_courses_screen.dart';
import 'package:student_registration/screens/profile/profile_screen.dart';
import 'package:student_registration/widgets/dashboard_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);

    if (authProvider.user != null) {
      await courseProvider.fetchEnrolledCourses(authProvider.user!.id);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _signOut() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final courseProvider = Provider.of<CourseProvider>(context);

    // List of screens for bottom navigation
    final List<Widget> _screens = [
      _buildDashboardScreen(),
      CourseListScreen(),
      EnrolledCoursesScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Portal'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'My Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardScreen() {
    final authProvider = Provider.of<AuthProvider>(context);
    final courseProvider = Provider.of<CourseProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    backgroundImage:
                        authProvider.user?.photoUrl.isNotEmpty == true
                            ? NetworkImage(authProvider.user!.photoUrl)
                            : null,
                    child: authProvider.user?.photoUrl.isEmpty == true
                        ? Text(
                            authProvider.user?.name.isNotEmpty == true
                                ? authProvider.user!.name[0].toUpperCase()
                                : 'S',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          authProvider.user?.name ?? 'Student',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (authProvider.user?.studentId.isNotEmpty == true)
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              'ID: ${authProvider.user!.studentId}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),

          // Dashboard stats
          Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),

          // Dashboard cards
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              DashboardCard(
                title: 'Enrolled Courses',
                value: courseProvider.enrolledCourses.length.toString(),
                icon: Icons.book,
                color: Colors.blue,
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
              ),
              DashboardCard(
                title: 'Available Courses',
                value: 'Browse',
                icon: Icons.search,
                color: Colors.green,
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),
              DashboardCard(
                title: 'Department',
                value: authProvider.user?.department ?? 'Not set',
                icon: Icons.business,
                color: Colors.orange,
                onTap: () {
                  setState(() {
                    _selectedIndex = 3;
                  });
                },
              ),
              DashboardCard(
                title: 'Profile',
                value: 'View',
                icon: Icons.person,
                color: Colors.purple,
                onTap: () {
                  setState(() {
                    _selectedIndex = 3;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 24),

          // Enrolled courses section
          Text(
            'My Courses',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),

          // Enrolled courses list
          if (courseProvider.isLoading)
            Center(
              child: CircularProgressIndicator(),
            )
          else if (courseProvider.enrolledCourses.isEmpty)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'You are not enrolled in any courses yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       _selectedIndex = 1;
                    //     });
                    //   },
                    //   child: Text('Browse Courses'),
                    // ),
                    // In the _buildDashboardScreen method, replace the current ElevatedButton with:
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor:
                            Colors.white, // Ensures text is visible
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        'Browse Courses',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Explicit text color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: courseProvider.enrolledCourses.length > 3
                  ? 3
                  : courseProvider.enrolledCourses.length,
              itemBuilder: (context, index) {
                final course = courseProvider.enrolledCourses[index];
                return Card(
                  elevation: 1,
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        course.title[0].toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      course.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Instructor: ${course.instructor}\nSchedule: ${course.schedule}',
                    ),
                    isThreeLine: true,
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      courseProvider.setSelectedCourse(course);
                      Navigator.pushNamed(context, '/course-details');
                    },
                  ),
                );
              },
            ),

          if (courseProvider.enrolledCourses.length > 3)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                child: Text('View All Courses'),
              ),
            ),
        ],
      ),
    );
  }
}
