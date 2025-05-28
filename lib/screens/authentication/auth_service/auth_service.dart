import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        return "Please enter all the fields";
      }

      if (password.length < 6) {
        return "Password must be at least 6 characters";
      }

      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection("users").doc(cred.user!.uid).set({
        'name': name,
        'uid': cred.user!.uid,
        'email': email,
      });

      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "Email is already registered";
      } else if (e.code == 'invalid-email') {
        return "Invalid email address";
      } else if (e.code == 'weak-password') {
        return "Password is too weak";
      } else {
        return e.message ?? "An error occurred";
      }
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return "Please enter all the fields";
      }

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        return "Incorrect password.";
      } else if (e.code == 'invalid-email') {
        return "Invalid email address.";
      } else {
        return e.message ?? "An error occurred";
      }
    } catch (err) {
      return err.toString();
    }
  }
}
