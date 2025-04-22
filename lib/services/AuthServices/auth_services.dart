import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Função de Sign-in com o Google
  static Future<void> handleGoogleSignIn(BuildContext context) async {
    try {
      // Iniciar o fluxo de login com o Google
      GoogleSignInAccount? user = await _googleSignIn.signIn();
      if (user != null) {
        // Obtenha o GoogleSignInAuthentication para pegar o ID token
        final GoogleSignInAuthentication googleAuth = await user.authentication;

        // Crie uma credencial do Firebase com o ID token
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Faça o sign-in no Firebase com a credencial do Google
        await FirebaseAuth.instance.signInWithCredential(credential);

        showSnackBar("Google Sign-in successful", context);
      }
    } catch (e) {
      showSnackBar("Error during Google sign-in: ${e.toString()}", context);
    }
  }

  // Função de Sign-up com Email e Senha
  static Future<String> signUpwithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Sign-up successful";
    } catch (e) {
      return "Error during sign up: ${e.toString()}";
    }
  }

  // Função de Sign-in com Email e Senha
  static Future<String> signInwithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Sign-in successful";
    } catch (e) {
      return "Error during sign in: ${e.toString()}";
    }
  }

  // Função para tratar o sign-in com Email e Senha
  static handleSignIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    String message = await signInwithEmail(email, password);
    showSnackBar(message, context);
  }

  // Função para tratar o sign-up com Email e Senha
  static handleSignUp(
    String email,
    String password,
    BuildContext context,
  ) async {
    String message = await signUpwithEmail(email, password);
    showSnackBar(message, context);
  }

  // Exibe um SnackBar com a mensagem fornecida
  static void showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.orange,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
