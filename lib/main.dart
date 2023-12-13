import 'package:firebase/firebase_options.dart';
import 'package:firebase/playerController.dart';
import 'package:firebase/screens/firebaseSongs.dart';
import 'package:firebase/screens/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Young',
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true),
      ),
      debugShowCheckedModeBanner: false,
      home: const FirebaseSongs(),
    );
  }
}
