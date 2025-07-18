import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:daily_english/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mgpbuusgwskuaupmlwez.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ncGJ1dXNnd3NrdWF1cG1sd2V6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI3NjkwMTIsImV4cCI6MjA2ODM0NTAxMn0.rT7dg6dJSzi_t5qOK0y64nAiyWMTJzK4YSW_0UJE6CA',
  );

  // التحقق من اتصال Supabase
  try {
    final response = await Supabase.instance.client.from('lessons').select().count();
    print('Supabase connection check: ${response.count} lessons exist');
  } catch (e) {
    print('Supabase connection error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'English Lessons App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),),
      home: const SplashScreen(),
    );
  }
}