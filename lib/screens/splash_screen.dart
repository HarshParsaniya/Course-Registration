import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_registration/providers/auth_provider.dart';
import 'package:student_registration/screens/auth/login_screen.dart';
import 'package:student_registration/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Simulate loading time
    await Future.delayed(Duration(seconds: 2));
    
    if (!mounted) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Navigate based on authentication status
    if (authProvider.isAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Icon(
              Icons.school,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 24),
            // App name
            Text(
              'Student Course Registration',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 48),
            // Loading indicator
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

