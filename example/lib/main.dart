import 'package:example/demo.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

///Main material app of the app
class MyApp extends StatelessWidget {
  ///initialize the material app
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: const MaterialColor(0xFF091D36, <int, Color>{
            50: Color(0xFFE1E4E7),
            100: Color(0xFFB5BBC3),
            200: Color(0xFF848E9B),
            300: Color(0xFF536172),
            400: Color(0xFF2E3F54),
            500: Color(0xff091D36),
            600: Color(0xFF081A30),
            700: Color(0xFF061529),
            800: Color(0xFF051122),
            900: Color(0xFF020A16),
          }),
        ),
        home: const MyHomePage(title: 'Ripple animation demo'),
      );
}
