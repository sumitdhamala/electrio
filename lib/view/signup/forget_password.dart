import 'package:electrio/component/custom_form_button.dart';
import 'package:electrio/component/custom_textfield.dart';
import 'package:electrio/component/page_header.dart';
import 'package:electrio/component/page_heading.dart';
import 'package:electrio/view/signup/loginpage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _forgetPasswordFormKey = GlobalKey<FormState>();

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
                  icon: Icon(Icons.arrow_back)),
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
                    key: _forgetPasswordFormKey,
                    child: Column(
                      children: [
                        const PageHeading(
                          title: 'Forgot password',
                        ),
                        CustomInputField(
                            labelText: 'Email',
                            hintText: 'Your email id',
                            isDense: true,
                            validator: (textValue) {
                              if (textValue == null || textValue.isEmpty) {
                                return 'Email is required!';
                              }
                              if (!EmailValidator.validate(textValue)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomFormButton(
                          innerText: 'Submit',
                          onPressed: _handleForgetPassword,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Container(
                        //   alignment: Alignment.center,
                        //   child: GestureDetector(
                        //     onTap: () => {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => const LoginPage()))
                        //     },
                        //     child: const Text(
                        //       'Back to login',
                        //       style: TextStyle(
                        //         fontSize: 13,
                        //         color: Colors.green,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ),
                        // ),
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

  void _handleForgetPassword() {
    // forget password
    if (_forgetPasswordFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitting data..')),
      );
    }
  }
}
