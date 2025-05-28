import 'package:flutter/material.dart';
import 'package:travel_planner_app/screens/authentication/auth_service/auth_service.dart';
import 'package:travel_planner_app/screens/authentication/forgotpassword/forgot_password.dart';
import 'package:travel_planner_app/screens/authentication/signup/signup_screen.dart';
import 'package:travel_planner_app/screens/tour_planner_screen.dart';
import 'package:provider/provider.dart';

class TravelLoginPage extends StatefulWidget {
  const TravelLoginPage({super.key});

  @override
  State<TravelLoginPage> createState() => _TravelLoginPageState();
}

class _TravelLoginPageState extends State<TravelLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool isLoading = false;

  void loginUser() async {
    setState(() => isLoading = true);

    String res = await AuthMethod().loginUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (res == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TourPlannerScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            res, // Show the actual error message here
            style: const TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 233, 183),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.08),
              // Logo and Title
              Column(
                children: [
                  Icon(Icons.flight_takeoff,
                      size: screenWidth * 0.18,
                      color: const Color.fromARGB(255, 55, 66, 9)),
                  const SizedBox(height: 12),
                  Text(
                    'Travel Planner',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 122, 146, 36),
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Plan. Pack. Go!',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: const Color.fromARGB(255, 102, 121, 28),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.05),

              // Login Form
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.06),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email,
                              color: Color.fromARGB(255, 169, 197, 57)),
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        keyboardType: TextInputType.emailAddress,
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

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock,
                              color: Color.fromARGB(255, 169, 197, 57)),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color.fromARGB(255, 61, 75, 6),
                            ),
                            onPressed: () =>
                                setState(() => _obscureText = !_obscureText),
                          ),
                        ),
                        validator: (value) => value!.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ForgotPassword()),
                            );
                          },
                          child: const Text('Forgot Password?',
                              style: TextStyle(color: Colors.black87)),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      // Login Button or Loader
                      isLoading
                          ? CircularProgressIndicator(color: Colors.black12)
                          : SizedBox(
                              width: double.infinity,
                              height: screenHeight * 0.05,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    loginUser();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 119, 136, 57),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),

                      SizedBox(height: screenHeight * 0.02),

                      // Signup Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?",
                              style: TextStyle(fontSize: 15)),
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, a, b) =>
                                      const TravelSignUpPage(),
                                  transitionDuration:
                                      const Duration(milliseconds: 300),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6C7A00),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.08),
            ],
          ),
        ),
      ),
    );
  }
}
