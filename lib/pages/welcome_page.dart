import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(45),
                    bottomRight: Radius.circular(45),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // Original medical illustration
                    Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.favorite,
                            size: 145,
                            color: Color(0xFFD9F1F2),
                          ),
                          const Icon(
                            Icons.medication,
                            size: 80,
                            color: AppColors.primary,
                          ),
                          Positioned(
                            right: 28,
                            bottom: 38,
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: const BoxDecoration(
                                color: AppColors.dark,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: 27,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'Take Care. Live Better.',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 25,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Your smart medicine reminder '
                          'for a healthier tomorrow.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),

                    PrimaryButton(
                      text: 'Get Started',
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                        );
                      },
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: AppColors.dark,
                            fontSize: 13,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}