import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SupremeStreamApp());
}

class SupremeStreamApp extends StatelessWidget {
  const SupremeStreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supreme Steam Detail',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
