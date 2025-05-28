import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner_app/screens/authentication/login/login_screen.dart';
import 'package:travel_planner_app/screens/authentication/signup/signup_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool isloading = false;
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Password Reset Email has been sent !',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            content: Text(
              'No user found for that email.',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: screenWidth * 0.06),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Reset Your Password",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: screenHeight * 0.02),
            child: Text(
              'Reset Link will be sent to your email id!',
              style: TextStyle(fontSize: screenWidth * 0.045),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.03,
                  horizontal: screenWidth * 0.07,
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 99, 122, 5),
                          size: screenWidth * 0.06,
                        ),
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: screenWidth * 0.04),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Email';
                        } else if (!value.contains('@')) {
                          return 'Please Enter Valid Email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TravelLoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Login!',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    isloading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black12,
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _emailController.text;
                                  });
                                  resetPassword();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF6C7A00),
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Send Email',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an Account? ",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: screenWidth * 0.042,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, a, b) =>
                                    const TravelSignUpPage(),
                                transitionDuration: Duration.zero,
                              ),
                              (route) => false,
                            );
                          },
                          child: Text(
                            'Signup',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: screenWidth * 0.042,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
