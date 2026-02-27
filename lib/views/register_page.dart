import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:moneyapin/controllers/auth_controller.dart';
import 'package:moneyapin/theme/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isAgree = false;
  bool _isLoading = false;
  final AuthController authController = Get.put(AuthController());

  Future<void> _handleRegister() async {
    if (!_isAgree) {
      Get.snackbar(
        "Error",
        "Please agree to Terms and Conditions",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await authController.register(
        emailController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
      );

      Get.offAllNamed('/dashboard');
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Register Failed",
        e.message ?? "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                  Text("Create Account", style: AppTheme.headingStyle),
                  const SizedBox(height:8),
                  Text("Join us and start managing your finances", style: AppTheme.bodyStyle),
                  const SizedBox(height:20),
                  InputUser(controller: nameController, hint: 'Alex Morgan', label:"Full Name"),
                  const SizedBox(height:20),
                  InputUser(controller: emailController, hint: 'you@example.com', label:"Email"),
                  const SizedBox(height:20),
                  InputUser(controller: passwordController, hint: '••••••••', label:"Password", isPassword: true),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _isAgree, 
                        checkColor: Colors.white,
                        activeColor: AppTheme.primary,
                        onChanged: (val){
                          setState((){
                            _isAgree = val ?? false;
                          });
                        }
                      ),
                      Text("I agree to the ", style: AppTheme.bodyStyle),
                      Text("Terms and Conditions", style: AppTheme.bodyStyle.copyWith(color:AppTheme.primary)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegister,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : const Text("Sign Up"),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ", style: AppTheme.bodyStyle),
                      GestureDetector(
                        onTap:(){
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text("Log In ", style: AppTheme.bodyStyle.copyWith(color:AppTheme.primary))
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