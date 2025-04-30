import 'package:alter/common/util/logger.dart';
import 'package:alter/feature/auth/view_model/login_view_model.dart';
import 'package:alter/feature/auth/view_model/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:alter/common/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          Log.i("State: Login Success");
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
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "알터",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const Gap(70),
                  GestureDetector(
                    onTap:
                        isLoading
                            ? null
                            : () {
                              ref
                                  .read(loginViewModelProvider.notifier)
                                  .loginWithKakao();
                            },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE500),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "kakao 로그인",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const Gap(8),
                  // 애플 로그인
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColor.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "애플 로그인",
                          style: TextStyle(
                            color: AppColor.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
