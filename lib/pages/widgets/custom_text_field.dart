import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final IconData? icon;
  final String label;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool readOnly;

  const CustomTextFieldWidget({
    super.key,
    this.icon,
    required this.label,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.controller,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: icon == null ? null : Icon(icon, color: Colors.grey),
        suffixIcon: suffixIcon,
        hintText: label,
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: label == 'Referral (Optional)'
          ? null
          : (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
    );
  }
}
