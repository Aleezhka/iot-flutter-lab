import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:workshop_app/data/repositories/secure_storage_repository.dart';
import 'package:workshop_app/domain/providers/connectivity_provider.dart';
import 'package:workshop_app/domain/providers/mqtt_provider.dart';
import 'package:workshop_app/firebase_options.dart';
import 'package:workshop_app/screens/home_screen.dart';
import 'package:workshop_app/screens/login_screen.dart';
import 'package:workshop_app/screens/profile_screen.dart';
import 'package:workshop_app/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ініціалізація Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const storage = FlutterSecureStorage();
  const repo = SecureStorageRepo(storage: storage);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => MqttProvider()),
      ],
      child: const WorkshopApp(storage: repo),
    ),
  );
}

class WorkshopApp extends StatelessWidget {
  const WorkshopApp({required this.storage, super.key});
  final SecureStorageRepo storage;

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
