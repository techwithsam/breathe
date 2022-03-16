import 'dart:async';
import 'package:breathe/auth/register.dart';
import 'package:breathe/pages/homepage.dart';
import 'package:breathe/widgets/bgimg.dart';
import 'package:breathe/widgets/button_widget.dart';
import 'package:breathe/widgets/social_buttons.dart';
import 'package:breathe/widgets/textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _email, _pass;
  bool _obscureTextLogin = true, _load = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Enter your information to log into your account',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 30),
                    AppTextFormField(
                      controller: _email,
                      text: 'Enter email',
                      hintText: 'Enter your email address',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = RegExp(pattern.toString());
                        if (!regex.hasMatch(value!)) {
                          return 'Invalid email address';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 22),
                    AppTextFormField(
                      controller: _pass,
                      text: 'Password',
                      hintText: 'Enter password',
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _obscureTextLogin,
                      textInputAction: TextInputAction.send,
                      suffixIcon: IconButton(
                        onPressed: () => _toggleLogin(),
                        icon: _chgIcon(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'password cannot be empty';
                        } else if (value.length < 6) {
                          return 'minimum of 6 characters';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const HomePage(uid: ''),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot passwords',
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: _load
                          ? const SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                              ),
                            )
                          : ButtonWidget(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  signInWithForm();
                                }
                              },
                              btnName: 'Sign In',
                            ),
                    ),
                    const SizedBox(height: 26),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'Don’t have an account? ',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign-up',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterScreen(),
                                    ),
                                  );
                                },
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Center(child: Text('Continue with')),
                    const SizedBox(height: 25),
                    const SocialButtons(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chgIcon() {
    return !_obscureTextLogin
        ? const Icon(Icons.visibility_outlined)
        : const Icon(Icons.visibility_off_outlined);
  }

  _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _pass = TextEditingController();
  }

  @override
  void dispose() {
    _email!.dispose();
    _pass!.dispose();
    super.dispose();
  }

  void signInWithForm() async {
    _startLoading();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _email!.text, password: _pass!.text)
          .then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(uid: value.user!.uid),
          ),
        );
      }).timeout(timeOut);
    } on TimeoutException catch (_) {
      snackBar(timeMsg, context);
      _stopLoading();
    } on FirebaseAuthException catch (e) {
      _stopLoading();
      if (e.code == 'user-not-found') {
        snackBar('No user found for that email.', context);
      } else if (e.code == 'wrong-password') {
        snackBar('Wrong password provided for that user.', context);
      } else if (e.code == 'network-request-failed') {
        snackBar(noInternet, context);
      } else {
        snackBar('${e.message}', context);
      }
    }
    _stopLoading();
  }

  _startLoading() {
    setState(() {
      _load = true;
    });
  }

  _stopLoading() {
    setState(() {
      _load = false;
    });
  }
}
