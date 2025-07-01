import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn.instance;
  late GoogleSignInAccount _currentUser;
  bool _isGoogleSignInInitialized = false;

  AuthService() {
    _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize();
      _isGoogleSignInInitialized = true;
    } catch (e) {
      print('Failed to initialize Google Sign-In: $e');
    }
  }

  /// Always check Google sign in initialization before use
  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await _initializeGoogleSignIn();
    }
  }

  Future<UserCredential> signInWithGoogleFirebase() async {
    await _ensureGoogleSignInInitialized();

    // 1. Autenticação com Google
    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
      scopeHint: ['email'],
    );

    // 2. (Opcional) Autorização para escopos extras
    final authClient = _googleSignIn.authorizationClient;
    final authorization = await authClient.authorizationForScopes(['email']);

    // 3. Recupera idToken do Google (necessário para Firebase)
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // 4. Cria a credencial Firebase
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      // Removido: googleAuth.accessToken (não existe mais)
      accessToken: authorization?.accessToken, // opcional, seguro manter
    );

    // 5. Faz login com Firebase
    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    // 6. Atualiza estado local
    _currentUser = googleUser;

    return userCredential;
  }
}
