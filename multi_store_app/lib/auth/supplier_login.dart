import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/auth/forgot_password.dart';
import 'package:multi_store_app/auth/widgets_auth/account_switch.dart';
import 'package:multi_store_app/auth/widgets_auth/auth_main_button.dart';
import 'package:multi_store_app/auth/widgets_auth/auth_screen_row.dart';
import 'package:multi_store_app/auth/widgets_auth/customer_signin_text.dart';
import 'package:multi_store_app/providers/auth_repo.dart';
import 'package:multi_store_app/widgets/snackbar.dart';

class SupplierLogin extends StatefulWidget {
  const SupplierLogin({super.key});

  @override
  State<SupplierLogin> createState() => _SupplierLoginState();
}

class _SupplierLoginState extends State<SupplierLogin> {
  
  late String email;
  late String password;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = false;
  bool sendVerification = false;

  void logIn() async {
    if (_formKey.currentState!.validate()) {
      final currentContext = context;

      try {
        setState(() {
          processing = true;
        });
        await AuthRepo.signInWithEmailAndPassword(email, password);



         _formKey.currentState!.reset();

          if (context.mounted) {
            Navigator.pushReplacementNamed(currentContext, '/supplier_home');

        // await AuthRepo.reloadUserData();
        // if (await AuthRepo.checkEmailVerification()) {
         
          }
        // } else {
        //   MyMessageHandler.showSnackbar(
        //       _scaffoldKey, 'Please check your inbox for verification');
        //   setState(() {
        //     processing = false;
        //     sendVerification = true;
        //   });
        // }
      } on FirebaseAuthException catch (e) {
        print('Failed with error code: ${e.code}');
        print(e.message);
        MyMessageHandler.showSnackbar(
            _scaffoldKey, e.message.toString());

        setState(() {
          processing = false;
        });
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackbar(_scaffoldKey, 'Please fill all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthScreenRow(label: 'Log In'),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Pleae enter your email address';
                          } else if (value.isValidEmail() == false) {
                            return 'Invalid email';
                          } else if (value.isValidEmail() == true) {
                            return null;
                          }
                          return null;
                        },
                        // controller: _emailController,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: CustomerSignInText()
                            .buildInputDecoration()
                            .copyWith(
                              labelText: 'Email Address',
                              hintText: 'Enter your email address',
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: passwordVisible,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Pleae enter your password';
                          }
                          return null;
                        },
                        // controller: _passwordController,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: CustomerSignInText()
                            .buildInputDecoration()
                            .copyWith(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.purple,
                                ),
                              ),
                              labelText: 'Password',
                              hintText: 'Enter your password',
                            ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ForgotPassword()));
                        },
                        child: const Text(
                          'Forget Password ?',
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                        )),
                    AccountSwitch(
                      haveAccount: 'Don\'t have an account? ',
                      actionLabel: 'Sign Up',
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/supplier_signup');
                      },
                    ),
                    processing == true
                        ? const Center(child: CircularProgressIndicator())
                        : AuthMainButton(
                            label: 'Log In',
                            onPressed: () {
                              logIn();
                            },
                          ),
                    sendVerification == true
                        ? Padding(
                            padding: const EdgeInsets.only(left: 180),
                            child: TextButton(
                                onPressed: () async {
                                  try {
                                    await FirebaseAuth.instance.currentUser!
                                        .sendEmailVerification();
                                  } catch (e) {
                                    print(e);
                                  }
                                  MyMessageHandler.showSnackbar(_scaffoldKey,
                                      'Please check your inbox for email verification');
                                  Future.delayed(const Duration(seconds: 3))
                                      .whenComplete(() {
                                    setState(() {
                                      sendVerification = false;
                                    });
                                  });
                                },
                                child: const Text(
                                  'Resend Verification ?',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                  ),
                                )),
                          )
                        : const SizedBox(),
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
