// ignore_for_file: avoid_print, unused_element, prefer_const_constructors

import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prac_chat/Widgets/Authentication/signup.dart';

import '../../Constants/textfield_decoration.dart';
import '../../Screens/home_screen.dart';

class LogIn extends StatefulWidget {
  const LogIn({
    super.key,
    this.uid,
  });

  final String? uid;

  @override
  State<LogIn> createState() => _AuthFormState();
}

class _AuthFormState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  bool _emailTapped = false;
  bool _passwordTapped = false;
  final _text = '';

  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();

  @override
  void dispose() {
    _userEmailController.dispose();
    _userPasswordController.dispose();
    super.dispose();
  }

  String? get _errorTextEmail {
    @override
    void initState() {
      super.initState();
    }

    final emailText = _userEmailController.value.text;
    final emailRegExpression = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (_emailTapped && emailText.isEmpty) {
      return 'Can\'t be empty';
    }
    if (_emailTapped && !emailRegExpression.hasMatch(emailText)) {
      return 'Invalid Email Address';
    }
    // return null if the text is valid
    return null;
  }

  String? get _errorTextPassword {
    @override
    void initState() {
      super.initState();
    }

    final passText = _userPasswordController.value.text;
    // final passRegExpression = RegExp(
    //     r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

    if (_passwordTapped && passText.isEmpty) {
      return 'Can\'t be empty';
    }

    // if(_tapped && !passRegExpression.hasMatch(passText) ){
    //   return 'Invalid Password';
    // }
    // return null if the text is valid
    return null;
  }

  Future<void> logIn() async {
    final isValid = _formKey.currentState!.validate();
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _userEmailController.text,
            password: _userPasswordController.text);

    if (isValid) {
      setState(() {});

      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('userId', isEqualTo: userCredential.user!.uid)
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          // _showAlertDialog();
        });
      } else {
        setState(() {});
        final userData = snapshot.docs.first.data();
        final userPassword = userData['Password'];
        if (userPassword != _userPasswordController) {
          setState(() {});
          print('Incorrect password');
          //_showAlertDialog();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: MediaQuery.of(context).padding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Image(
                        width: 200,
                        height: 100,
                        image: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdk3Lps9LHjj879CMHkAMdwSI49f2FRyWixXkEbSw2JA&usqp=CAU&ec=48665699")),
                    const SizedBox(height: 70),
                    TextFormField(
                      // validator: (value) {
                      //   value = _userEmailController.text;
                      //   final emailRegExpression = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                      //   if (_touched && value.isEmpty) {
                      //     return 'Value cannot be empty';
                      //   } else if (_touched && !emailRegExpression.hasMatch(value)) {
                      //     return 'Invalid email address';
                      //   }
                      //   return null;
                      // },
                      onTap: () {
                        setState(() {
                          _emailTapped = true;
                          _passwordTapped = false;
                        });
                      },

                      keyboardType: TextInputType.emailAddress,
                      decoration: textInputDecoration.copyWith(
                        errorText: _errorTextEmail,
                        labelText: 'Email address',
                        prefixIcon: const Icon(Icons.mail),
                        prefixIconColor: Colors.black,
                      ),
                      controller: _userEmailController,
                      onChanged: (text) => setState(() => _text),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      // validator: (value) {
                      //   final passRegExpression = RegExp(
                      //       r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
                      //   if (value!.length >= 8) {
                      //     return ("Password is too Short");
                      //   } else if (!passRegExpression.hasMatch(value)) {
                      //     return 'Password is Weak';
                      //   }
                      //   return '';
                      // },
                      onTap: () {
                        setState(() {
                          _emailTapped = false;
                          _passwordTapped = true;
                        });
                      },

                      onChanged: (text) => setState(() => _text),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 23.0,
                        ),
                        errorText: _errorTextPassword,
                        labelText: 'password',
                        prefixIcon: const Icon(Icons.lock),
                        prefixIconColor: Colors.black,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            )),
                      ),
                      controller: _userPasswordController,
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    // if (_isLoading)
                    ElevatedButton(
                        onPressed: () async {
                          print("On Pressed Called");
                          try {
                            await logIn().then((value) {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return HomeScreen(
                                  cameras: const [],
                                );
                              }));
                            });
                          } on FirebaseAuthException catch (e) {
                            print(
                                "Failed to sign in with email and password: ${e.message}");
                            Future<void> showAlertDialog() async {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Error in Authentication',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                            "${e.message}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }

                            return showAlertDialog();

                            // handle error
                          }

                          // create();
                        },
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                              const Size(150, 50)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.teal.shade900),
                        ),
                        child: const Text(
                          'LogIn',
                          style: TextStyle(color: Colors.white),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const SignUp();
                          }));
                        },
                        child: const Text("Create a new account",
                            style:
                                TextStyle(color: Colors.teal, fontSize: 16))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
