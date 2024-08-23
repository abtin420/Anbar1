import 'package:anbar/models/note.dart';
import 'package:flutter/material.dart';
import 'package:anbar/pages/login.dart'; // Import the login page
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.initFlutter();
  Hive.openBox<Note>('notes');
  Hive.registerAdapter(NoteAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'anbar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Use the imported LoginPage
    );
  }
}
