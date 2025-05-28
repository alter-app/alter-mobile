import 'package:alter/feature/auth/view/login_page.dart';
import 'package:alter/feature/auth/view/sign_up/sign_up_info_page.dart';
import 'package:alter/feature/auth/view/sign_up/sign_up_last_page.dart';
import 'package:alter/feature/auth/view/sign_up/sign_up_page.dart';
import 'package:alter/feature/home/view/home_page.dart';
import 'package:alter/feature/home/view/posting_create_page.dart';
import 'package:alter/feature/home/view/posting_page.dart';
import 'package:alter/feature/home/view/search_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/home',
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
    // page work
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
    GoRoute(
      path: '/posting/:id',
      builder: (context, state) {
        final postId = state.pathParameters['id']!;
        return JobPostPage(postId: postId);
      },
    ),
    GoRoute(
      path: '/create-posting',
      builder: (context, state) => const PostingCreatePage(),
    ),
    // ShellRoute(
    //   routes: [
    //     GoRoute(
    //       path: '/home', // 여기에 네비게이션 들어가야함
    //       builder: (context, state) => const HomePage(),
    //       routes: [
    //         GoRoute(
    //           path: '/search',
    //           builder: (context, state) => const SearchPage(),
    //         ),
    //       ],
    //     ),
    //   ],
    // ),
  ],
  redirect: (context, state) {
    final uri = state.uri;

    if (uri.scheme.contains('kakao') && uri.authority == 'oauth') {
      return '/login';
    }
    return null;
  },
);
