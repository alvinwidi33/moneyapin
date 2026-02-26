
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moneyapin/views/add_page.dart';
import 'package:moneyapin/views/change_password_page.dart';
import 'package:moneyapin/views/dashboard_page.dart';
import 'package:moneyapin/views/login_page.dart';
import 'package:moneyapin/views/profile_page.dart';
import 'package:moneyapin/views/register_page.dart';
import 'package:moneyapin/views/reports_page.dart';
import 'package:moneyapin/views/wallet_page.dart';

class AppRoutes {
    final FirebaseAuth auth;

  AppRoutes(this.auth);

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final user = auth.currentUser;

    const publicRoutes = [
      '/login',
      '/register',
      '/wallets'
    ];

    if (user == null && !publicRoutes.contains(settings.name)) {
      return MaterialPageRoute(
        builder: (_) => const LoginPage(),
      );
    }

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );

      case '/register':
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
        );

      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        );

      case '/reports':
        return MaterialPageRoute(
          builder: (_) => const ReportsPage(),
        );

      case '/add':
        return MaterialPageRoute(
          builder: (_) => const AddPage(),
        );

      case '/wallets':
        return MaterialPageRoute(
          builder: (_) => const WalletPage(),
        );

      case '/profile':
        return MaterialPageRoute(
          builder: (_) => const ProfilePage(),
        );

      case '/change-password':
        return MaterialPageRoute(
          builder: (_) => const ChangePasswordPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
    }
  }
}