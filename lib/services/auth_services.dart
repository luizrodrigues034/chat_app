import 'package:chat_app/pages/home.dart';
import 'package:chat_app/pages/onboarding.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:chat_app/services/shared_preferences_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn.instance;
  late GoogleSignInAccount _currentUser;
  bool _isGoogleSignInInitialized = false;

  getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

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

  Future<UserCredential> signInWithGoogleFirebase(BuildContext context) async {
    try {
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
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user != null) {
        String username = user.email!.replaceAll("@gmail.com", "");
        String firstLetter = username.substring(0, 1).toUpperCase();
        Map<String, dynamic> userInfoMap = {
          'name': user.displayName,
          'email': user.email,
          'photo': user.photoURL,
          'Id': user.uid,
          'username': username.toUpperCase(),
          'SearchKey': firstLetter,
        };
        print(userInfoMap['Id']);
        await SharedPreferencesServices.saveUserInfo(
          id: userInfoMap['Id'],
          name: userInfoMap['name'],
          email: userInfoMap['email'],
          image: userInfoMap['photo'],
          username: userInfoMap['username'],
        );
        await FirestoreServices.addUser(userInfoMap, userInfoMap['Id']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Voce esta logado!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }

      // 6. Atualiza estado local
      _currentUser = googleUser;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login Falhou')));
      return throw 'Erro na autenticao';
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      // Desconecta da conta do Google
      await _googleSignIn.signOut();

      // Desconecta do Firebase
      await _firebaseAuth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingPage()),
      );
      print('Usuário desconectado com sucesso');
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }

  Future<String> getUserId(BuildContext context) async {
    var id = await FirebaseAuth.instance.currentUser?.uid;
    if (id == null) {
      signOut(context);
      return throw 'Id do cliente nao encontrado';
    }
    return id;
  }

  signUpEmailPassword(
    String name,
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      Map<String, dynamic> userInfoMap = {
        'Id': user?.uid,
        'SearchKey': email[0],
        'name': name,
        'email': email,
        'photo':
            'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg',
        'username': email.split('@')[0],
      };
      await SharedPreferencesServices.saveUserInfo(
        id: userInfoMap['Id'],
        name: userInfoMap['name'],
        email: userInfoMap['email'],
        image: userInfoMap['photo'],
        username: userInfoMap['username'],
      );
      FirestoreServices.addUser(userInfoMap, userInfoMap['Id']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  signInEmailPassWord(String email, String password) {
    _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }
}
