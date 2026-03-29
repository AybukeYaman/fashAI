import 'package:flutter/material.dart';

class LoginViewModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController forgotPasswordController =
      TextEditingController();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> forgotFormKey = GlobalKey<FormState>();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    forgotPasswordController.dispose();
  }
}
