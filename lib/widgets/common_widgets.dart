import 'package:flutter/material.dart';

import 'animated_medicue_logo.dart';

// COLORS

class AppColors {
  static const Color primary = Color(0xFF00B4C8);
  static const Color dark = Color(0xFF0B3870);
  static const Color lightBlue = Color(0xFFEAF7FC);
  static const Color background = Color(0xFFF5FAFC);
  static const Color border = Color(0xFFDCECF3);
  static const Color textGrey = Color(0xFF71869A);
}

// MEDICUE LOGO

class DoseLogo extends StatelessWidget {
  final double height;

  const DoseLogo({
    super.key,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedMediCueLogo(
      height: height,
      showAmbientGlow: false,
    );
  }
}

// REUSABLE BUTTON

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 53,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// REUSABLE TEXT FIELD

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 13,
          color: AppColors.textGrey,
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.primary,
          size: 21,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

// FIELD LABEL

class FieldLabel extends StatelessWidget {
  final String text;

  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.dark,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }
}

// EMAIL VALIDATION

String? emailValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your email';
  }

  if (!RegExp(
    r'^[^@]+@[^@]+\.[^@]+$',
  ).hasMatch(value.trim())) {
    return 'Please enter a valid email';
  }

  return null;
}
