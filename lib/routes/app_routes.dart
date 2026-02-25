
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moneyapin/views/dashboard_page.dart';
import 'package:moneyapin/views/login_page.dart';
import 'package:moneyapin/views/register_page.dart';

class AppRoutes {
    final FirebaseAuth auth;

  AppRoutes(this.auth);

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final user = auth.currentUser;

    const publicRoutes = [
      '/login',
      '/register',
      '/dashboard'
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

      // case '/detail-book':
      //   return MaterialPageRoute(
      //     builder: (_) => const DetailBook(),
      //     settings: settings,
      //   );

      // case '/history':
      //   return MaterialPageRoute(
      //     builder: (_) => const HistoryPage(),
      //   );

      // case '/detail-rent':
      //   return MaterialPageRoute(
      //     builder: (_) => const DetailRent(),
      //     settings: settings,
      //   );

      // case '/profile':
      //   return MaterialPageRoute(
      //     builder: (_) => const ProfilePage(),
      //   );

      // case '/dashboard':
      //   return MaterialPageRoute(
      //     builder: (_) => AdminGuard(
      //       auth: auth,
      //       child: DashboardPage(),
      //     ),
      //   );

      // case '/users':
      //   return MaterialPageRoute(
      //     builder: (_) => AdminGuard(
      //       auth: auth,
      //       child: UsersPage(),
      //     ),
      //   );

      // case '/rents-user':
      //   return MaterialPageRoute(
      //     builder: (_) => AdminGuard(
      //       auth: auth,
      //       child: RentUsersPage(),
      //     ),
      //     settings: settings,
      //   );

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