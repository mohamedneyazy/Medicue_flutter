
import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';
import 'register_page.dart';
import 'password_pages.dart';
import 'patient_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;
  bool rememberMe = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login form validated. Backend not connected yet.'),
        ),
      );
    }
  }

  void skipLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PatientDashboard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),

          child: Form(
            key: formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Back Button

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.dark,
                  ),
                ),

                const SizedBox(height: 15),

                // Logo

                const Center(
                  child: DoseLogo(height: 105),
                ),

                const SizedBox(height: 25),

                // Title

                const Center(
                  child: Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    'Sign in to your account',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textGrey,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // Email

                const FieldLabel('Email Address'),

                const SizedBox(height: 9),

                CustomTextField(
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                ),

                const SizedBox(height: 20),

                // Password

                const FieldLabel('Password'),

                const SizedBox(height: 9),

                CustomTextField(
                  hint: 'Enter your password',
                  icon: Icons.lock_outline,
                  controller: passwordController,
                  obscureText: hidePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
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
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textGrey,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Remember Me and Forgot Password

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          activeColor: AppColors.primary,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value ?? false;
                            });
                          },
                        ),

                        const Text(
                          'Remember me',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Login Button

                PrimaryButton(
                  text: 'Log In',
                  onPressed: login,
                ),

                const SizedBox(height: 12),

                // Skip for Now Button

                Center(
                  child: TextButton(
                    onPressed: skipLogin,
                    child: const Text(
                      'Skip for Now',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Divider

                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: AppColors.border),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'or',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    const Expanded(
                      child: Divider(color: AppColors.border),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Google Button

                SizedBox(
                  width: double.infinity,
                  height: 53,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Google login will be available soon.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.g_mobiledata,
                      size: 30,
                      color: AppColors.dark,
                    ),
                    label: const Text(
                      'Continue with Google',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.border,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Create Account

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 13,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
