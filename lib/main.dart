// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:student_registration/firebase_options.dart';
// import 'package:student_registration/services/auth_service.dart';
// import 'package:student_registration/services/course_service.dart';
// import 'package:student_registration/services/database_service.dart';
// import 'package:student_registration/screens/splash_screen.dart';
// import 'package:student_registration/providers/auth_provider.dart';
// import 'package:student_registration/providers/course_provider.dart';
// import 'package:student_registration/utils/theme.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // Initialize Firebase with a try-catch to handle potential errors
//   try {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//   } catch (e) {
//     print('Failed to initialize Firebase: $e');
//     // Continue without Firebase for demo purposes
//   }
  
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
//         ChangeNotifierProvider(create: (_) => CourseProvider(CourseService(), DatabaseService())),
//       ],
//       child: MaterialApp(
//         title: 'Student Course Registration',
//         debugShowCheckedModeBanner: false,
//         theme: AppTheme.lightTheme,
//         darkTheme: AppTheme.darkTheme,
//         themeMode: ThemeMode.system,
//         home: SplashScreen(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:student_registration/firebase_options.dart';
import 'package:student_registration/services/auth_service.dart';
import 'package:student_registration/services/course_service.dart';
import 'package:student_registration/services/database_service.dart';
import 'package:student_registration/screens/splash_screen.dart';
import 'package:student_registration/providers/auth_provider.dart';
import 'package:student_registration/providers/course_provider.dart';
import 'package:student_registration/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

Future<void> main() async {
  // Ensure Flutter is initialized before using platform channels
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with improved error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
    // Consider showing a user-friendly error dialog here
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthService()),
        ),
        ChangeNotifierProvider(
          create: (_) => CourseProvider(CourseService(), DatabaseService()),
        ),
      ],
      child: MaterialApp(
        title: 'Student Course Registration',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: SplashScreen(),
      ),
    );
  }
}