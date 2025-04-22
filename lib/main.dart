import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todolist/app/theme.dart';
import 'package:todolist/auth/auth_gate.dart';
import 'package:todolist/pages/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      // theme: AppTheme.light,
      // darkTheme: AppTheme.dark,
      // themeMode: ThemeMode.system,
      home: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: const AuthGate(),
          ),
        ),
      ),
    );
  }
}
