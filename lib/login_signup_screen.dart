import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _suffixController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _suffixController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred.';

      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        case 'user-disabled':
          message = 'User disabled.';
          break;
        case 'too-many-requests':
          message = 'Too many requests. Try again later.';
          break;
        case 'operation-not-allowed':
          message = 'Operation not allowed.';
          break;
      // Add more cases for other error codes as needed
        default:
          message = 'An unexpected error occurred.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  Future<void> _signup() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'first_name': _firstNameController.text,
        'middle_name': _middleNameController.text,
        'last_name': _lastNameController.text,
        'suffix': _suffixController.text,
        'email': _emailController.text,
        'c_progress': 0,
        'java_progress': 0,
      });

      final lessonData = {
        'isCompleted': false,
        'status': 'locked'
      };

      final lessonIds = ['c_lesson_1','c_lesson_2','c_lesson_3','c_lesson_4','c_lesson_5','c_lesson_6','c_lesson_7','c_lesson_8','c_lesson_9','c_lesson_10',];

      for (final lessonId in lessonIds) {
        final updatedLessonData = {...lessonData}; // Create a copy of lessonData

        if (lessonId == 'c_lesson_1') {
          updatedLessonData['status'] = 'unlocked';
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .collection('C#')
            .doc(lessonId)
            .set(updatedLessonData);
      }

      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred.';

      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        case 'user-disabled':
          message = 'User disabled.';
          break;
        case 'too-many-requests':
          message = 'Too many requests. Try again later.';
          break;
        case 'operation-not-allowed':
          message = 'Operation not allowed.';
          break;
      // Add more cases for other error codes as needed
        default:
          message = 'An unexpected error occurred.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30,),
            Container(
              height: 125,
              child: Center(
                child: Image.asset(
                  "assets/bbb.png"!,
                ),
              ),
            ),
            Text(
              'Bit Byte Bit',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.indigo[900],
                  borderRadius: BorderRadius.circular(50),
                ),
                unselectedLabelColor: Colors.white,
                labelColor: Colors.white,
                tabs: [
                  Tab(text: 'Login'),
                  Tab(text: 'Sign up'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLoginForm(),
                  _buildSignupForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Email Address',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white70,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Password',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white70,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            obscureText: true,
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _login,
            child: Text('Login'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              childAspectRatio: (1 / 0.6),
              mainAxisSpacing: 0,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildTextField('First Name', _firstNameController),
                _buildTextField('Middle Name', _middleNameController),
                _buildTextField('Last Name', _lastNameController),
                _buildTextField('Name Suffix (if any)', _suffixController),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email Address',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Password',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              obscureText: true,
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signup,
              child: Text('Sign up'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white70,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
