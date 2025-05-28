import 'package:flutter/material.dart';
import 'package:unolist/ui/pages/home_page.dart';

void main() {
  runApp(const UnoListApp());
}

class UnoListApp extends StatelessWidget {
  const UnoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnoList',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: const HomePage(), //<-- The name 'HomePage' isn't a class.
    );
  }
}
