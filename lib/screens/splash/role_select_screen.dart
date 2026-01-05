import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_extensions.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // Top section with illustration
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated icon container with gradient background
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withOpacity(0.3),
                          AppColors.primary.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer rotating circle
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                        )
                            .animate(onPlay: (controller) => controller.repeat())
                            .rotate(
                              duration: 8000.ms,
                              curve: Curves.linear,
                            ),
                        // Inner pulsing circle
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withOpacity(0.1),
                          ),
                        )
                            .animate(onPlay: (controller) => controller.repeat())
                            .scale(
                              begin: const Offset(1.0, 1.0),
                              end: const Offset(1.2, 1.2),
                              duration: 2000.ms,
                              curve: Curves.easeInOut,
                            )
                            .then()
                            .scale(
                              begin: const Offset(1.2, 1.2),
                              end: const Offset(1.0, 1.0),
                              duration: 2000.ms,
                              curve: Curves.easeInOut,
                            ),
                        // Main icon
                        Icon(
                          Icons.handshake_rounded,
                          size: 64,
                          color: AppColors.foreground.withOpacity(0.9),
                        )
                            .animate(onPlay: (controller) => controller.repeat())
                            .moveY(
                              begin: 0,
                              end: -8,
                              duration: 1200.ms,
                              curve: Curves.easeInOut,
                            )
                            .then()
                            .moveY(
                              begin: -8,
                              end: 0,
                              duration: 1200.ms,
                              curve: Curves.easeInOut,
                            ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Welcome text
                  Text(
                    'Welcome to Sahayak',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .moveY(begin: 10, end: 0, duration: 600.ms, delay: 200.ms),
                  const SizedBox(height: 8),
                  Text(
                    'Connect with trusted service providers',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 400.ms)
                      .moveY(begin: 10, end: 0, duration: 600.ms, delay: 400.ms),
                ],
              ),
            ),
          ),

          // Bottom section with role selection
          Container(
            decoration: BoxDecoration(
              color: context.backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter as a...',
                  style: TextStyle(
                    color: context.mutedForegroundColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),

                // Service Provider Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go('/login?role=provider'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      side: BorderSide(color: context.borderColor, width: 1.5),
                    ),
                    child: Text(
                      'Service Provider',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: context.foregroundColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Service Consumer Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go('/login?role=customer'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      side: BorderSide(color: context.borderColor, width: 1.5),
                    ),
                    child: Text(
                      'Service Consumer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: context.foregroundColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).moveY(begin: 50, end: 0, duration: 500.ms),
        ],
      ),
    );
  }
}


