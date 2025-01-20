import 'models.dart';

// Define the content for Java lessons
final Lesson java_lesson_1 = Lesson(
  id: 'java_lesson_1',
  title: 'Java Lesson 1',
  isCompleted: false,
  isOngoing: false,
  topics: [
    Topic(
      id: 'java_topic_1',
      title: 'Introduction to Java',
        content: ''
    ),
    Topic(
      id: 'java_topic_2',
      title: 'Basic Syntax',
        content: ''
    ),
  ],
  quizzes: [
    Quiz(
      id: 'java_quiz_1',
      question: 'What is the basic syntax for a Java program?',
      options: ['System.out.println("Hello, World!");', 'print("Hello, World!");', 'echo "Hello, World!";'],
      correctOptionIndex: 0,
    ),
  ],
  status: LessonStatus.unlocked, // Set status to unlocked
);

final Lesson java_lesson_2 = Lesson(
  id: 'java_lesson_2',
  title: 'Java Lesson 2',
  isCompleted: false,
  isOngoing: false,
  topics: [
    Topic(
      id: 'java_topic_3',
      title: 'Variables and Data Types',
        content: ''
    ),
    Topic(
      id: 'java_topic_4',
      title: 'Control Flow',
        content: ''
    ),
  ],
  quizzes: [
    Quiz(
      id: 'java_quiz_2',
      question: 'Which of the following is a valid data type in Java?',
      options: ['int', 'number', 'text'],
      correctOptionIndex: 0,
    ),
  ],
  status: LessonStatus.locked, // Set status to locked
);
