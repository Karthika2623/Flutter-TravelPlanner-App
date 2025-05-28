import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner_app/screens/authentication/login/login_screen.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;
  var newPassword = "";
  final newPasswordController = TextEditingController();
  bool _obscureText = true;
  @override
  void dispose() {
    newPasswordController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  changePassword() async {
    try {
      await currentUser!.updatePassword(newPassword);
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TravelLoginPage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          content: Text(
            'Your Password has been Changed. Login again !',
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
    } catch (e) {
      debugPrint('e:${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.black, size: width * 0.06),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Change Password",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: width * 0.045,
          ),
        ),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: height * 0.05,
            horizontal: width * 0.08,
          ),
          child: Column(
            children: [
              TextFormField(
                controller: newPasswordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock,
                    color: const Color.fromARGB(255, 92, 112, 11),
                    size: width * 0.06,
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(fontSize: width * 0.04),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.03),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: const Color.fromARGB(255, 61, 75, 6),
                      size: width * 0.06,
                    ),
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter password' : null,
              ),
              SizedBox(height: height * 0.06),
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
                              newPassword = newPasswordController.text;
                            });
                            changePassword();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C7A00),
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.018),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(width * 0.025),
                          ),
                        ),
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: width * 0.045,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
