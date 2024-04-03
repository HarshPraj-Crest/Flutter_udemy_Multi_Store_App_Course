import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ms_customer_app/auth/forgot_password.dart';
import 'package:ms_customer_app/auth/widgets_auth/account_switch.dart';
import 'package:ms_customer_app/auth/widgets_auth/auth_main_button.dart';
import 'package:ms_customer_app/auth/widgets_auth/auth_screen_row.dart';
import 'package:ms_customer_app/auth/widgets_auth/customer_signin_text.dart';
import 'package:ms_customer_app/providers/auth_repo.dart';
import 'package:ms_customer_app/providers/id_provider.dart';
import 'package:ms_customer_app/widgets/snackbar.dart';
import 'package:provider/provider.dart';

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({super.key});

  @override
  State<CustomerLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  Future<bool> checkIfDocExists(dynamic docId) async {
    try {
      var doc = await customers.doc(docId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  setUserId(User user) {
    context.read<IdProvider>().setCustomerId(user);
  }

  bool docExists = false;

  Future<UserCredential> signInWithGoogle() async {
    // Sign out the current user to ensure the account picker dialog appears
    await GoogleSignIn().signOut();

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .whenComplete(() async {
      User user = FirebaseAuth.instance.currentUser!;

      print(googleUser!.id);
      print(user.uid);
      print(googleUser);
      print(user);
      setUserId(user);

      docExists = await checkIfDocExists(user.uid);

      docExists == false
          ? await customers.doc(user.uid).set({
              'name': user.displayName,
              'email': user.email,
              'profileimage': user.photoURL,
              'phone': '',
              'address': '',
              'cid': user.uid,
            }).then((value) => navigate())
          : navigate();
    });
  }

  late String email;
  late String password;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = false;
  bool sendVerification = false;

  void navigate() {
    Navigator.of(context).pushReplacementNamed('/customer_home');
  }

  void logIn() async {
    if (_formKey.currentState!.validate()) {
      final currentContext = context;

      try {
        setState(() {
          processing = true;
        });
        await AuthRepo.signInWithEmailAndPassword(email, password);

        await AuthRepo.reloadUserData();
        // if (await AuthRepo.checkEmailVerification()) {
        //   _formKey.currentState!.reset();
        User user = FirebaseAuth.instance.currentUser!;
        setUserId(user);

        if (context.mounted) {
          Navigator.pushReplacementNamed(currentContext, '/customer_home');
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
        MyMessageHandler.showSnackbar(_scaffoldKey, e.message.toString());

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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ForgotPassword()));
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
                            context, '/customer_signup');
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
                    divider(),
                    googleLoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget divider() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            '  or  ',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
            width: 80,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget googleLoginButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(60, 50, 60, 50),
      child: Material(
        elevation: 2,
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
        child: MaterialButton(
          onPressed: () {
            signInWithGoogle();
          },
          child: const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 22),
                child: Icon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                ),
              ),
              Text(
                'Sign In with Google',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
