import 'dart:convert';
import 'package:faculty_app/config.dart';
import 'package:faculty_app/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    Map<String, dynamic>? userDetails = await getUserDetails();

    if (isLoggedIn) {
      // Navigate to Home Page if user is logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                username:
                    userDetails != null ? userDetails['username'] : null)),
      );
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.setBool('isLoggedIn', false);

    // Navigate back to login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  final TextEditingController ipController = TextEditingController();
  String message = "";

  final RegExp ipRegex =
      RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$'); // IPv4 validation regex

  void verifyIP() async {
    String ip = ipController.text.trim();
    if (!ipRegex.hasMatch(ip)) {
      setState(() {
        message = "❌ Invalid IPv4 address!";
      });
      return;
    }

    bool success = await repository.pingServer(ip);
    setState(() {
      if (success) {
        config.setBaseURL("http://$ip:5001");
        message = "✅ Server connected successfully!";
      } else {
        message = "❌ Server not found / not running!";
      }
    });
  }

  Future<Map<String, dynamic>?> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      return jsonDecode(userData);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/cover.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Center(
                    child: Image.asset(
                      'assets/logo.jpeg',
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Username field
                  const Text(
                    'Username',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'Enter your username',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password field
                  const Text(
                    'Password',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'Enter your password',
                    ),
                  ),

                  // Show password toggle
                  Row(
                    children: [
                      Checkbox(
                        value: showPassword,
                        onChanged: (value) {
                          setState(() {
                            showPassword = value!;
                          });
                        },
                      ),
                      const Text(
                        "Show Password",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Login and Register buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          repository.validateLogin(context,
                              usernameController.text, passwordController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final TextEditingController
                                  regUsernameController =
                                  TextEditingController();
                              final TextEditingController
                                  regPasswordController =
                                  TextEditingController();
                              // final TextEditingController regEmailController =
                              //     TextEditingController();

                              return AlertDialog(
                                title: const Text('Register'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: regUsernameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Username',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    TextField(
                                      controller: regPasswordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Password',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // TextField(
                                    //   controller: regEmailController,
                                    //   decoration: const InputDecoration(
                                    //     labelText: 'Email',
                                    //     border: OutlineInputBorder(),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final regUsername =
                                          regUsernameController.text;
                                      final regPassword =
                                          regPasswordController.text;

                                      if (regUsername.isEmpty ||
                                          regPassword.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'All fields are required.')),
                                        );
                                        return;
                                      }

                                      // Call the function to register the user
                                      await repository.registerUser(
                                          context, regUsername, regPassword);
                                    },
                                    child: const Text('Register'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Register",
                          style: TextStyle(fontSize: 16),
                        ),
                        
                      ),
                    ],
                  ),
                   const SizedBox(
                    height: 20,
                  ),
                  const Text('Server IP Address',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: ipController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'Enter server IP',
                    ),
                  ),
                  if (message.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              message.contains("✅") ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: verifyIP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Verify'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
