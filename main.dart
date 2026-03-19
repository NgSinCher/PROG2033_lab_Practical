import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart'; 
import 'screens/home_screen.dart'; 

void main() async {
 
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
   
    print("Firebase initialization error: $e");
    print("Running in demo mode with fallback data.");
  }

  runApp(const EventPlannerApp());
}

class EventPlannerApp extends StatelessWidget {
  const EventPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Event Planner',
     
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
       
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
       
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
     
      home: const HomeScreen(), 
    );
  }
}
