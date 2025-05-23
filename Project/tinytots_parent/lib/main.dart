import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tinytots_parent/firebase_options.dart';
import 'package:tinytots_parent/screen/intro.dart';


Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await DefaultFirebaseOptions.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://dusxeazevqhptwodxcvk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR1c3hlYXpldnFocHR3b2R4Y3ZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQzNDY2NjcsImV4cCI6MjA0OTkyMjY2N30.0ely6domWJ9JwKwPeLL2pp8LqQeA--6n-gEG9e8Uh40',
  );
  runApp(const MainApp());
}

final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Intro()
    );
  }
}
