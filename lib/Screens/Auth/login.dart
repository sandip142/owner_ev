import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:owner_ev/Screens/btm_bar_screen.dart';
import 'package:owner_ev/Screens/widget/profile_dialog.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(milliseconds: 2250);

  // Login User
  Future<String?> _authUser(LoginData data) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'User does not exist';
      } else if (e.code == 'wrong-password') {
        return 'Password does not match';
      }
      return e.message;
    }
  }

  // SignUp User and Show Profile Dialog
  Future<String?> _signupUser(SignupData data, BuildContext ctx) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );

      // After signup, show Profile Dialog to complete details
      if (userCredential.user != null) {
        Navigator.of(ctx).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProfileCompletionScreen(uid: userCredential.user!.uid),
          ),
        );
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Recover Password
  Future<String?> _recoverPassword(String name) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: name);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'User does not exist';
      }
      return e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Charging Station',
      onLogin: (data) async {
        final loginResult = await _authUser(data);
        if (loginResult == null) {
          // Successful login
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => BottomBarScreen(uuid: user.uid),
              ),
            );
          }
        }
        return loginResult;
      },
      onSignup: (data) => _signupUser(data, context),
      onSubmitAnimationCompleted: () {
        // Additional actions after login or signup
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
