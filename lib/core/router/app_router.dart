import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/splash/splash_screen.dart';
import '../../screens/splash/role_select_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/auth/provider_onboarding_screen.dart';
import '../../screens/auth/onboarding/onboarding_step1_screen.dart';
import '../../screens/auth/onboarding/onboarding_step2_screen.dart';
import '../../screens/auth/onboarding/onboarding_step3_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/home/my_services_screen.dart';
import '../../screens/explore/explore_screen.dart';
import '../../screens/provider_detail/provider_detail_screen.dart';
import '../../screens/booking/booking_success_screen.dart';
import '../../screens/booking/create_booking_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/saved/saved_services_screen.dart';
import '../../screens/requests/provider_requests_screen.dart';
import '../../screens/bookings/my_bookings_screen.dart';
import '../../screens/addresses/saved_addresses_screen.dart';
import '../../screens/addresses/add_address_screen.dart';
import '../../screens/reviews/reviews_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../widgets/bottom_nav.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Splash Screen
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),

    // Role Select
    GoRoute(
      path: '/role-select',
      builder: (context, state) => const RoleSelectScreen(),
    ),

    // Provider Onboarding (Old - kept for backward compatibility)
    GoRoute(
      path: '/provider-onboarding',
      builder: (context, state) => const ProviderOnboardingScreen(),
    ),

    // Provider Onboarding Steps
    GoRoute(
      path: '/provider-onboarding/step1',
      builder: (context, state) => const OnboardingStep1Screen(),
    ),
    GoRoute(
      path: '/provider-onboarding/step2',
      builder: (context, state) => const OnboardingStep2Screen(),
    ),
    GoRoute(
      path: '/provider-onboarding/step3',
      builder: (context, state) => const OnboardingStep3Screen(),
    ),

    // Login
    GoRoute(
      path: '/login',
      builder: (context, state) {
        final role = state.uri.queryParameters['role'];
        return LoginScreen(role: role);
      },
    ),

    // Signup
    GoRoute(
      path: '/signup',
      builder: (context, state) {
        final role = state.uri.queryParameters['role'];
        return SignupScreen(role: role);
      },
    ),

    // Main App Shell with Bottom Navigation
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainShell(child: child);
      },
      routes: [
        // Home
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),

        // Saved Services
        GoRoute(
          path: '/saved',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SavedServicesScreen(),
          ),
        ),

        // My Services
        GoRoute(
          path: '/services',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MyServicesScreen(),
          ),
        ),

        // Notifications
        GoRoute(
          path: '/notifications',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: NotificationsScreen(),
          ),
        ),

        // Profile
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),

        // Provider Requests
        GoRoute(
          path: '/requests',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProviderRequestsScreen(),
          ),
        ),

        // My Bookings
        GoRoute(
          path: '/my-bookings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MyBookingsScreen(),
          ),
        ),

        // Saved Addresses
        GoRoute(
          path: '/addresses',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SavedAddressesScreen(),
          ),
        ),

        // Add Address
        GoRoute(
          path: '/add-address',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AddAddressScreen(),
          ),
        ),

        // Reviews
        GoRoute(
          path: '/reviews',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ReviewsScreen(),
          ),
        ),

        // Settings
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(),
          ),
        ),
      ],
    ),

    // Explore (outside shell for different nav behavior)
    GoRoute(
      path: '/explore/:serviceId',
      builder: (context, state) {
        final serviceId = state.pathParameters['serviceId'] ?? '';
        return ExploreScreen(serviceId: serviceId);
      },
    ),

    // Provider Detail
    GoRoute(
      path: '/provider/:providerId',
      builder: (context, state) {
        final providerId = state.pathParameters['providerId'] ?? '';
        return ProviderDetailScreen(providerId: providerId);
      },
    ),

    // Create Booking (outside shell)
    GoRoute(
      path: '/create-booking/:providerId',
      builder: (context, state) {
        final providerId = state.pathParameters['providerId'] ?? '';
        final serviceCategoryId = state.uri.queryParameters['serviceCategoryId'];
        final serviceName = state.uri.queryParameters['serviceName'];
        return CreateBookingScreen(
          providerId: providerId,
          serviceCategoryId: serviceCategoryId,
          serviceName: serviceName,
        );
      },
    ),

    // Booking Success (outside shell)
    GoRoute(
      path: '/booking-success',
      builder: (context, state) => const BookingSuccessScreen(),
    ),
  ],
);

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/saved')) return 1;
    if (location.startsWith('/services')) return 2;
    if (location.startsWith('/notifications')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNav(
        currentIndex: _calculateSelectedIndex(context),
      ),
    );
  }
}


