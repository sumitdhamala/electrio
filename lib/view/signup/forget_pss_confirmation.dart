import 'package:electrio/component/custom_form_button.dart';
import 'package:electrio/component/custom_textfield.dart';
import 'package:electrio/component/page_header.dart';
import 'package:electrio/component/page_heading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:electrio/provider/user_provider.dart';

class ResetPasswordConfirmationPage extends StatefulWidget {
  const ResetPasswordConfirmationPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordConfirmationPage> createState() =>
      _ResetPasswordConfirmationPageState();
}

class _ResetPasswordConfirmationPageState
    extends State<ResetPasswordConfirmationPage> {
  final _resetPasswordFormKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_resetPasswordFormKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitting data...')),
      );

      try {
        // Call the reset password confirmation API
        await userProvider.confirmResetPassword(
          email: _emailController.text,
          otp: _otpController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        );

        // Show success message and redirect to login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successfully')),
        );

        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            const PageHeader(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _resetPasswordFormKey,
                    child: Column(
                      children: [
                        const PageHeading(
                          title: 'Reset Password',
                        ),
                        CustomInputField(
                          labelText: 'Email',
                          hintText: 'Your email',
                          isDense: true,
                          controller: _emailController,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'Email is required!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          labelText: 'OTP',
                          hintText: 'Enter OTP',
                          isDense: true,
                          controller: _otpController,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'OTP is required!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          labelText: 'Password',
                          hintText: 'Enter new password',
                          isDense: true,
                          controller: _passwordController,
                          obscureText: true,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'Password is required!';
                            }
                            if (textValue.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          labelText: 'Confirm Password',
                          hintText: 'Re-enter new password',
                          isDense: true,
                          controller: _confirmPasswordController,
                          obscureText: true,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'Confirmation password is required!';
                            }
                            if (textValue != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomFormButton(
                          innerText: 'Reset Password',
                          onPressed: _handleResetPassword,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
