import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
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

  // Handler para Sign-In
  static Future<void> handleSignIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    String message = await signInwithEmail(email, password);
    showSnackBar(message, context);
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
