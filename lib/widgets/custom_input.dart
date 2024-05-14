// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../style/app_color.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool disabled;

  String? Function(String? value)? validate;
  final EdgeInsetsGeometry margin;
  final bool obscureText;
  final TextInputType? keyboardType;

  CustomInput({
    super.key,
    this.validate,
    required this.controller,
    required this.label,
    required this.hint,
    this.disabled = false,
    this.margin = const EdgeInsets.only(bottom: 16),
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 55,
        child: TextFormField(
          validator: widget.validate,
          keyboardType: widget.keyboardType,
          readOnly: widget.disabled,
          obscureText: widget.obscureText && !isPasswordVisible,
          style: const TextStyle(fontSize: 16),
          maxLines: 1,
          controller: widget.controller,
          decoration: InputDecoration(
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColor.blackColor,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  )
                : null,
            label: Text(
              widget.label,
              style: TextStyle(fontSize: 16, color: AppColor.blackColor),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: widget.hint,
            hintStyle: TextStyle(fontSize: 16, color: AppColor.secondarySoft),
          ),
          onChanged: (value) {
            // Check the temperature and show alert if needed
            if (widget.validate != null) {
              widget.validate!(value);
            }
          },
        ),
      ),
    );
  }
}
