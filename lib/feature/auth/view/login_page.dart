import 'package:alter/common/util/logger.dart';
import 'package:alter/feature/auth/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:alter/common/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    // 로그인 성공 시 홈 화면으로 이동
    if (authState.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //context.go('/home');
        Log.d("message: 로그인 성공");
      });
    }

    return Scaffold(
      body: SafeArea(
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
              // 카카오 로그인
              GestureDetector(
                onTap: () {
                  ref.read(authViewModelProvider.notifier).loginWithKakao();
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
    );
  }
}
