import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner_app/screens/authentication/passwordchange/change_password.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser!.email;
  final creationTime = FirebaseAuth.instance.currentUser!.metadata.creationTime;

  User? user = FirebaseAuth.instance.currentUser;

  verifyEmail() async {
    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      debugPrint('Verification Email has been sent');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          content: Text(
            'Verification Email has been sent',
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade200,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Email: ',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    '$email',
                    style: const TextStyle(fontSize: 18.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                user!.emailVerified
                    ? const Text(
                  'Verified',
                  style: TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                )
                    : TextButton(
                  onPressed: verifyEmail,
                  child: const Text('Verify Email'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                //  Navigator.push(context,MaterialPageRoute(builder: (context) => ChangePassword(),));
                },
                icon: const Icon(Icons.edit, size: 20),
                label: const Text('Change Password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  textStyle: const TextStyle(fontSize: 18.0,color: Colors.blue),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
