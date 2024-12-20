import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final String? Function(String?) validator;
  final bool suffixIcon;
  final bool? isDense;
  final bool obscureText;
  final TextEditingController? controller; // Add this
  final Function(String?)? onChanged; // Add onChanged parameter

  const CustomInputField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.validator,
    this.suffixIcon = false,
    this.isDense,
    this.obscureText = false,
    this.controller, // Add this
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            controller: widget.controller, // Use the controller here
            obscureText: (widget.obscureText && _obscureText),
            decoration: InputDecoration(
              isDense: widget.isDense ?? false,
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              suffixIcon: widget.suffixIcon
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.remove_red_eye
                            : Icons.visibility_off_outlined,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              suffixIconConstraints: BoxConstraints(
                maxHeight: widget.isDense == true ? 33 : 48,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.green), // Update color as needed
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.green), // Update color as needed
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            onChanged: widget.onChanged, // Add onChanged to TextFormField
          ),
        ],
      ),
    );
  }
}
