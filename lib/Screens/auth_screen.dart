import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:prac_chat/Widgets/Authentication/auth_form.dart';
import "package:firebase_auth/firebase_auth.dart";

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;

  Future<void> _submitAuthForm(
      String userName,
      String userEmail,
      String userPassword,
      bool isLogin,
      BuildContext ctx)
  async {
    UserCredential authResult;
    try {
      if (isLogin) {
        setState(() {
          isLoading = true;
        });
        authResult = await _auth.signInWithEmailAndPassword(
            email: "", password: "password");
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: "email", password: "password");
        await FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user!.uid)
            .set({
          'username': userName,
          'password': userPassword,
          'Email': userEmail,
        });
      }
    } on PlatformException catch (e) {
      var message = "An Occurred, please check your credentials!";
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(message)));
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.teal.shade900,
      body: const AuthForm(
      ),
    );
  }
}