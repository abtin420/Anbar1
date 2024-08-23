import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'login.dart'; // Import the login page

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late Database _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'users.db');
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, email TEXT, password TEXT)',
          );
        },
      );
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  Future<void> _saveUserData() async {
    try {
      await _database.insert(
        'users',
        {
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('User data saved');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color.fromARGB(255, 25, 196, 181),
      ),
      body: Container(
        color: const Color.fromARGB(255, 25, 196, 181),
        child: Stack(
          children: <Widget>[
            //  باکس سفید پایین
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 500,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            //نوشتن در بادی بالا
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Text(
                  'Continue ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      color: Color.fromARGB(255, 90, 41, 228)),
                ),
              ),
            ),
            //ایجاد چندین باکس برای ثبت نام
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    child: SizedBox(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(50)),
                          color: Colors.blue,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 200,
                          maxWidth: 300,
                        ),
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: 200, //فاصله دادن بین دو ویجت
                      height: 20),
                  Align(
                    child: SizedBox(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(50)),
                          color: Colors.blue,
                        ),
                        constraints: BoxConstraints(
                          //تنظیم عرض وطول باکس
                          minWidth: 200,
                          maxWidth: 300,
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: 200, //فاصله دادن بین دو ویجت
                      height: 20),
                  Align(
                    child: SizedBox(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(50)),
                          color: Colors.blue,
                        ),
                        constraints: BoxConstraints(
                          //تنظیم عرض وطول باکس
                          minWidth: 200,
                          maxWidth: 300,
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200, //فاصله دادن بین دو ویجت
                    height: 20,
                  ),
                  Align(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _saveUserData();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          }
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
