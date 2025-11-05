import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'validators.dart';
import 'auth_errors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final email = _emailCtrl.text.trim();
      final password = _pwdCtrl.text;

      // 🔹 Crear usuario en Firebase Authentication
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 🔹 Enviar verificación de correo
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Se envió un correo de verificación.'),
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _error = mapAuthErrorToMessage(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _confirmValidator(String? v) {
    final conf = v ?? '';
    if (conf.isEmpty) return 'Confirma tu contraseña';
    if (conf != _pwdCtrl.text) return 'Las contraseñas no coinciden';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
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
                  // 🔸 Correo
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

                  // 🔸 Contraseña
                  TextFormField(
                    controller: _pwdCtrl,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () =>
                            setState(() => _obscure = !_obscure),
                      ),
                    ),
                    obscureText: _obscure,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 12),

                  // 🔸 Confirmar contraseña
                  TextFormField(
                    controller: _confirmCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar contraseña',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: _confirmValidator,
                  ),
                  const SizedBox(height: 12),

                  // 🔸 Mostrar error
                  if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 12),

                  // 🔸 Botón crear cuenta
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _register,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Crear cuenta'),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 🔸 Volver al login
                  TextButton(
                    onPressed:
                        _loading ? null : () => Navigator.of(context).pop(),
                    child:
                        const Text('¿Ya tienes cuenta? Inicia sesión'),
                  ),
                  const SizedBox(height: 8),
                  const _SecurityNotes(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecurityNotes extends StatelessWidget {
  const _SecurityNotes();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'La cuenta se crea en Firebase Authentication.\n'
      'Se envía verificación de correo.\n'
      'No se guardan contraseñas localmente.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 12, color: Colors.black54),
    );
  }
}
