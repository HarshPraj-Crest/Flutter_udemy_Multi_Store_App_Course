import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ms_customer_app/auth/customer_login.dart';
import 'package:ms_customer_app/auth/customer_signup.dart';
import 'package:ms_customer_app/firebase_options.dart';
import 'package:ms_customer_app/main_screens/customer_home.dart';
import 'package:ms_customer_app/main_screens/onboarding_screen.dart';
import 'package:ms_customer_app/main_screens/welcome_screen.dart';
import 'package:ms_customer_app/providers/cart_provider.dart';
import 'package:ms_customer_app/providers/following_provider.dart';
import 'package:ms_customer_app/providers/id_provider.dart';
import 'package:ms_customer_app/providers/sql_helper.dart';
import 'package:ms_customer_app/providers/stripe_id.dart';
import 'package:ms_customer_app/providers/wish_provider.dart';
import 'package:ms_customer_app/services/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("Handling a background message: ${message.messageId}");
  print("Handling a background message: ${message.notification!.title}");
  print("Handling a background message: ${message.notification!.body}");
  print("Handling a background message: ${message.data}");
  print("Handling a background message: ${message.data['key1']}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  SQLHelper.getDatabase;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationServices.createNotificationChannelAndInitialize();
   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProvider(create: (_) => Wish()),
    ChangeNotifierProvider(create: (_) => IdProvider()),
    ChangeNotifierProvider(create: (_) => FollowingProvider(prefs: prefs)),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MultiStore App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const WelcomeScreen(),
      initialRoute: '/onboarding_screen',
      routes: {
        '/onboarding_screen': (context) => const OnboardingScreen(),
        '/welcome_screen': (context) => const WelcomeScreen(),
        '/customer_home': (context) => const CustomerHome(),
        '/customer_signup': (context) => const CustomerSignup(),
        '/customer_login': (context) => const CustomerLogin(),
      },
    );
  }
}
