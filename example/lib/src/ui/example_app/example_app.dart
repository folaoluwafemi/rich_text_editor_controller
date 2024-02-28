import 'package:flutter/material.dart';
import 'package:rich_text_editor_controller_example/src/ui/home_page/home_page.dart';

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rich Text Editor Controller Demo',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepOrange,
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepOrange,
          onPrimary: Colors.white,
          onBackground: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}
