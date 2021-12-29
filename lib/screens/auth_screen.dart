import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;

  final _auth = FirebaseAuth.instance;

  Future<void> _showWarningDialog(String title, String content) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _submitAuthForm(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext context,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (isLogin) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        final authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult.user!.uid + '.jpg');

        await ref.putFile(image).whenComplete(() => null);

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
          'userImageUrl': url,
        });
      }
    } on FirebaseAuthException catch (err) {
      var message = 'Please Check Your Internet Connection';
      if (err.message != null) {
        message = err.code;
      }
      _showWarningDialog('Error', message).then(
        (_) => setState(
          () {
            _isLoading = false;
          },
        ),
      );
    } catch (err) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    // if (mounted) {
    //   Future.delayed(Duration.zero, () {
    //     setState(() {
    //       _isLoading = true;
    //     });
    //   }).then((_) {
    //     Future.delayed(const Duration(seconds: 1), () {
    //       setState(() {
    //         _isLoading = false;
    //       });
    //     });
    //   });
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Builder(builder: (context) {
        if (_isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return AuthForm(
          submitAuth: _submitAuthForm,
        );
      }),
    );
  }
}
