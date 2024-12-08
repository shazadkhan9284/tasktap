import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final int maxLines;
  final String? hintText;
  final Color? txtColor;


  const CustomTextField({
    Key? key,
    required this.controller,
    this.txtColor,
    this.labelText,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.maxLines = 1,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: TextFormField(
        style: TextStyle(
          color: txtColor
        ),
        cursorColor: Colors.yellow,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.grey[800]),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w400
          ),
          filled: true,
          fillColor: Colors.white,
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(15.0),
            borderSide:BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0)
          ),
          // error: Icon(Icons.error),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(15.0),
          //   borderSide: BorderSide.none,
          // ),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      ),
    );
  }
}
