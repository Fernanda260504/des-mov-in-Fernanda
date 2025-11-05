import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'validators.dart';
import 'auth_errors.dart';
import 'registre_page.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  // 🔹 Método para iniciar sesión
  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      // authStateChanges() del AuthGate redirige automáticamente al Home
    } catch (e) {
      setState(() => _error = mapAuthErrorToMessage(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // 🔹 Método para restablecer contraseña
  Future<void> _resetPassword() async {
    final emailError = Validators.email(_emailCtrl.text);
    if (emailError != null) {
      setState(() => _error = 'Ingresa un correo válido para recuperar.');
      return;
    }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailCtrl.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Revisa tu correo para restablecer.')),
      );
    } catch (e) {
      setState(() => _error = mapAuthErrorToMessage(e));
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
               
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Correo',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 12),

               
                  TextFormField(
                    controller: _passwordCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 12),

                
                  if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 12),

                
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _signIn,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Entrar'),
                    ),
                  ),

                  
                  TextButton(
                    onPressed: _loading ? null : _resetPassword,
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),

                  
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const RegisterPage()),
                            );
                          },
                    child: const Text('¿No tienes cuenta? Regístrate'),
                  ),

                  const SizedBox(height: 8),
                  const _SmallPrint(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _SmallPrint extends StatelessWidget {
  const _SmallPrint();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Nota: No mostramos si el usuario existe o no. '
      'Siempre usamos mensajes genéricos para proteger la privacidad.',
      style: TextStyle(fontSize: 12, color: Colors.black54),
      textAlign: TextAlign.center,
    );
  }
}
