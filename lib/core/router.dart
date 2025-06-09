import 'package:alter/core/app_shell.dart';
import 'package:alter/feature/auth/view/login_page.dart';
import 'package:alter/feature/auth/view/sign_up/sign_up_info_page.dart';
import 'package:alter/feature/auth/view/sign_up/sign_up_last_page.dart';
import 'package:alter/feature/auth/view/sign_up/sign_up_page.dart';
import 'package:alter/feature/home/view/home_page.dart';
import 'package:alter/feature/home/view/posting_create_page.dart';
import 'package:alter/feature/home/view/posting_page.dart';
import 'package:alter/feature/home/view/search_page.dart';
import 'package:alter/feature/my_job/view/my_job_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _shellNavigatorKey = GlobalKey<NavigatorState>();

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
    // no bottom Nav
    GoRoute(
      path: '/create-posting',
      builder: (context, state) => const PostingCreatePage(),
    ),
    GoRoute(
      path: '/postings/:id',
      builder: (context, state) {
        final postId = state.pathParameters['id']!;
        return JobPostPage(postId: postId);
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
          routes: [
            GoRoute(
              path: '/postings',
              builder: (context, state) => const SearchPage(),
              // routes: [

              // ],
            ),
          ],
        ),
        GoRoute(
          path: '/my-job',
          builder: (context, state) => const MyJobPage(),
        ),
      ],
    ),
  ],
  // kakao login GoRoute 에러 해결
  redirect: (context, state) {
    final uri = state.uri;

    if (uri.scheme.contains('kakao') && uri.authority == 'oauth') {
      return '/login';
    }
    return null;
  },
);
