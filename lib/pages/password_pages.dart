import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';

// =====================================================
// FORGOT PASSWORD PAGE
// =====================================================

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState
    extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void continueReset() {
    if (formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordPage(
            email: emailController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.dark,
                  ),
                ),

                const SizedBox(height: 25),

                const Center(
                  child: DoseLogo(height: 110),
                ),

                const SizedBox(height: 30),

                const Center(
                  child: Icon(
                    Icons.lock_reset,
                    color: AppColors.primary,
                    size: 75,
                  ),
                ),

                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.dark,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Enter your registered email address '
                      'to continue with password recovery.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 35),

                const FieldLabel('Email Address'),

                const SizedBox(height: 10),

                CustomTextField(
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                ),

                const SizedBox(height: 25),

                PrimaryButton(
                  text: 'Continue',
                  onPressed: continueReset,
                ),

                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(
                        color: AppColors.primary,
                      ),
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
}

// =====================================================
// RESET PASSWORD PAGE
// =====================================================

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({
    super.key,
    required this.email,
  });

  @override
  State<ResetPasswordPage> createState() =>
      _ResetPasswordPageState();
}

class _ResetPasswordPageState
    extends State<ResetPasswordPage> {
  final formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool hidePassword = true;
  bool hideConfirm = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void resetPassword() {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password form validated. Backend integration is still needed.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.dark,
                  ),
                ),

                const SizedBox(height: 25),

                const Center(
                  child: DoseLogo(height: 110),
                ),

                const SizedBox(height: 30),

                const Center(
                  child: Icon(
                    Icons.password,
                    color: AppColors.primary,
                    size: 75,
                  ),
                ),

                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                      color: AppColors.dark,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Create a new password for your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    widget.email,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                const FieldLabel('New Password'),

                const SizedBox(height: 10),

                CustomTextField(
                  hint: 'Enter new password',
                  icon: Icons.lock_outline,
                  controller: passwordController,
                  obscureText: hidePassword,
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const FieldLabel('Confirm New Password'),

                const SizedBox(height: 10),

                CustomTextField(
                  hint: 'Confirm new password',
                  icon: Icons.lock_outline,
                  controller: confirmController,
                  obscureText: hideConfirm,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }

                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hideConfirm = !hideConfirm;
                      });
                    },
                    icon: Icon(
                      hideConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                PrimaryButton(
                  text: 'Reset Password',
                  onPressed: resetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}