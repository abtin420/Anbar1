import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'register.dart'; // Import the register page
import 'home.dart'; // Import the home page
import 'package:shared_preferences/shared_preferences.dart'; // Import shared preferences

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  bool _rememberMe = false;

  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  late Database _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _loadRememberMe();
  }

  Future<void> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'users.db');
    _database = await openDatabase(
      path,
      version: 1,
    );
  }

  void _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _username = prefs.getString('username') ?? '';
        _password = prefs.getString('password') ?? '';
      }
    });
  }

  Future<bool> _validateUser() async {
    final username = _username;
    final password = _password;
    final List<Map<String, dynamic>> maps = await _database.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return maps.isNotEmpty;
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool isValidUser = await _validateUser();

      if (isValidUser) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('rememberMe', _rememberMe);
        if (_rememberMe) {
          await prefs.setString('username', _username);
          await prefs.setString('password', _password);
        } else {
          await prefs.remove('username');
          await prefs.remove('password');
        }

        // Navigate to the home page
        Navigator.pushReplacement(
          context as BuildContext,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Show an error message
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(
            content: Text('Invalid username or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/anbar.png'),
            fit: BoxFit.cover,
          ),
        ),
        // Login form
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomPaint(
                painter: ArrowShapePainter(),
                child: Container(
                  width: 150,
                  height: 70,
                  child: Center(
                    child: Text(
                      'anbar',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Card(
                color: const Color.fromARGB(255, 11, 243, 220),
                margin: EdgeInsets.only(
                  left: 30.0,
                  right: 30.0,
                  top: 480.0,
                ),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _username,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Enter your username',
                        hintStyle: TextStyle(color: Colors.black),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                      ),
                      cursorColor: Colors.blue,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                    ),
                    SizedBox(
                        // child:widget ,
                        // height: 20.0,
                        width: 10.0),
                  ],
                ),
              ),
              //
              Card(
                color: Colors.white,
                margin: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 10.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _password,
                      obscureText: _isObscure, // Use the _isObscure variable
                      cursorColor: Colors.red,
                      decoration: InputDecoration(
                        labelText: 'password',
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Colors.black),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure; // Toggle the visibility
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(bottom: 20.0, right: 20.0, left: 80.0),
                    decoration: BoxDecoration(
                        backgroundBlendMode: BlendMode.modulate,
                        color: const Color.fromARGB(255, 22, 8, 218)),
                    constraints:
                        BoxConstraints(minHeight: 1.0, maxHeight: 50.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                        ),
                        SizedBox(
                            width:
                                10.0), // Add space between checkbox and divider
                        Divider(
                          color: Colors.white,
                          height: 20.0,
                          thickness: 1.0,
                          indent: 10.0,
                          endIndent: 10.0,
                        ),
                        SizedBox(
                            width:
                                10.0), // Add space between divider and login button
                        IconButton(
                          onPressed: _login,
                          icon: Text(
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              'Log in'),
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(bottom: 20.0, left: 20.0, right: 80.0),
                    decoration: BoxDecoration(
                        backgroundBlendMode: BlendMode.modulate,
                        color: const Color.fromARGB(255, 22, 8, 218)),
                    constraints:
                        BoxConstraints(minHeight: 1.0, maxHeight: 50.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      icon: Text(
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          'Sign up'),
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArrowShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - 20,
          0) // Adjust the x-coordinate to make the rectangle shorter
      ..lineTo(
          size.width, size.height / 2) // Draw the arrow from the right side
      ..lineTo(size.width - 20,
          size.height) // Adjust the x-coordinate to make the rectangle shorter
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
