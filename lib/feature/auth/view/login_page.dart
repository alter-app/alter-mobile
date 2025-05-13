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
      switch (next) {
        case LoginSuccess(token: final token):
          Log.i("State: Login Success : ${token.toString()}");
          context.go("/home");
          break;
        case LoginSignupRequired(data: final data):
          Log.i("State: SignupRequired");
          ref
              .read(signUpViewModelProvider.notifier)
              .initializeWithSignupData(data);
          context.push('/sign-up');
          break;
        case LoginTokenExpired():
          Log.i("State: TokenExpired");
          // TODO : 토스트 UI 개선
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('소셜 토큰이 만료되었습니다. 다시 시도해주세요.')),
          );
          break;
        case LoginFail(message: final message):
          Log.i("State: Login Fail");
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
          break;
        case LoginInitial():
          Log.i("State: Login Initial");
          break;
        case LoginLoading():
          Log.i("State: Login Loading");
          break;
      }
    });

    final isLoading = authState is LoginLoading;

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
