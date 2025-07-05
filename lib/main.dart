// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/form_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ScoreCardApp());
}

class ScoreCardApp extends StatelessWidget {
  const ScoreCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FormProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CTS Score Card',
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
