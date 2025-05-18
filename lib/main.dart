import 'package:build_with_ai_2025/firebase_options.dart';
import 'package:build_with_ai_2025/presentation/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with the default options
  // This is required for Firebase services to work properly
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Build with AI-025',
      routes: {'/': (context) => const HomeScreen()},
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
