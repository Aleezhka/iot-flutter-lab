import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop_app/data/repositories/shared_prefs_repository.dart';
import 'package:workshop_app/data/repositories/storage_interface.dart';
import 'package:workshop_app/screens/home_screen.dart';
import 'package:workshop_app/screens/login_screen.dart';
import 'package:workshop_app/screens/profile_screen.dart';
import 'package:workshop_app/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storage = SharedPrefsRepository(prefs: prefs);

  runApp(WorkshopApp(storage: storage));
}

class WorkshopApp extends StatelessWidget {
  const WorkshopApp({required this.storage, super.key});
  final IStorageRepository storage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workshop Sentinel',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFFFFB347),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(storage: storage),
        '/register': (context) => RegisterScreen(storage: storage),
        '/home': (context) => HomeScreen(storage: storage),
        '/profile': (context) => ProfileScreen(storage: storage),
      },
    );
  }
}
