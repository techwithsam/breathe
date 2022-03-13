import 'package:breathe/auth/register.dart';
import 'package:breathe/pages/homepage.dart';
import 'package:breathe/widgets/button_widget.dart';
import 'package:breathe/widgets/textfield_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _phn, _pass;
  FocusNode? _passF;
  bool _obscureTextLogin = true;

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
                      controller: _phn,
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
                      focusNode: _passF,
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
                      children: const [
                        Text(
                          'Forgot passwords',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: ButtonWidget(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const HomePage(uid: ''),
                              ),
                            );
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        SizedBox(width: 30),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/google.png'),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/facebook.png'),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/apple.jpg'),
                        ),
                        SizedBox(width: 30),
                      ],
                    ),
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
    _phn = TextEditingController();
    _pass = TextEditingController();
    _passF = FocusNode();
  }

  @override
  void dispose() {
    _phn!.dispose();
    _pass!.dispose();
    _passF!.dispose();
    super.dispose();
  }
}
