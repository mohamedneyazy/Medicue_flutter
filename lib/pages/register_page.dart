import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  String? selectedRole;

  bool hidePassword = true;
  bool hideConfirm = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void register() {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please choose Patient or Caregiver',
          ),
        ),
      );
      return;
    }

    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registration form validated for $selectedRole. '
                'Backend not connected yet.',
          ),
        ),
      );
    }
  }

  // ROLE CARD

  Widget roleCard(
      String role,
      IconData icon,
      String description,
      ) {
    bool selected = selectedRole == role;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedRole = role;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.lightBlue
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 32,
              ),

              const SizedBox(height: 8),

              Text(
                role,
                style: const TextStyle(
                  color: AppColors.dark,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textGrey,
                ),
              ),

              const SizedBox(height: 8),

              Icon(
                selected
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                color: selected
                    ? AppColors.primary
                    : AppColors.textGrey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 15,
          ),
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

                const Center(
                  child: DoseLogo(height: 85),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Join MediCue and take control of your health.',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 22),

                const FieldLabel('Choose your role'),

                const SizedBox(height: 10),

                Row(
                  children: [
                    roleCard(
                      'Patient',
                      Icons.person_outline,
                      'Manage your medicines',
                    ),

                    const SizedBox(width: 12),

                    roleCard(
                      'Caregiver',
                      Icons.people_outline,
                      'Monitor connected patients',
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                const FieldLabel('Full Name'),

                const SizedBox(height: 8),

                CustomTextField(
                  hint: 'Enter your full name',
                  icon: Icons.person_outline,
                  controller: nameController,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 17),

                const FieldLabel('Email Address'),

                const SizedBox(height: 8),

                CustomTextField(
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                ),

                const SizedBox(height: 17),

                const FieldLabel('Password'),

                const SizedBox(height: 8),

                CustomTextField(
                  hint: 'Create a password',
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
                      color: AppColors.textGrey,
                    ),
                  ),
                ),

                const SizedBox(height: 17),

                const FieldLabel('Confirm Password'),

                const SizedBox(height: 8),

                CustomTextField(
                  hint: 'Confirm your password',
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
                      color: AppColors.textGrey,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                PrimaryButton(
                  text: 'Create Account',
                  onPressed: register,
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 13,
                      ),
                    ),

                    TextButton(
                      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}