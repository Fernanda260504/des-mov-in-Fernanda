import 'package:firebase_auth/firebase_auth.dart';

String mapAuthErrorToMessage(Object e) {
  if (e is! FirebaseAuthException) return 'Ocurrió un error desconocido.';

  switch (e.code) {
    case 'invalid-email':
    case 'user-not-found':
    case 'wrong-password':
      return 'Correo o contraseña inválidos.'; // genérico para no revelar info
    case 'email-already-in-use':
      return 'Ya existe una cuenta con este correo.';
    case 'weak-password':
      return 'La contraseña es demasiado débil. Usa al menos 8 caracteres con mayúsculas y números.';
    case 'operation-not-allowed':
      return 'El registro con correo y contraseña no está habilitado en Firebase.';
    case 'user-disabled':
      return 'La cuenta está deshabilitada.';
    case 'too-many-requests':
      return 'Demasiados intentos. Intenta más tarde.';
    case 'network-request-failed':
      return 'Problema de red. Verifica tu conexión.';
    default:
      return 'No se pudo completar la operación. Intenta nuevamente.';
  }
}
