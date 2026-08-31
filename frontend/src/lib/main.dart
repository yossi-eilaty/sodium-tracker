import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/portion_provider.dart';
import 'providers/intake_provider.dart';
import 'login_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PortionProvider()..loadPortions()),
        ChangeNotifierProvider(create: (_) => IntakeProvider()..loadEntries()),
      ],
      child: const SodiumTrackerApp(),
    ),
  );
}

class SodiumTrackerApp extends StatelessWidget {
  const SodiumTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sodium Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/home': (_) => HomeScreen(),
      },
    );
  }
}