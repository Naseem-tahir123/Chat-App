import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String text;
  final String? initialValue;
  final Widget? prefixicon;
  final Widget? suffixicon;
  final bool obscureText;
  final int? length;
  final int? lines;
  final TextInputType? keyboard;
  final TextInputAction? inputAction;
  final String? Function(String?)? validator;
  final Function(String)? onchanged;
  final Function(String?)? onsaved;
  MyTextField(
      {super.key,
      this.controller,
      required this.text,
      this.prefixicon,
      this.obscureText = false, // by default false rakha hy
      this.validator,
      this.initialValue,
      this.onchanged,
      this.onsaved,
      this.length,
      this.lines,
      this.keyboard,
      this.inputAction,
      this.suffixicon});

  // final FormField = GlobalKey<FormState>;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 0,
        top: 0,
        bottom: 5,
      ),
      child: TextFormField(
        controller: controller,
        maxLength: length,
        maxLines: lines,
        onChanged: onchanged,
        onSaved: onsaved,
        keyboardType: keyboard,
        initialValue: initialValue,
        textInputAction: inputAction,
        obscureText: obscureText,
        validator: validator,
        // onSaved: onsaved,
        decoration: InputDecoration(
          hintText: text,
          fillColor: const Color(0xffF8F9FA),
          filled: true,
          prefixIcon: prefixicon,
          suffixIcon: suffixicon,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffE4E7EB)),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffE4e7EB)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
