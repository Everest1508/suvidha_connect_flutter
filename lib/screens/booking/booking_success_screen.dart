import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer pulse
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent.withOpacity(0.1),
                    ),
                  ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.1, 1.1),
                        duration: 1000.ms,
                      ),
                  
                  // Inner circle
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent.withOpacity(0.2),
                    ),
                  ),
                  
                  // Check icon
                  Icon(
                    Iconsax.tick_circle5,
                    color: AppColors.accent,
                    size: 80,
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms).scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                curve: Curves.elasticOut,
                duration: 800.ms,
              ),
              
              const SizedBox(height: 32),
              
              // Success text
              Text(
                'SUCCESS!',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ).animate(delay: 300.ms).fadeIn(duration: 500.ms).moveY(begin: 20, end: 0),
              
              const SizedBox(height: 8),
              
              Text(
                'Your service has been booked successfully',
                style: TextStyle(
                  color: AppColors.mutedForeground,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ).animate(delay: 400.ms).fadeIn(duration: 500.ms).moveY(begin: 20, end: 0),
              
              const SizedBox(height: 48),
              
              // Track service button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/my-bookings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Track your service',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ).animate(delay: 500.ms).fadeIn(duration: 500.ms).moveY(begin: 20, end: 0),
              
              const SizedBox(height: 12),
              
              // Back to home button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/home'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: const Text(
                    'BACK TO HOME',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.foreground,
                    ),
                  ),
                ),
              ).animate(delay: 600.ms).fadeIn(duration: 500.ms).moveY(begin: 20, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}


