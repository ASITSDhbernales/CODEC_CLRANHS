import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'home_screen.dart';
import 'learn_screen.dart';
import 'login_signup_screen.dart';
import 'profile_screen.dart';
import 'review_screen.dart';
import 'topic_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  runApp(MyApp(initialRoute: user != null ? '/home' : '/'));
}


class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ICT App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => LoginSignupScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/learn': (context) => LearnScreen(),
        // '/splash': (context) => SplashPage(),
        // '/lessons': (context) => LessonsPage(),
        // '/search': (context) => SearchPage(),
        '/review': (context) => ReviewScreen(),
        // '/terms': (context) => TermsPage(),
        // '/profile': (context) => ProfilePage(),
        // '/settings': (context) => SettingsPage(),
      },
    );
  }
}
