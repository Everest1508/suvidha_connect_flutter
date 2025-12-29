import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static String? _fcmToken;

  /// Initialize push notifications
  static Future<void> initialize() async {
    try {
      // Request permission for notifications
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ User granted notification permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('⚠️ User granted provisional notification permission');
      } else {
        print('❌ User declined or has not accepted notification permissions');
        return;
      }

      // Get FCM token
      _fcmToken = await _firebaseMessaging.getToken();
      if (_fcmToken != null) {
        print('📱 FCM Token: $_fcmToken');
        await _saveFcmToken(_fcmToken!);
        await _registerFcmToken(_fcmToken!);
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        print('🔄 FCM Token refreshed: $newToken');
        _fcmToken = newToken;
        _saveFcmToken(newToken);
        _registerFcmToken(newToken);
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('📬 Received foreground message: ${message.messageId}');
        print('   Title: ${message.notification?.title}');
        print('   Body: ${message.notification?.body}');
        print('   Data: ${message.data}');
        // You can show a local notification here if needed
      });

      // Handle background messages (when app is in background)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('📬 Opened app from notification: ${message.messageId}');
        print('   Title: ${message.notification?.title}');
        print('   Body: ${message.notification?.body}');
        print('   Data: ${message.data}');
        // Handle navigation based on notification data
      });

      // Check if app was opened from a notification
      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        print('📬 App opened from notification: ${initialMessage.messageId}');
        // Handle navigation based on notification data
      }
    } catch (e) {
      print('❌ Error initializing push notifications: $e');
    }
  }

  /// Save FCM token to local storage
  static Future<void> _saveFcmToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
    } catch (e) {
      print('❌ Error saving FCM token: $e');
    }
  }

  /// Register FCM token with backend
  static Future<void> _registerFcmToken(String token) async {
    try {
      final result = await ApiService.registerFcmToken(token);
      if (result['success'] == true) {
        print('✅ FCM token registered with backend');
      } else {
        print('❌ Failed to register FCM token: ${result['error']}');
      }
    } catch (e) {
      print('❌ Error registering FCM token: $e');
    }
  }

  /// Get current FCM token
  static String? getFcmToken() {
    return _fcmToken;
  }

  /// Re-register FCM token (useful after login)
  static Future<void> reRegisterToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      if (_fcmToken != null) {
        await _saveFcmToken(_fcmToken!);
        await _registerFcmToken(_fcmToken!);
      }
    } catch (e) {
      print('❌ Error re-registering FCM token: $e');
    }
  }
}

/// Top-level function for handling background messages
/// This must be a top-level function, not a class method
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📬 Handling background message: ${message.messageId}');
  print('   Title: ${message.notification?.title}');
  print('   Body: ${message.notification?.body}');
  print('   Data: ${message.data}');
}
