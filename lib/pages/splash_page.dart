import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../widgets/animated_medicue_logo.dart';
import '../widgets/common_widgets.dart';
import 'login_page.dart';
import 'register_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  final GlobalKey<AnimatedMediCueLogoState> _logoKey =
      GlobalKey<AnimatedMediCueLogoState>();

  late final AnimationController _masterController;
  late final AnimationController _ambientController;

  @override
  void initState() {
    super.initState();

    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..forward();

    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat();
  }

  void _openGetStarted() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => const RegisterPage(),
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _openLogin() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => const LoginPage(),
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _masterController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  double _interval(double t, double begin, double end,
      [Curve curve = Curves.linear]) {
    if (t <= begin) return 0.0;
    if (t >= end) return 1.0;
    return curve.transform((t - begin) / (end - begin));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_masterController, _ambientController]),
        builder: (context, _) {
          final t = _masterController.value;
          final ambient = _ambientController.value;
          final phase = ambient * 2 * math.pi;

          final logoEnter = _interval(t, 0.0, 0.45, Curves.easeOutBack);
          final textEnter = _interval(t, 0.40, 0.78, Curves.easeOutCubic);
          final btnEnter = _interval(t, 0.58, 0.96, Curves.easeOutCubic);

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF5FCFF),
                  Color(0xFFE3F6FC),
                  Color(0xFFD2EFFA),
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. Floating background medical crosses & capsules
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MedicalBackdropPainter(
                      ambientProgress: ambient,
                      introProgress: _interval(t, 0.0, 0.6, Curves.easeOut),
                    ),
                  ),
                ),

                // 2. Main Foreground Content
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 24,
                    ),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),

                        // 3. Centerpiece Animated Logo + Rotating Dashed Circle
                        SizedBox(
                          height: 265,
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              // Rotating dashed orbital circle
                              Transform.rotate(
                                angle: phase,
                                child: CustomPaint(
                                  size: const Size(255, 255),
                                  painter: _OrbitRingPainter(),
                                ),
                              ),

                              // Transparent floating 7-layer animated MediCue logo
                              Transform.scale(
                                scale: 0.85 + 0.15 * logoEnter,
                                child: Opacity(
                                  opacity: logoEnter.clamp(0.0, 1.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 20,
                                    ),
                                    child: AnimatedMediCueLogo(
                                      key: _logoKey,
                                      height: 125,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 26),

                        // 4. Animated Headline & Subtitle
                        Opacity(
                          opacity: textEnter.clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(0, (1.0 - textEnter) * 18),
                            child: Column(
                              children: [
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.dark,
                                      letterSpacing: -0.3,
                                    ),
                                    children: [
                                      TextSpan(text: 'Never Miss a Dose. '),
                                      TextSpan(
                                        text: 'Right on Cue.',
                                        style: TextStyle(
                                          color: Color(0xFF00A6B8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    'Your cheerful pocket pharmacist & timely health reminder',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.dark,
                                      fontSize: 15,
                                      height: 1.45,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Spacer(flex: 3),

                        // 5. Get Started Button
                        Opacity(
                          opacity: btnEnter.clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(0, (1.0 - btnEnter) * 20),
                            child: PrimaryButton(
                              text: 'Get Started',
                              onPressed: _openGetStarted,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OrbitRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final ringPaint = Paint()
      ..color = const Color(0xFF00B8C8).withValues(alpha: 0.26)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    // Draw dashed orbit circle
    const dashCount = 36;
    const sweep = (2 * math.pi / dashCount) * 0.55;
    for (int i = 0; i < dashCount; i++) {
      final startAngle = (2 * math.pi / dashCount) * i;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        ringPaint,
      );
    }

    // Draw two glowing orbiting nodes
    final node1 = Offset(
      center.dx + radius * math.cos(0.4),
      center.dy + radius * math.sin(0.4),
    );
    final node2 = Offset(
      center.dx + radius * math.cos(0.4 + math.pi),
      center.dy + radius * math.sin(0.4 + math.pi),
    );

    canvas.drawCircle(
      node1,
      5,
      Paint()..color = const Color(0xFF00B8C8),
    );
    canvas.drawCircle(
      node2,
      5,
      Paint()..color = const Color(0xFF0088FF),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MedicalBackdropPainter extends CustomPainter {
  final double ambientProgress;
  final double introProgress;

  _MedicalBackdropPainter({
    required this.ambientProgress,
    required this.introProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Floating Medical Crosses & Capsules in background
    final items = [
      (0.14, 0.18, 16.0, true, const Color(0xFF00B8C8)),
      (0.86, 0.20, 14.0, false, const Color(0xFF0088FF)),
      (0.12, 0.72, 15.0, false, const Color(0xFF123D68)),
      (0.88, 0.70, 18.0, true, const Color(0xFF00B8C8)),
      (0.22, 0.86, 12.0, true, const Color(0xFF0088FF)),
      (0.78, 0.12, 13.0, true, const Color(0xFF123D68)),
    ];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final phase = ambientProgress * 2 * math.pi + i * 1.1;
      final dx = size.width * item.$1 + math.sin(phase) * 8.0;
      final dy = size.height * item.$2 + math.cos(phase) * 10.0;
      final r = item.$3;
      final isCross = item.$4;
      final color = item.$5.withValues(alpha: 0.13 * introProgress);

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(math.sin(phase * 0.5) * 0.35);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      if (isCross) {
        final bar = r * 0.36;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: r, height: bar),
            Radius.circular(bar / 2),
          ),
          paint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: bar, height: r),
            Radius.circular(bar / 2),
          ),
          paint,
        );
      } else {
        // Capsule pill silhouette
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: r * 1.4,
              height: r * 0.65,
            ),
            Radius.circular(r * 0.35),
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _MedicalBackdropPainter oldDelegate) {
    return oldDelegate.ambientProgress != ambientProgress ||
        oldDelegate.introProgress != introProgress;
  }
}
