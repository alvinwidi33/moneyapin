import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:moneyapin/controllers/auth_controller.dart';
import 'package:moneyapin/theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  bool _isLoading = false;
  
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  
  
  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      await authController.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      Get.offAllNamed('/dashboard');
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Failed",
        e.message ?? "Invalid email or password",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.screen,
      body: SafeArea(
        child: SingleChildScrollView(
          child:Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.92,
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Icon(Icons.account_balance, size: 48, color:AppTheme.primary),
                  const SizedBox(height: 20),
                  Text("Welcome Back", style: AppTheme.headingStyle),
                  const SizedBox(height:8),
                  Text("Log in to manage your finances", style: AppTheme.bodyStyle),
                  const SizedBox(height:20),
                  InputUser(controller: emailController, hint: 'you@example.com', label:"Email"),
                  const SizedBox(height:20),
                  InputUser(controller: passwordController, hint: '••••••••', label:"Password", isPassword: true),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("Forgot password?", style:AppTheme.bodyStyle.copyWith(color:AppTheme.primary))
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : const Text("Log In"),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: AppTheme.bodyStyle),
                      GestureDetector(
                        onTap:(){
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                        child: Text("Sign Up ", style: AppTheme.bodyStyle.copyWith(color:AppTheme.primary))
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          )
        )
      )
    );
  }
}

class InputUser extends StatelessWidget {
  const InputUser({
    super.key,
    required this.controller,
    required this.hint,
    required this.label,
    this.isPassword = false
  });

  final TextEditingController controller;
  final String hint;
  final String label;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child:Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(label, style:AppTheme.labelStyle)
          ),
          const SizedBox(height:4),
          Container(
            decoration: AppTheme.inputContainerDecoration,
            clipBehavior: Clip.antiAlias,
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: AppTheme.inputDecoration(hint)
            )
          )
        ],
      )
    );
  }
}