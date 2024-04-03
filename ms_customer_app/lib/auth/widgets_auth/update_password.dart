import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ms_customer_app/auth/forgot_password.dart';
import 'package:ms_customer_app/providers/auth_repo.dart';
import 'package:ms_customer_app/widgets/appbar_title.dart';
import 'package:ms_customer_app/widgets/snackbar.dart';
import 'package:ms_customer_app/widgets/yellow_button.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool checkPassword = true;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const AppBarTitle(title: 'Change Password'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const SizedBox(height: 35),
                  const Text(
                      'To change your password please fill the form below and save changes',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey,
                        fontStyle: FontStyle.italic,
                      )),
                  const SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                      controller: _oldPasswordController,
                      decoration: emailFormDecoration.copyWith(
                        labelText: 'Old Password',
                        hintText: 'Enter your current password',
                        errorText:
                            checkPassword != true ? 'Not valid password' : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter new password';
                        }
                        return null;
                      },
                      controller: _newPasswordController,
                      decoration: emailFormDecoration.copyWith(
                        labelText: 'New Password',
                        hintText: 'Enter your new password',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextFormField(
                      validator: (value) {
                        if (value != _newPasswordController.text) {
                          return 'Password not matching';
                        } else if (value!.isEmpty) {
                          return 'Re-Enter your new password';
                        }
                        return null;
                      },
                      decoration: emailFormDecoration.copyWith(
                        labelText: 'Repeat Password',
                        hintText: 'Re-Enter your new password',
                      ),
                    ),
                  ),
                  FlutterPwValidator(
                    controller: _newPasswordController,
                    minLength: 6,
                    uppercaseCharCount: 1,
                    lowercaseCharCount: 2,
                    numericCharCount: 2,
                    specialCharCount: 1,
                    width: 400,
                    height: 180,
                    onSuccess: () {},
                    onFail: () {},
                  ),
                  // const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: YellowButton(
                      label: 'Save Changes',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          checkPassword = await AuthRepo.checkOldPassword(
                              FirebaseAuth.instance.currentUser!.email,
                              _oldPasswordController.text);
                          setState(() {});
                          checkPassword == true
                              ? AuthRepo.changePassword(
                                  _newPasswordController.text.trim()).whenComplete(() {
                                    _formKey.currentState!.reset();
                                    _oldPasswordController.clear();
                                    _newPasswordController.clear();
                                    MyMessageHandler.showSnackbar(_scaffoldKey, 'Successfully updated password');
                                    Future.delayed(const Duration(seconds: 3)).whenComplete(() => Navigator.of(context).pop());
                                  })
                              : print('invalid old password');
                          print('form valid');
                        } else {
                          print('form not valid');
                        }
                      },
                      width: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
