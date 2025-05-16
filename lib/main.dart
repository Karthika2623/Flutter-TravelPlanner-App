// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travel_planner_app/firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}
