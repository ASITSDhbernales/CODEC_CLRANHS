import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'c_content.dart';
import 'java_content.dart';
import 'models.dart';
import 'topic_screen.dart';

class LearnScreen extends StatefulWidget {
  @override
  _LearnScreenState createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String selectedCategory = 'C#';
  List<String> categories = ['C#', 'Java'];
  Map<String, List<Lesson>> lessons = {
    'C#': [],
    'Java': [],
  };

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      lessons['C#'] = [c_lesson_1,c_lesson_2,c_lesson_3,c_lesson_4,c_lesson_5,c_lesson_6,c_lesson_7,c_lesson_8,c_lesson_9,c_lesson_10,];

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('C#') // Replace with the desired category
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String lessonId = doc.id;

          Lesson? lessonToUpdate = lessons['C#']?.firstWhere((lesson) => lesson.id == lessonId);
          if (lessonToUpdate != null) {
            if (data['status'] == "completed") {
              lessonToUpdate.status = LessonStatus.completed;
            }
            else if (data['status'] == "unlocked") {
              lessonToUpdate.status = LessonStatus.unlocked;
            }
            else if (data['status'] == "locked") {
              lessonToUpdate.status = LessonStatus.locked;
            }
            lessonToUpdate.isCompleted = data['isCompleted'] ?? false;
            lessonToUpdate.isOngoing = data['isOngoing'] ?? false;
          }
        }
      }
    }
    setState(() {});
  }


  void _completeLesson(Lesson completedLesson) {
    int index = lessons[selectedCategory]!.indexOf(completedLesson);
    Lesson nextLesson = lessons[selectedCategory]![index+1];

    setState(() {
      lessons[selectedCategory]![index].isCompleted = true;
      // Update status of the next lesson if necessary
      if (index + 1 < lessons[selectedCategory]!.length) {
        completedLesson.isCompleted = true;
        completedLesson.status = LessonStatus.completed;
        if (nextLesson.isCompleted == false) {
          nextLesson.status = LessonStatus.unlocked;
        }
      }
    });

    // Save progress to Firestore
    _saveLessonProgress(completedLesson, nextLesson);
  }

  Future<void> _saveLessonProgress(Lesson completedLesson, Lesson nextLesson) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection(selectedCategory)
          .doc(completedLesson.id)
          .set({
        'isCompleted': true,
        'status': 'completed'
      });
      if (nextLesson.isCompleted == false){
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection(selectedCategory)
            .doc(nextLesson.id)
            .set({
          'status': 'unlocked'
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Lesson> currentLessons = lessons[selectedCategory] ?? [];
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 75),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedCategory,
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: Colors.blue[900],
              style: TextStyle(color: Colors.white, fontSize: 24),
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(
                    child: Text(value),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: currentLessons.map((lesson) {
                  return GestureDetector(
                    onTap: lesson.status == LessonStatus.locked ? null : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopicScreen(
                            lesson: lesson,
                            onLessonComplete: () {
                              _completeLesson(lesson);
                            },
                          ),
                        ),
                      );
                    },
                    // In the GridView builder
                    child: Card(
                      color: lesson.status == LessonStatus.locked ? Colors.grey : Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                lesson.title,
                                style: TextStyle(color: Colors.black,  fontSize: 12, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),),
                            Icon(
                              lesson.status == LessonStatus.completed ? Icons.check_circle : lesson.status == LessonStatus.locked ? Icons.lock : Icons.play_arrow,
                              color: Colors.blue[800],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
