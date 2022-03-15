import 'dart:async';
import 'dart:developer';
import 'package:breathe/auth/login.dart';
import 'package:breathe/pages/settings.dart';
import 'package:breathe/widgets/bgimg.dart';
import 'package:breathe/widgets/button_widget.dart';
import 'package:breathe/widgets/social_buttons.dart';
import 'package:breathe/widgets/textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

var date = DateTime.now();

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  DatabaseReference db = FirebaseDatabase.instance.ref().child("Users");
  TextEditingController? _fname, _phn, _email, _pass, _ddate;
  bool _obscureTextLogin = true, load = false;

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
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Fill in your most important information here ',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 30),
                    AppTextFormField(
                      controller: _fname,
                      text: 'Full name*',
                      hintText: 'Enter your full name',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Empty field detected';
                        } else if (value.length < 3) {
                          return 'enter your full name';
                        } else if (!value.contains(' ')) {
                          return 'first and last name required';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 22),
                    AppTextFormField(
                      controller: _phn,
                      text: 'Phone number*',
                      hintText: 'Enter your phone number',
                      prefixI: Icons.dialpad_outlined,
                      keyboardType: TextInputType.number,
                      maxLenght: 11,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Empty field detected';
                        } else if (value.length != 11) {
                          return 'Phone number must have 11 digits ';
                        } else if (double.tryParse(value) == null) {
                          return 'Please enter a valid phone Number';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 22),
                    AppTextFormField(
                      controller: _email,
                      text: 'Enter email*',
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
                      textInputAction: TextInputAction.done,
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
                    const SizedBox(height: 22),
                    AppTextFormField(
                      readOnly: true,
                      controller: _ddate,
                      text: 'Date of birth',
                      hintText: 'Enter date of birth',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      suffixIcon: const Icon(Icons.calendar_month),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Date of birth must be specified';
                        } else {
                          return null;
                        }
                      },
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(1880),
                            lastDate: DateTime.now()
                            // DateTime.now().add(const Duration(days: 1500)),
                            );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                            _ddate!.text =
                                DateFormat.yMd().format(selectedDate);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: load
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
                                  signUpWithForm();
                                }
                              },
                              btnName: 'Sign Up',
                            ),
                    ),
                    const SizedBox(height: 26),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'Already have an account? ',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign in',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                },
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
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
    _fname = TextEditingController();
    _phn = TextEditingController();
    _email = TextEditingController();
    _ddate = TextEditingController();
    _pass = TextEditingController();
  }

  @override
  void dispose() {
    _fname!.dispose();
    _email!.dispose();
    _phn!.dispose();
    _ddate!.dispose();
    _pass!.dispose();
    super.dispose();
  }

  void signUpWithForm() async {
    startLoading();
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _email!.text, password: _pass!.text)
          .then((value) {
        db.child(value.user!.uid).set({
          "uid": value.user!.uid,
          "email": _email!.text,
          "name": _fname!.text,
          "phn": _phn!.text,
          "dob": _ddate!.text,
        }).then((res) {
          stopLoading();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsScreen(uid: value.user!.uid),
            ),
          );
        });
      }).timeout(timeOut);
    } on TimeoutException catch (_) {
      snackBar(timeMsg, context);
      stopLoading();
    } on FirebaseAuthException catch (e) {
      log('${e.message} -- before');
      stopLoading();
      if (e.code == 'email-already-in-use') {
        snackBar(
            'The email address is already in use by another account.', context);
      } else if (e.code == 'network-request-failed') {
        snackBar(noInternet, context);
      } else {
        log('${e.message}');
        snackBar('${e.message}', context);
      }
    }
    stopLoading();
  }

  startLoading() {
    setState(() {
      load = true;
    });
  }

  stopLoading() {
    setState(() {
      load = false;
    });
  }
}

const Duration timeOut = Duration(seconds: 30);
const String timeMsg = 'Request timeout. Kindly try again';
const String noInternet =
    'No active internet connection, Kindly connect to the internet';
const kStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
