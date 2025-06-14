import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_app/Screens/Home_Screen_View.dart';
import 'package:flutter_course_app/LoginAndRegister/Home.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google Sign-In
  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      log(userCredential.user!.email ?? 'Email não disponível');
      return null;
    } catch (e) {
      return null;
    }
  }

  // Sign Out
  static Future<void> signOut(BuildContext context) async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();

    // Redireciona para a tela inicial (por exemplo, LoginScreen)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
      (route) => false, // Remove todas as rotas anteriores
    );
  }

  // Sign-Up com Email e Senha (corrigido e agora static)
  static Future<Map<String, dynamic>> signUpwithEmail(
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {'success': true, 'message': 'Cadastro realizado com sucesso!'};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return {'success': false, 'message': 'Este e-mail já está em uso.'};
      } else if (e.code == 'weak-password') {
        return {'success': false, 'message': 'A senha é muito fraca.'};
      } else {
        return {'success': false, 'message': 'Erro: ${e.message}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro inesperado: $e'};
    }
  }

  // Sign-In com Email e Senha
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

  // Handler para Sign-In com redirecionamento para Home
  static Future<void> handleSignIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Se chegou aqui, o login foi bem-sucedido
      showSnackBar("Login realizado com sucesso!", context);

      // Redirecionar para a tela Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreenView()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      if (e.code == 'user-not-found') {
        errorMessage = "Usuário não encontrado.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Senha incorreta.";
      } else {
        errorMessage = "Erro durante o login: ${e.message}";
      }

      showSnackBar(errorMessage, context);
    } catch (e) {
      showSnackBar("Erro inesperado: ${e.toString()}", context);
    }
  }

  // Handler para Sign-Up (corrigido)
  static Future<void> handleSignUp(
    String email,
    String password,
    BuildContext context,
  ) async {
    final result = await signUpwithEmail(email, password);

    showSnackBar(result['message'], context);

    if (result['success']) {
      Future.delayed(const Duration(milliseconds: 500), () {});
    }
  }

  // Exibir mensagem
  static void showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.orange,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<void> resetPasswordSendWmail(
    String email,
    BuildContext context,
  ) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showSnackBar("Reset password email sent successfully", context);
    } catch (e) {
      showSnackBar("Error: ${e.toString()}", context);
    }
  }
}
