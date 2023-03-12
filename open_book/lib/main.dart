import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:open_book/screens/books_management/testFilePicker.dart';
import 'package:open_book/screens/books_management/testStyles.dart';
import 'package:open_book/screens/user_management_and_saved_books/LoginScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TestFilePicker(),
    );
  }
}
