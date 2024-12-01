import 'dart:io';
import 'package:electrio/component/custom_form_button.dart';
import 'package:electrio/component/custom_textfield.dart';
import 'package:electrio/component/page_header.dart';
import 'package:electrio/component/page_heading.dart';
import 'package:electrio/provider/user_provider.dart'; // Import UserProvider
import 'package:electrio/view/signup/loginpage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart'; // Import provider package

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? _profileImage;

  // Form key
  final _signupFormKey = GlobalKey<FormState>();

  // Controllers
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

  // Profile image picker
  Future _pickProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => _profileImage = imageTemporary);
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: SingleChildScrollView(
          child: Form(
            key: _signupFormKey,
            child: Column(
              children: [
                const PageHeader(),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const PageHeading(
                        title: 'Create Account',
                      ),
                      // SizedBox(
                      //   width: 130,
                      //   height: 130,
                      //   child: CircleAvatar(
                      //     backgroundColor: Colors.grey.shade200,
                      //     backgroundImage: _profileImage != null
                      //         ? FileImage(_profileImage!)
                      //         : null,
                      //     child: Stack(
                      //       children: [
                      //         // Positioned(
                      //         //   bottom: 5,
                      //         //   right: 5,
                      //         //   child: GestureDetector(
                      //         //     onTap: _pickProfileImage,
                      //         //     child: Container(
                      //         //       height: 50,
                      //         //       width: 50,
                      //         //       decoration: BoxDecoration(
                      //         //         color: Colors.blue.shade400,
                      //         //         border: Border.all(
                      //         //             color: Colors.white, width: 3),
                      //         //         borderRadius: BorderRadius.circular(25),
                      //         //       ),
                      //         //       child: const Icon(
                      //         //         Icons.camera_alt_sharp,
                      //         //         color: Colors.white,
                      //         //         size: 25,
                      //         //       ),
                      //         //     ),
                      //         //   ),
                      //         // ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        labelText: 'First Name',
                        hintText: 'Your First name',
                        controller: _firstnameController,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Name field is required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        labelText: 'Last Name',
                        hintText: 'Your Last name',
                        controller: _lastnameController,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Name field is required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        labelText: 'Username',
                        hintText: 'Username',
                        controller: _usernameController,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Name field is required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        labelText: 'Email',
                        hintText: 'Your email id',
                        controller: _emailController,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Email is required!';
                          }
                          if (!EmailValidator.validate(textValue)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        labelText: 'Contact no.',
                        hintText: 'Your contact number',
                        controller: _contactController,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Contact number is required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        labelText: 'Address',
                        hintText: 'Your address',
                        controller: _addressController,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Address is required!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        labelText: 'Password',
                        hintText: 'Your password',
                        obscureText: true,
                        controller: _passwordController,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Password is required!';
                          }
                          return null;
                        },
                        suffixIcon: true,
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        labelText: 'Confirm Password',
                        hintText: 'Confirm your password',
                        obscureText: true,
                        controller: _confirmPasswordController,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Confirm password is required!';
                          }
                          if (textValue != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        },
                        suffixIcon: true,
                      ),
                      const SizedBox(height: 22),
                      CustomFormButton(
                        innerText: 'Signup',
                        onPressed: _handleSignupUser,
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff939393),
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()))
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignupUser() async {
    if (_signupFormKey.currentState!.validate()) {
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Submitting data...')),
        );

        // Attempt user registration
        await userProvider.registerUser(
          firstName: _firstnameController.text,
          lastName: _lastnameController.text,
          username: _usernameController.text,
          email: _emailController.text,
          contact: _contactController.text,
          address: _addressController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        );

        // Show success message and navigate
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        // Display error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}
