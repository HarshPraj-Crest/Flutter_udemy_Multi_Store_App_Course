import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ms_customer_app/auth/widgets_auth/account_switch.dart';
import 'package:ms_customer_app/auth/widgets_auth/auth_main_button.dart';
import 'package:ms_customer_app/auth/widgets_auth/auth_screen_row.dart';
import 'package:ms_customer_app/auth/widgets_auth/customer_signin_text.dart';
import 'package:ms_customer_app/providers/auth_repo.dart';
import 'package:ms_customer_app/widgets/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CustomerSignup extends StatefulWidget {
  const CustomerSignup({super.key});

  @override
  State<CustomerSignup> createState() => _CustomerSignupState();
}

class _CustomerSignupState extends State<CustomerSignup> {
  late String name;
  late String email;
  late String password;
  late String profilePicture;
  late String _uid;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = false;

  final ImagePicker _picker = ImagePicker();

  XFile? _imageFile;
  dynamic _pickedImageError;

  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  void _pickImageFromCamera() async {
    try {
      final pickedImage = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  void signUp() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        final currentContext = context;
        try {
          await AuthRepo.signUpWithEmailAndPassword(email, password);

          AuthRepo.sendEmailVerification();

          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref('cust-images/$email.jpg');

          final metadata =
              firebase_storage.SettableMetadata(contentType: 'image/jpeg');

          await ref.putFile(File(_imageFile!.path), metadata);
          _uid = FirebaseAuth.instance.currentUser!.uid;

          profilePicture = await ref.getDownloadURL();

          AuthRepo.updateUserName(name);
          AuthRepo.updateProfileImage(profilePicture);

          await customers.doc(_uid).set({
            'name': name,
            'email': email,
            'profileimage': profilePicture,
            'phone': '',
            'address': '',
            'cid': _uid,
          });

          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });

          if (context.mounted) {
            Navigator.pushReplacementNamed(currentContext, '/customer_login');
          }
        } on FirebaseAuthException catch (e) {
          setState(() {
            processing = false;
          });

          MyMessageHandler.showSnackbar(_scaffoldKey, e.message.toString());

          // if (e.code == 'weak-password') {
          //   setState(() {
          //     processing = false;
          //   });
          //   MyMessageHandler.showSnackbar(
          //       _scaffoldKey, 'The password provided is too weak.');
          // } else if (e.code == 'email-already-in-use') {
          //   setState(() {
          //     processing = false;
          //   });
          //   MyMessageHandler.showSnackbar(
          //       _scaffoldKey, 'The account already exists for that email.');
          // }
        }
      } else {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackbar(
            _scaffoldKey, 'Please pick an image first');
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
                  children: [
                    const AuthScreenRow(label: 'Sign Up'),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 40,
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.purpleAccent,
                            backgroundImage: _imageFile == null
                                ? null
                                : FileImage(
                                    File(_imageFile!.path),
                                  ),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _pickImageFromCamera();
                                },
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.photo,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _pickImageFromGallery();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Pleae enter your full name';
                          }
                          return null;
                        },
                        // controller: _nameController,
                        onChanged: (value) {
                          name = value;
                        },
                        decoration: CustomerSignInText()
                            .buildInputDecoration()
                            .copyWith(
                              labelText: 'Full Name',
                              hintText: 'Enter your full name',
                            ),
                      ),
                    ),
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
                    AccountSwitch(
                      haveAccount: 'already have account? ',
                      actionLabel: 'Log In',
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/customer_login');
                      },
                    ),
                    processing == true
                        ? CircularProgressIndicator()
                        : AuthMainButton(
                            label: 'Sign Up',
                            onPressed: () {
                              signUp();
                            },
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
}
