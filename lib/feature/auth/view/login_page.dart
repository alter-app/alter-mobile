import 'package:alter/common/util/logger.dart';
import 'package:alter/feature/auth/view_model/login_view_model.dart';
import 'package:alter/feature/auth/view_model/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(loginViewModelProvider);

    ref.listen<LoginState>(loginViewModelProvider, (previous, next) {
      switch (next.status) {
        case LoginStatus.success:
          context.go("/home");
          break;
        case LoginStatus.signupRequired:
          Log.i("State: SignupRequired");
          ref
              .read(signUpViewModelProvider.notifier)
              .initializeWithSignupData(next.signupData!);
          context.push('/sign-up');
          break;
        case LoginStatus.tokenExpired:
          Log.i("State: TokenExpired");
          // TODO : 토스트 UI 개선
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.message!)));
          break;
        case LoginStatus.fail:
          Log.i("State: Login Fail");
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.message!)));
          break;
        case LoginStatus.initial:
          Log.i("State: Login Initial");
          break;
        case LoginStatus.loading:
          Log.i("State: Login Loading");
          break;
      }
    });

    final isLoading = authState.status == LoginStatus.loading;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/logo_with_text.svg'),
                const Gap(10),
                GestureDetector(
                  onTap:
                      isLoading
                          ? null
                          : () {
                            ref
                                .read(loginViewModelProvider.notifier)
                                .loginWithKakao();
                          },
                  child: SvgPicture.asset(
                    'assets/images/kakao_login.svg',
                    height: 56,
                  ),
                ),
                const Gap(8),
                // 애플 로그인
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    "assets/images/apple_login.svg",
                    height: 56,
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
