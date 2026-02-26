import 'package:flutter/material.dart';
import 'package:moneyapin/theme/app_theme.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: panggil bloc / API change password
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password updated successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.screen,
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: AppTheme.labelStyle,
        ),
        backgroundColor: AppTheme.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppTheme.secondary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),

                /// Current Password
                _buildPasswordField(
                  controller: _currentController,
                  hint: "Current Password",
                  obscure: _obscureCurrent,
                  toggle: () =>
                      setState(() => _obscureCurrent = !_obscureCurrent),
                ),

                const SizedBox(height: 16),

                /// New Password
                _buildPasswordField(
                  controller: _newController,
                  hint: "New Password",
                  obscure: _obscureNew,
                  toggle: () =>
                      setState(() => _obscureNew = !_obscureNew),
                ),

                const SizedBox(height: 16),

                /// Confirm Password
                _buildPasswordField(
                  controller: _confirmController,
                  hint: "Confirm New Password",
                  obscure: _obscureConfirm,
                  toggle: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                  validator: (value) {
                    if (value != _newController.text) {
                      return "Password does not match";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                /// Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(
                      "Update Password",
                      style: AppTheme.buttonStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback toggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return "This field is required";
            }
            if (value.length < 6) {
              return "Minimum 6 characters";
            }
            return null;
          },
      decoration: AppTheme.inputDecoration(hint).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: AppTheme.greyText,
          ),
          onPressed: toggle,
        ),
      ),
    );
  }
}