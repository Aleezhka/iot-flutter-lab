import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // ДОДАНО ІМПОРТ BLOC
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:workshop_app/data/repositories/api_storage_repository.dart';
import 'package:workshop_app/data/repositories/secure_storage_repository.dart';
import 'package:workshop_app/data/repositories/storage_interface.dart';
import 'package:workshop_app/domain/cubits/auth_cubit.dart';
import 'package:workshop_app/domain/cubits/machine_cubit.dart';
import 'package:workshop_app/domain/cubits/profile_cubit.dart';
import 'package:workshop_app/domain/providers/connectivity_provider.dart';
import 'package:workshop_app/domain/providers/mqtt_provider.dart';
import 'package:workshop_app/firebase_options.dart';
import 'package:workshop_app/screens/home_screen.dart';
import 'package:workshop_app/screens/login_screen.dart';
import 'package:workshop_app/screens/profile_screen.dart';
import 'package:workshop_app/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const secureStorage = FlutterSecureStorage();
  const localRepo = SecureStorageRepo(storage: secureStorage);

  final dio = Dio();
  final apiRepo = ApiStorageRepo(localRepo: localRepo, dio: dio);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => MqttProvider()),
        Provider<IStorageRepository>.value(value: apiRepo),
        BlocProvider(
          create: (ctx) => MachineCubit(ctx.read<IStorageRepository>()),
        ),
        BlocProvider(
          create: (ctx) => ProfileCubit(ctx.read<IStorageRepository>()),
        ),
        BlocProvider(
          create: (ctx) => AuthCubit(ctx.read<IStorageRepository>()),
        ),
      ],
      child: const WorkshopApp(),
    ),
  );
}

class WorkshopApp extends StatelessWidget {
  const WorkshopApp({super.key});

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
        '/login': (context) =>
            LoginScreen(storage: context.read<IStorageRepository>()),
        '/register': (context) =>
            RegisterScreen(storage: context.read<IStorageRepository>()),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
