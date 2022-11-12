import 'package:flutter/material.dart';
import 'package:rick_morty_find_person_freezed/presentation/pages/my_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(title: 'freezed',),
    );
  }
}