import 'package:alter/feature/auth/view/login_page.dart';
import 'package:alter/feature/auth/view/sign_up/sign_up_info_page.dart';
import 'package:alter/feature/auth/view/sign_up/sign_up_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/sign-up',
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
      ],
    ),
  ],
);
