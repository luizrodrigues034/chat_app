import 'package:chat_app/services/auth_services.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Aqui você pode integrar com Firebase ou seu backend
    AuthService().signUpEmailPassword(name, email, password, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Criar conta',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Cadastrar'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Volta para a tela de login
                },
                child: const Text('Já tem uma conta? Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
