import 'package:todolist/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:todolist/pages/dashboard_screen.dart';
import '../pages/register_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // get auth service
  final authService = AuthService();

  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // login button pressed
  bool _isLoading = false;

  void login() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await authService.signInWithEmailPassword(email, password);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 50),
          children: [
            // email
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            // password
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _isLoading ? null : login,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Login"),
            ),

            const SizedBox(height: 12),

            // go to register page to sign up
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterPage(),
                  )),
              child:
                  const Center(child: Text("Don't have an account? Sign up")),
            ),
          ],
        )
      );
  }
}
