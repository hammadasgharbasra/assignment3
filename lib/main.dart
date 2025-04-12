import 'package:flutter/material.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(RememberLocationApp());
}

class RememberLocationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remember the Location',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: RegisterScreen(),
    );
  }
}