import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_planner_app/screens/authentication/auth_service/auth_service.dart';
import 'package:travel_planner_app/screens/authentication/login/login_screen.dart';
import 'package:provider/provider.dart';

class TravelSignUpPage extends StatefulWidget {
  const TravelSignUpPage({super.key});

  @override
  State<TravelSignUpPage> createState() => _TravelSignUpPageState();
}

class _TravelSignUpPageState extends State<TravelSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool isLoading = false;

  void signupUser() async {
    setState(() => isLoading = true);

    String res = await AuthMethod().signupUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
    );

    setState(() => isLoading = false);

    if (res == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            "Signup Successfully. Please Login.",
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TravelLoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            res,
            style: const TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 245, 192),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.08),
        child: Center(
          child: Column(
            children: [
              Hero(
                tag: 'travel-icon',
                child: Icon(Icons.map,
                    size: screenWidth * 0.2, color: Color(0xFF4A5E00)),
              ),
              const SizedBox(height: 20),
              Text(
                'Create Your Travel Account',
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C7A00),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Name Field
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline),
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\s]'))
                          ],
                          validator: (value) =>
                              value!.isEmpty ? 'Enter your name' : null,
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined),
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your email';
                            }
                            final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+com$',
                              caseSensitive: false,
                            );
                            if (!emailRegex.hasMatch(value)) {
                              return 'Enter a valid email ending with .com';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () =>
                                  setState(() => _obscureText = !_obscureText),
                            ),
                          ),
                          validator: (value) => value!.length < 6
                              ? 'Password must be at least 6 characters'
                              : null,
                        ),
                        SizedBox(height: screenHeight * 0.04),

                        // Submit Button or Loader
                        isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.black12,
                              )
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      signupUser();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF6C7A00),
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.02),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.045,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                        SizedBox(height: screenHeight * 0.02),

                        // Login Redirect
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?",
                                style:
                                    TextStyle(fontSize: screenWidth * 0.038)),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            TravelLoginPage(),
                                    transitionDuration: Duration.zero,
                                  ),
                                );
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C7A00),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
