import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;
  late DocumentSnapshot _userData;
  bool _isLoading = true;

  String _givenName = '';
  String _middleName = '';
  String _lastName = '';
  String _suffix = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
    _getUserProfileImage();
  }

  Future<void> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _user = user;
      final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        _userData = userData;
        _isLoading = false;
        _givenName = _userData['first_name'] ?? '';
        _middleName = _userData['middle_name'] ?? '';
        _lastName = _userData['last_name'] ?? '';
        _suffix = _userData['suffix'] ?? '';

      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          // Upload image to Firebase Storage
          final ref = FirebaseStorage.instance.ref().child('user_images/${user.uid}/profile.jpg');
          final uploadTask = ref.putFile(imageFile);
          await uploadTask.whenComplete(() => null);

          // Get the download URL
          final downloadURL = await ref.getDownloadURL();

          // Update user profile with the new photoURL
          await user.updateProfile(photoURL: downloadURL);
        } catch (e) {
          print('Error uploading image: $e');
        }
      }
    }
  }

  Future<String?> _getUserProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseStorage.instance.ref().child('user_images/${user.uid}/profile.jpg');
      return await ref.getDownloadURL();
    }
    return null;
  }

  Future<void> _updateUserData() async {
    final userData = FirebaseFirestore.instance.collection('users').doc(_user.uid);
    await userData.update({
      'first_name': _givenName,
      'middle_name': _middleName,
      'last_name': _lastName,
      'suffix': _suffix,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 75,),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _user.photoURL != null ? NetworkImage(_user.photoURL!) : null,
                          child: _user.photoURL == null ? Icon(Icons.person,                          size: 50, color: Colors.grey[900]) : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.grey[900]),
                            onPressed: _pickImage,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text((_userData['first_name'] ?? '') + ' ' + (_userData['middle_name'] ?? ' ' ) + ' ' + (_userData['last_name'] ?? '') + ' ' + (_userData['suffix'] ?? ''), style: TextStyle(
                      fontSize: 20
                    ),),
                    SizedBox(height: 20),
                    Text('Edit Personal Info', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[900]),),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _givenName,
                            decoration: InputDecoration(
                              labelText: 'Given Name',
                                labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                            ),
                            onChanged: (value) => setState(() => _givenName = value),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: _middleName,
                            decoration: InputDecoration(
                              labelText: 'Middle Name',
                                labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                            ),
                            onChanged: (value) => setState(() => _middleName = value),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _lastName,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                                labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                            ),
                            onChanged: (value) => setState(() => _lastName = value),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: _suffix,
                            decoration: InputDecoration(
                              labelText: 'Suffix',
                                labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                            ),
                            onChanged: (value) => setState(() => _suffix = value),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _updateUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                      ),
                      child: Text('Save Changes', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            /*Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.indigo[900],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircularProgressIndicator(
                      value: 0.5,
                      backgroundColor: Colors.white,
                      color: Colors.blue[400],
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Complete your profile',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Fill in 3 steps missing and complete your profile',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                      },
                      child: Text('Continue'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reward',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Level 2', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 4),
                            Text('120 points', style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Level 3', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 4),
                            Text('250 points', style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: 0.6,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue[400],
                    ),
                  ],
                ),
              ),
            ),*/
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 90 ,vertical: 30),
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed('/');
                },
                child: Text('Logout'),
                style: ElevatedButton.styleFrom(
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
