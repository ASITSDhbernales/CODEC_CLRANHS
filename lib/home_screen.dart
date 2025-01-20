import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'learn_screen.dart';
import 'profile_screen.dart';
import 'review_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    LearnScreen(),
    ReviewScreen(),
    /*SearchScreen(),*/
    ProfileScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.blue[900],
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        type: BottomNavigationBarType.fixed,
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            label: 'Review',
          ),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
