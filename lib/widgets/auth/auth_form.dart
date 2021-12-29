import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../animation/fade_in_up.dart';
import '../pickers/user_image_picker.dart';

enum AuthMode {
  signUp,
  logIn,
}

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext context,
  ) submitAuth;
  const AuthForm({
    Key? key,
    required this.submitAuth,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation1;
  late Animation<double> _opacityAnimation2;
  late Animation<Offset> _slideAnimation1;
  late Animation<Offset> _slideAnimation2;

  AuthMode _authMode = AuthMode.logIn;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _usernameController = TextEditingController();
  File? _userImageFile;

  OutlineInputBorder get decorateBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.secondary,
        width: 1.5,
      ),
    );
  }

  OutlineInputBorder get decorateErrorBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.error,
        width: 2,
      ),
    );
  }

  InputDecoration _decorateTextField(String title, IconData prefixIcon) {
    return InputDecoration(
      labelText: title,
      hintText: title,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
      ),
      hintStyle: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
      ),
      errorStyle: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
      ),
      prefixIcon: Icon(prefixIcon, color: Theme.of(context).iconTheme.color),
      enabledBorder: decorateBorder,
      focusedBorder: decorateBorder,
      errorBorder: decorateErrorBorder,
      focusedErrorBorder: decorateErrorBorder,
    );
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.signUp) {
      _controller.reverse();
      _usernameController.clear();
      _confirmPassController.clear();
      _userImageFile = File('');
      setState(() {
        _authMode = AuthMode.logIn;
      });
    } else {
      _controller.forward();
      setState(() {
        _authMode = AuthMode.signUp;
      });
    }
  }

  _showWarningDialog(String title, String content) {
    showDialog(
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

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_authMode == AuthMode.signUp) {
      if (_userImageFile == null) {
        _showWarningDialog(
          'Image Not Found Error',
          'Please pick an image',
        );
        return;
      } else if (_confirmPassController.text != _passwordController.text) {
        _confirmPassController.clear();
        _showWarningDialog('Error', 'Confirm Password Mismatch');
      } else if (_formKey.currentState!.validate()) {
        widget.submitAuth(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _usernameController.text.trim(),
          _userImageFile!,
          (_authMode == AuthMode.logIn),
          context,
        );
      }
    } else if (_authMode == AuthMode.logIn) {
      if (_formKey.currentState!.validate()) {
        widget.submitAuth(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          '',
          File(''),
          (_authMode == AuthMode.logIn),
          context,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacityAnimation1 = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeInBack,
      ),
    );

    _opacityAnimation2 = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeInBack,
      ),
    );

    _slideAnimation1 = Tween<Offset>(
      begin: const Offset(0.0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeInBack,
      ),
    );

    _slideAnimation2 = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeInBack,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.06,
          ),
          Center(
            child: AnimatedContainer(
              margin: const EdgeInsets.all(10),
              // height: _authMode == AuthMode.signUp ? 588.0 : 515.0,
              duration: const Duration(milliseconds: 700),
              padding:
                  const EdgeInsets.symmetric(vertical: 40, horizontal: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FadeTransition(
                        opacity: _opacityAnimation2,
                        child: UserImagePicker(
                          imagePickerFn: _pickedImage,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FadeTransition(
                        opacity: _opacityAnimation2,
                        child: SlideTransition(
                          position: _slideAnimation2,
                          child: TextFormField(
                            textCapitalization: TextCapitalization.words,
                            enableSuggestions: false,
                            autocorrect: true,
                            validator: (val) {
                              if (_authMode == AuthMode.signUp) {
                                if (val!.isEmpty) {
                                  return 'Empty Username Not Valid';
                                }
                                if (val.length <= 3) {
                                  return 'Username must be atleast 4 characters long';
                                }
                                if (val.length >= 20) {
                                  return 'Username length exceeded';
                                }
                              }
                              return null;
                            },
                            controller: _usernameController,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            decoration:
                                _decorateTextField('Username', Iconsax.user),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      FadeInUp(
                        factor: 0,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.words,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: _emailController,
                          key: const ValueKey('email'),
                          validator: (val) {
                            if (val!.isEmpty || !val.contains('@')) {
                              return 'Please valid email address';
                            }
                            return null;
                          },
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                          keyboardType: TextInputType.emailAddress,
                          decoration: _decorateTextField(
                            'Email',
                            CupertinoIcons.mail,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      FadeInUp(
                        factor: 1,
                        child: TextFormField(
                          controller: _passwordController,
                          key: const ValueKey('password'),
                          validator: (val) {
                            if (val!.isEmpty || val.length < 7) {
                              return 'Password must be atleast of 8 characters';
                            }
                            return null;
                          },
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration:
                              _decorateTextField('Password', Iconsax.key),
                        ),
                      ),
                      if (_authMode == AuthMode.signUp)
                        const SizedBox(
                          height: 15,
                        ),
                      FadeTransition(
                        opacity: _opacityAnimation1,
                        child: SlideTransition(
                          position: _slideAnimation1,
                          child: TextFormField(
                            controller: _confirmPassController,
                            key: const ValueKey('confirmPassword'),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: _decorateTextField(
                              'Confirm Password',
                              Iconsax.lock,
                            ),
                          ),
                        ),
                      ),
                      if (_authMode == AuthMode.signUp)
                        const SizedBox(height: 25),
                      FadeInUp(
                        factor: 2,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          onPressed: _submit,
                          minWidth: 100,
                          height: 40,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.8),
                          elevation: 0.0,
                          child: Text(
                            (_authMode == AuthMode.logIn) ? 'Login' : 'Sign up',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'FiraCode',
                            ),
                          ),
                          textColor: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeInUp(
                        factor: 3,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'FiraCode',
                              fontSize: 17,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            children: [
                              TextSpan(
                                text: (_authMode == AuthMode.signUp)
                                    ? 'Already have an account?  '
                                    : 'Don\'t have an account?  ',
                              ),
                              TextSpan(
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _switchAuthMode();
                                    },
                                  text: (_authMode == AuthMode.signUp)
                                      ? 'Log In'
                                      : 'Sign Up'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*

if (_authMode == AuthMode.signUp)
                        FadeTransition(
                          opacity: _opacityAnimation2,
                          child: SlideTransition(
                            position: _slideAnimation2,
                            child: TextFormField(
                              onSaved: (val) {
                                _userName = val!;
                              },
                              validator: (val) {
                                if (val!.isEmpty || val.length < 4) {
                                  return 'Please enter atleast 4 characters';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              keyboardType: TextInputType.emailAddress,
                              decoration: _decorateTextField(
                                'Username',
                                Iconsax.user,
                              ),
                            ),
                          ),
                        ),

*/
