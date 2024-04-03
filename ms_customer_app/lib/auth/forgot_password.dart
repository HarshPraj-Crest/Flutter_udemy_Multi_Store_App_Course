import 'package:flutter/material.dart';
import 'package:ms_customer_app/auth/widgets_auth/customer_signin_text.dart';
import 'package:ms_customer_app/providers/auth_repo.dart';
import 'package:ms_customer_app/widgets/appbar_title.dart';
import 'package:ms_customer_app/widgets/yellow_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Forgot Password ?'),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter your email for reset password link',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 55),
                TextFormField(
                  controller: _emailController,
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
                  keyboardType: TextInputType.emailAddress,
                  decoration: emailFormDecoration.copyWith(
                    labelText: 'Email Address',
                    hintText: 'Enter your email',
                  ),
                ),
                const SizedBox(height: 45),
                YellowButton(
                  label: 'Send Reset Password Link',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      AuthRepo.resetPasswordLink(_emailController.text);
                    } else {
                      print('Form not valid');
                    }
                  },
                  width: 0.6,
                ),
              ],
            ),
          )),
    );
  }
}

var emailFormDecoration = InputDecoration(
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.purple,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(25),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.deepPurple,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(25),
  ),
);
