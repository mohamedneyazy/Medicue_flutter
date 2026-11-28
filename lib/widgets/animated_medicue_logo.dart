import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedMediCueLogo extends StatefulWidget {
  final double? height;
  final double? width;
  final bool autoPlay;
  final bool enableIdleAnimation;
  final bool showAmbientGlow;
  final VoidCallback? onAnimationComplete;

  const AnimatedMediCueLogo({
    super.key,
    this.height,
    this.width,
    this.autoPlay = true,
    this.enableIdleAnimation = true,
    this.showAmbientGlow = true,
    this.onAnimationComplete,
  });

  @override
  State<AnimatedMediCueLogo> createState() => AnimatedMediCueLogoState();
}

class AnimatedMediCueLogoState extends State<AnimatedMediCueLogo>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _idleController;

  // Pivots computed from the 880x280 aligned layer canvas
  static const Alignment _bottlePivot = Alignment(-0.6966, 0.0714);
  static const Alignment _bottleSparksPivot = Alignment(-0.4795, -0.6750);
  static const Alignment _mediPivot = Alignment(-0.0761, 0.0571);
  static const Alignment _cuePivot = Alignment(0.6102, 0.0321);
  static const Alignment _capsulePivot = Alignment(0.4557, 0.0607);
  static const Alignment _cueSparksPivot = Alignment(0.6670, -0.5321);

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _introController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });

    if (widget.enableIdleAnimation) {
      _idleController.repeat();
    }

    if (widget.autoPlay) {
      _introController.forward();
    } else {
      _introController.value = 1.0;
    }
  }

  void replay() {
    _introController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _introController.dispose();
    _idleController.dispose();
    super.dispose();
  }

  double _interval(double t, double begin, double end, [Curve curve = Curves.linear]) {
    if (t <= begin) return 0.0;
    if (t >= end) return 1.0;
    final normalized = (t - begin) / (end - begin);
    return curve.transform(normalized);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: replay,
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: AspectRatio(
          aspectRatio: 880 / 280,
          child: AnimatedBuilder(
            animation: Listenable.merge([_introController, _idleController]),
            builder: (context, _) {
              final t = _introController.value;
              final idlePhase = _idleController.value * 2 * math.pi;
              final idleWeight = _interval(t, 0.70, 1.0, Curves.easeInOut);

              // 1. Bottle Mascot entrance + idle floating/rocking
              final bottleScale = _interval(t, 0.00, 0.44, Curves.elasticOut);
              final bottleOpacity = _interval(t, 0.00, 0.14, Curves.easeOut);
              final bottleIntroTilt =
                  (1.0 - _interval(t, 0.00, 0.38, Curves.easeOutBack)) * -0.38;
              final bottleIdleDy = math.sin(idlePhase) * 5.0 * idleWeight;
              final bottleIdleTilt = math.sin(idlePhase) * 0.045 * idleWeight;

              // 2. Bottle Sparks ("Cue" rays above bottle)
              final bSparkScale = _interval(t, 0.24, 0.56, Curves.elasticOut);
              final bSparkOpacity = _interval(t, 0.24, 0.36, Curves.easeOut);
              final bSparkPulse =
                  1.0 + math.max(0.0, math.sin(idlePhase * 2)) * 0.15 * idleWeight;
              final bSparkWiggle =
                  math.sin(idlePhase * 2) * 0.06 * idleWeight;

              // 3. "Medi" wordmark
              final mediProgress = _interval(t, 0.28, 0.58, Curves.easeOutBack);
              final mediOpacity = _interval(t, 0.28, 0.44, Curves.easeOut);
              final mediDx = (1.0 - mediProgress) * -22.0;
              final mediDy = (1.0 - mediProgress) * 10.0;
              final mediScale = 0.72 + 0.28 * mediProgress;

              // 4. "Cue" wordmark
              final cueProgress = _interval(t, 0.40, 0.70, Curves.easeOutBack);
              final cueOpacity = _interval(t, 0.40, 0.56, Curves.easeOut);
              final cueDx = (1.0 - cueProgress) * 22.0;
              final cueDy = (1.0 - cueProgress) * 10.0;
              final cueScale = 0.72 + 0.28 * cueProgress;

              // 5. Capsule Pill inside "C" (spins 360 deg + bounces into place)
              final capScale = _interval(t, 0.50, 0.88, Curves.elasticOut);
              final capOpacity = _interval(t, 0.50, 0.62, Curves.easeOut);
              final capSpin =
                  (1.0 - _interval(t, 0.50, 0.82, Curves.easeOutCubic)) *
                      -2.0 *
                      math.pi;
              final capIdleRock =
                  math.sin(idlePhase + 1.3) * 0.10 * idleWeight;
              final capIdleScale =
                  1.0 + math.sin(idlePhase + 1.3) * 0.05 * idleWeight;

              // 6. Cue Sparks (above "C")
              final cSparkScale = _interval(t, 0.66, 0.96, Curves.elasticOut);
              final cSparkOpacity = _interval(t, 0.66, 0.78, Curves.easeOut);
              final cSparkPulse = 1.0 +
                  math.max(0.0, math.sin(idlePhase * 2 + math.pi * 0.5)) *
                      0.15 *
                      idleWeight;
              final cSparkWiggle =
                  math.cos(idlePhase * 2) * 0.06 * idleWeight;

              // 7. Teal Swoosh underline reveal (sweeps left -> right)
              final swooshReveal =
                  _interval(t, 0.56, 0.94, Curves.easeOutCubic);

              return Stack(
                fit: StackFit.expand,
                children: [
                  // Soft ambient aura glow behind the mascot bottle & C-capsule
                  if (widget.showAmbientGlow)
                    CustomPaint(
                      painter: _LogoAuraPainter(
                        introProgress: _interval(t, 0.1, 0.8, Curves.easeOut),
                        idlePhase: idlePhase,
                      ),
                    ),

                  // Layer 7 (underneath text): Swoosh underline with left-to-right draw clip
                  if (swooshReveal > 0.0)
                    ClipRect(
                      clipper: _HorizontalRevealClipper(
                        progress: swooshReveal,
                        minXFraction: 255 / 880,
                        maxXFraction: 705 / 880,
                      ),
                      child: Image.asset(
                        'assets/images/medicue_swoosh.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                  // Layer 3: "Medi"
                  if (mediOpacity > 0.0)
                    Opacity(
                      opacity: mediOpacity.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(mediDx, mediDy),
                        child: Transform.scale(
                          scale: mediScale,
                          alignment: _mediPivot,
                          child: Image.asset(
                            'assets/images/medicue_medi.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                  // Layer 4: "Cue"
                  if (cueOpacity > 0.0)
                    Opacity(
                      opacity: cueOpacity.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(cueDx, cueDy),
                        child: Transform.scale(
                          scale: cueScale,
                          alignment: _cuePivot,
                          child: Image.asset(
                            'assets/images/medicue_cue.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                  // Layer 5: Spinning Capsule inside "C"
                  if (capOpacity > 0.0)
                    Opacity(
                      opacity: capOpacity.clamp(0.0, 1.0),
                      child: Transform.rotate(
                        alignment: _capsulePivot,
                        angle: capSpin + capIdleRock,
                        child: Transform.scale(
                          alignment: _capsulePivot,
                          scale: capScale * capIdleScale,
                          child: Image.asset(
                            'assets/images/medicue_capsule.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                  // Layer 6: Cue Alert Sparks above "C"
                  if (cSparkOpacity > 0.0)
                    Opacity(
                      opacity: cSparkOpacity.clamp(0.0, 1.0),
                      child: Transform.rotate(
                        alignment: _cueSparksPivot,
                        angle: cSparkWiggle,
                        child: Transform.scale(
                          alignment: _cueSparksPivot,
                          scale: cSparkScale * cSparkPulse,
                          child: Image.asset(
                            'assets/images/medicue_cue_sparks.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                  // Layer 1: Mascot Pill Bottle + Orbit Ring + Clock
                  if (bottleOpacity > 0.0)
                    Opacity(
                      opacity: bottleOpacity.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, bottleIdleDy),
                        child: Transform.rotate(
                          alignment: _bottlePivot,
                          angle: bottleIntroTilt + bottleIdleTilt,
                          child: Transform.scale(
                            alignment: _bottlePivot,
                            scale: bottleScale,
                            child: Image.asset(
                              'assets/images/medicue_bottle.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Layer 2: Bottle Alert Sparks (follow bottle bob + extra pulse)
                  if (bSparkOpacity > 0.0)
                    Opacity(
                      opacity: bSparkOpacity.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, bottleIdleDy),
                        child: Transform.rotate(
                          alignment: _bottleSparksPivot,
                          angle: bSparkWiggle,
                          child: Transform.scale(
                            alignment: _bottleSparksPivot,
                            scale: bSparkScale * bSparkPulse,
                            child: Image.asset(
                              'assets/images/medicue_bottle_sparks.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HorizontalRevealClipper extends CustomClipper<Rect> {
  final double progress;
  final double minXFraction;
  final double maxXFraction;

  _HorizontalRevealClipper({
    required this.progress,
    required this.minXFraction,
    required this.maxXFraction,
  });

  @override
  Rect getClip(Size size) {
    final startX = size.width * minXFraction;
    final endX = size.width * maxXFraction;
    final currentRight = startX + (endX - startX) * progress.clamp(0.0, 1.0);
    return Rect.fromLTRB(0, 0, currentRight, size.height);
  }

  @override
  bool shouldReclip(covariant _HorizontalRevealClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}

class _LogoAuraPainter extends CustomPainter {
  final double introProgress;
  final double idlePhase;

  _LogoAuraPainter({
    required this.introProgress,
    required this.idlePhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (introProgress <= 0.0) return;

    final bottleCenter = Offset(size.width * 0.16, size.height * 0.54);
    final cueCenter = Offset(size.width * 0.72, size.height * 0.52);

    final pulse = 0.88 + 0.12 * math.sin(idlePhase);
    final baseRadius = size.height * 0.46 * introProgress * pulse;

    final bottleGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF0099FF).withValues(alpha: 0.18 * introProgress),
          const Color(0xFF00C8D8).withValues(alpha: 0.06 * introProgress),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: bottleCenter, radius: baseRadius));

    canvas.drawCircle(bottleCenter, baseRadius, bottleGlowPaint);

    final cueRadius = size.height * 0.36 * introProgress * (1.88 - pulse);
    final cueGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00C4D4).withValues(alpha: 0.16 * introProgress),
          const Color(0xFF0099FF).withValues(alpha: 0.04 * introProgress),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: cueCenter, radius: cueRadius));

    canvas.drawCircle(cueCenter, cueRadius, cueGlowPaint);
  }

  @override
  bool shouldRepaint(covariant _LogoAuraPainter oldDelegate) {
    return oldDelegate.introProgress != introProgress ||
        oldDelegate.idlePhase != idlePhase;
  }
}
