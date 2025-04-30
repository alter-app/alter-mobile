import 'package:alter/feature/auth/view/login_page.dart';
import 'package:alter/feature/auth/view/sign_up/sign_up_info_page.dart';
import 'package:alter/feature/auth/view/sign_up/sign_up_last_page.dart';
import 'package:alter/feature/auth/view/sign_up/sign_up_page.dart';
import 'package:alter/feature/home/home_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/login',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpPage(),
      routes: [
        GoRoute(
          path: '/info',
          builder: (context, state) => const SignUpInfoPage(),
        ),
        GoRoute(
          path: '/last',
          builder: (context, state) => const SignUpLastPage(),
        ),
      ],
    ),
    // Firebase Auth
    GoRoute(path: '/link', redirect: (context, state) => '/sign-up'),
    ShellRoute(
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      ],
    ),
  ],
);
